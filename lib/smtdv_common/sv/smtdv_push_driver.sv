
`ifndef __SMTDV_PUSH_DRIVER_SV__
`define __SMTDV_PUSH_DRIVER_SV__

class smtdv_push_driver#(
  type REQ = uvm_sequence_item,
  type RSP = REQ)
  extends
    smtdv_component#(uvm_push_driver#(REQ, RSP));

  `uvm_component_param_utils(smtdv_push_driver#(REQ, RSP))

  function new(string name = "smtdv_push_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : smtdv_push_driver

`endif // end of __SMTDV_PUSH_DRIVER_SV__
