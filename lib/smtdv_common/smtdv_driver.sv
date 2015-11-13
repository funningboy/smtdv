
`ifndef __SMTDV_DRIVER_SV__
`define __SMTDV_DRIVER_SV__

class smtdv_driver #(type VIF = int,
                    type CFG = uvm_object,
                    type REQ = uvm_sequence_item,
                    type RSP = REQ
                    ) extends smtdv_component#(uvm_driver#(REQ, RSP));

  VIF vif;
  CFG cfg;

  smtdv_thread_handler #(CFG) th_handler;

  `uvm_component_param_utils_begin(smtdv_driver#(VIF, CFG))
    // Cadence doesn't support this registration
    //`uvm_field_queue_object(thread_q, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th_handler = smtdv_thread_handler#(CFG)::type_id::create("smtdv_driver_threads", this);
  endfunction

  extern virtual task run_phase(uvm_phase phase);

  extern virtual task reset_driver();

  extern virtual task get_item(ref REQ item);
  extern virtual task drive_bus();
  extern virtual task item_done(RSP item = null);

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
            // get next req item
            get_item(req);
            drive_bus();
            item_done(rsp);

            // respone queue will been blocked at rsp not been deasserted
            // UVM_ERROR: Response queue overflow, response was dropped
            //seq_item_port.get_next_item(req);
            //$cast(rsp, req.clone());
            //rsp.set_id_info(req);
            //drive_bus();
            //seq_item_port.item_done(rsp);
          end
        end
      join_any

      th_handler.run();
    join
    disable fork;

    if((req != null) && (req.is_active())) this.end_tr(req);
    end
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

`endif // end of __SMTDV_DRIVER_SV__
