
`ifndef __SMTDV_PUSH_SEQUENCER_SV__
`define __SMTDV_PUSH_SEQUENCER_SV__

class smtdv_push_sequencer #(type REQ = uvm_sequence_item, type RSP = REQ) extends smtdv_component#(uvm_push_sequencer#(REQ, RSP));

  `uvm_component_param_utils(smtdv_push_sequencer#(REQ, RSP))

  function new(string name = "smtdv_push_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : smtdv_push_sequencer

`endif // end of __SMTDV_PUSH_SEQUENCER_SV__
