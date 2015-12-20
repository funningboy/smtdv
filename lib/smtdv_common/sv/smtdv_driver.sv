
`ifndef __SMTDV_DRIVER_SV__
`define __SMTDV_DRIVER_SV__

typedef class smtdv_cfg;
typedef class smtdv_thread_handler;
typedef class smtdv_component;
typedef class smtdv_force_vif;

/**
* smtdv_dirver
* a basic smtdv driver to hanlder seq drive
*
* @class smtdv_component#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, REQ, RSP)
*
*/
class smtdv_driver #(
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

  typedef smtdv_driver#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, REQ, RSP) drv_t;

  // as backend threads/handler
  smtdv_force_vif #(drv_t) b0;
  smtdv_thread_handler #(drv_t) bk_handler;

  `uvm_component_param_utils_begin(drv_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // build backend threads
    bk_handler = smtdv_thread_handler#(drv_t)::type_id::create("smtdv_backend_threads", this);
    b0 = smtdv_force_vif#(drv_t)::type_id::create("smtdv_force_vif", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    b0.cmp = this; this.bk_handler.add(b0);
  endfunction : connect_phase

  extern virtual task run_phase(uvm_phase phase);

  extern virtual task reset_driver();

  extern virtual task get_item(ref REQ item);
  extern virtual task drive_bus();
  extern virtual task item_done(RSP item = null);
  extern virtual task run_threads();

endclass : smtdv_driver


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
            get_item(req);
            drive_bus();
            item_done(rsp);

            // respone queue will been blocked at rsp not has been deasserted
            // UVM_ERROR: Response queue overflow, response was dropped
            //seq_item_port.get_next_item(req);
            //$cast(rsp, req.clone());
            //rsp.set_id_info(req);
            //drive_bus();
            //seq_item_port.item_done(rsp);
          end
        end
      join_any

      run_threads();
    join
    disable fork;

    if((req != null) && (req.is_active())) this.end_tr(req);
    end
endtask


task smtdv_driver::run_threads();
  bk_handler.run();
endtask


task smtdv_driver::reset_driver();
endtask


task smtdv_driver::get_item(ref REQ item);
  seq_item_port.get_next_item(item);
endtask


task smtdv_driver::drive_bus();
endtask


task smtdv_driver::item_done(RSP item = null);
  seq_item_port.item_done(item);
endtask


//class smtdv_master_driver

`endif // end of __SMTDV_DRIVER_SV__
