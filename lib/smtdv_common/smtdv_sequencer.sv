
`ifndef __SMTDV_SEQUENCER_SV__
`define __SMTDV_SEQUENCER_SV__

class smtdv_sequencer #(type REQ = uvm_sequence_item, type RSP = REQ) extends smtdv_component#(uvm_sequencer#(REQ, RSP));

  `uvm_sequencer_param_utils(smtdv_sequencer#(REQ, RSP))

  function new(string name = "smtdv_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  endfunction

  extern virtual function void smtdv_sequencer_cleanup();

endclass : smtdv_sequencer


function void smtdv_sequencer::smtdv_sequencer_cleanup();
  foreach(reg_sequences[i]) begin
    // Only stop those sequences with get_sequencer() equal to this sequencer
    if(reg_sequences[i].get_sequencer() == this) begin
      kill_sequence(reg_sequences[i]);
      end
    end
  sequence_item_requested= 0;
  get_next_item_called= 0;
  m_req_fifo.flush();
  `uvm_info(get_full_name(), "Clean up all running sequences & items", UVM_LOW)
endfunction

`endif // end of __SMTDV_SEQUENCER_SV__
