
`ifndef __SMTDV_READY_NOTIFY_THREADS_SV__
`define __SMTDV_READY_NOTIFY_THREADS_SV__

typedef class smtdv_monitor;

/*
* smtdv_ready_notify
* as backend task to note top vsequencer while ready is asserted
* register to monitor module
*/
class smtdv_ready_notify#(
  type CMP = smtdv_monitor
  ) extends
  smtdv_run_thread#(CMP);

  typedef smtdv_ready_notify#(CMP) ready_notf_t;

  bit ready = FALSE;

  `uvm_object_param_utils_begin(ready_notf_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_ready_notify", CMP parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function bit is_ready();
  extern virtual task async_get_ready();
  extern virtual task run();

endclass : smtdv_ready_notify

/*
* should be imp at top class
* ex: apb_collect_stop_signal
*/
task smtdv_ready_notify::run();
endtask : run


function bit smtdv_ready_notify::is_ready();
  return ready == TRUE;
endfunction : is_ready


task smtdv_ready_notify::async_get_ready();
  wait(is_ready());
endtask : async_get_ready


`endif // __SMTDV_READY_NOTIFY_THREADS_SV__
