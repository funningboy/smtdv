
`ifndef __SMTDV_EVENT_SV__
`define __SMTDV_EVENT_SV__

// *********************************************************************
class smtdv_run_thread extends uvm_object;

  smtdv_component cmp;
  bit [0:0] has_finalize = 0;
  // status run, idle, dead...

  `uvm_object_param_utils_begin(smtdv_run_thread)
    `uvm_field_int(has_finalize, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_run_thread", smtdv_component cmp=null);
    super.new(name);
    cmp = cmp;
  endfunction

  virtual task run();
    `uvm_info(get_full_name(),
      $sformatf("Starting run thread ..."),
      UVM_HIGH)
  endtask

endclass

`endif // __SMTDV_EVENT_SV__
