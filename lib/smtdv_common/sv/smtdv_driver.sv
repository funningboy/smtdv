
`ifndef __SMTDV_DRIVER_SV__
`define __SMTDV_DRIVER_SV__

typedef class smtdv_cfg;
typedef class smtdv_thread_handler;
typedef class smtdv_component;
typedef class smtdv_force_vif;
typedef class smtdv_master_cfg;

/**
* smtdv_dirver
* a basic smtdv driver to hanlder seq drive
*
* @class smtdv_component#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, REQ, RSP)
*
*/
class smtdv_driver#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_cfg,
  type REQ = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type RSP = REQ)
  extends
    smtdv_component#(uvm_driver#(REQ, RSP));

  VIF vif;
  CFG cfg;
  REQ item, ritem;

  typedef smtdv_driver#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, REQ, RSP) drv_t;
  typedef smtdv_thread_handler#(drv_t) hdler_t;
  typedef smtdv_force_vif#(drv_t) force_t;
  typedef smtdv_rsp_back#(ADDR_WIDTH, DATA_WIDTH, drv_t, REQ) rsp_back_t;
  typedef smtdv_queue#(REQ) item_q_t;
  typedef smtdv_master_cfg mst_cfg_t;

  // get transfer from slave monitor
  uvm_blocking_get_port#(REQ) mon_get_port;

  // as backend threads/handler
  force_t b0;
  rsp_back_t b1;
  hdler_t bk_handler;

  item_q_t bbox;  // backdoor
  mst_cfg_t mst_cfg;

  `uvm_component_param_utils_begin(drv_t)
    `uvm_field_object(b0, UVM_ALL_ON)
    `uvm_field_object(b1, UVM_ALL_ON)
    `uvm_field_object(bk_handler, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_driver", uvm_component parent=null);
    super.new(name, parent);
    mon_get_port =  new("mon_get_port", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    bbox = item_q_t::type_id::create("smtdv_bbox");

    // build backend threads
    bk_handler = hdler_t::type_id::create("smtdv_backend_handler", this);
    b0 = force_t::type_id::create("smtdv_force_vif", this);
    b1 = rsp_back_t::type_id::create("smtdv_rsp_back", this);

    `SMTDV_RAND(bk_handler)
    `SMTDV_RAND(b0)
    `SMTDV_RAND(b1)
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    b0.register(this); bk_handler.add(b0);
    b1.register(this); bk_handler.add(b1);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    bk_handler.register(this);
    bk_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task run_phase(uvm_phase phase);
  extern virtual task update_rsp_back(REQ ritem, REQ mitem);
  extern virtual task reset_driver();
  extern virtual task drive_bus();
  extern virtual task run_threads();

endclass : smtdv_driver

// override at top level
task smtdv_driver::update_rsp_back(REQ ritem, REQ mitem);
   ritem.data_beat = mitem.data_beat;
   ritem.rsp = mitem.rsp;
endtask : update_rsp_back

task smtdv_driver::run_phase(uvm_phase phase);
  fork
    super.run_phase(phase);
  join_none

  forever begin
    reset_driver();
    wait(resetn);

    fork
      fork
        begin
          @(negedge resetn);
        end

        begin
          forever begin: get_item_from_sqr
            // align to posege clk to drive
            @(posedge vif.clk iff (vif.clk));

            seq_item_port.get_next_item(req);

            if (!$cast(rsp, req.clone()))
                `uvm_error("SMTDV_DCAST_RSP/REQ",
                    {$psprintf("DOWN CAST TO REQ/RSP FAIL")})

            rsp.set_id_info(req); bbox.async_push_back(req, 0);
            drive_bus();
            seq_item_port.item_done();
            // should imp get_response(rsp) at seq to note rsp item done
            // default we will pass rsp return
            //seq_item_port.item_done(rsp)
          end
        end
      join_any

      run_threads();
    join
    disable fork;

    if((req != null) && (req.is_active())) this.end_tr(req);
    end
endtask : run_phase


task smtdv_driver::run_threads();
  bk_handler.run();
  bk_handler.watch();
endtask : run_threads

/*
*  must be overridden at top main dirver
*/
task smtdv_driver::reset_driver();
  bbox.delete();
  bk_handler.reset();
endtask : reset_driver

/*
* must be overridden at top main driver
*/
task smtdv_driver::drive_bus();
endtask : drive_bus


//class smtdv_master_driver

`endif // end of __SMTDV_DRIVER_SV__
