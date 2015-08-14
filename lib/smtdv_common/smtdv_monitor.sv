
`ifndef __SMTDV_MONITOR_SV__
`define __SMTDV_MONITOR_SV__

class smtdv_monitor #(type VIF = int,
                     type CFG = smtdv_cfg)
                extends smtdv_component#(uvm_monitor);

  VIF vif;
  CFG cfg;

  smtdv_thread_handler#(CFG) th_handler;

  `uvm_component_param_utils_begin(smtdv_monitor#(VIF, CFG))
    // Cadence doesn't support this registration
    //`uvm_field_queue_object(thread_q, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th_handler = smtdv_thread_handler#(CFG)::type_id::create("smtdv_monitor_threads", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    if(!th_handler)
      `uvm_warning("NOTHREADHANDLER",{"thread handler create fail: ",get_full_name()});
  endfunction

  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset_monitor();

endclass : smtdv_monitor


task smtdv_monitor::run_phase(uvm_phase phase);
  begin
  fork
    super.run_phase(phase);
    join_none

  while(1) begin
    reset_monitor();
    wait(resetn);
    fork
      fork
        begin
          @(negedge resetn);
        end
      join_any

      if (th_handler)
        th_handler.run();
    join
    disable fork;
    end
  end
endtask


task smtdv_monitor::reset_monitor();
endtask


`endif // end of __SMTDV_MONITOR_SV__
