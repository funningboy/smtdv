
`ifndef __SMTDV_BACKDOOR_SV__
`define __SMTDV_BACKDOOR_SV__

class smtdv_backdoor
  extends
  smtdv_component#(uvm_component);

  smtdv_backdoor_event_t cb_map[string] = `SMTDV_CB_EVENT
  int timeout = 2;
  bit debug = TRUE;
  bit status = TRUE;

  `uvm_component_param_utils_begin(smtdv_backdoor)
    `uvm_field_int(timeout, UVM_ALL_ON)
  `uvm_component_utils_end

  function new (string name = "smtdv_backdoor", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // __SMTDV_BACKDOOR_SV__
