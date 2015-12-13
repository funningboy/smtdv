
`ifndef __SMTDV_SEQUENCER_SV__
`define __SMTDV_SEQUENCER_SV__

class smtdv_sequencer #(
  type REQ = uvm_sequence_item,
  type RSP = REQ
  ) extends
    smtdv_component#(uvm_sequencer#(REQ, RSP));

  `uvm_sequencer_param_utils(smtdv_sequencer#(REQ, RSP))

  function new(string name = "smtdv_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
  endfunction

    virtual task run_phase(uvm_phase phase);
      fork
        super.run_phase(phase);
        join_none

      reset_restart_sqr(phase);
    endtask

    virtual task reset_restart_sqr(uvm_phase phase);
      while(1) begin
        @(negedge resetn);
        m_req_fifo.flush();

        stop_sequences();
        wait(resetn == 1);
        start_phase_sequence(phase);
        end
    endtask

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


class smtdv_master_sequencer #(
  type REQ = uvm_sequence_item,
  type RSP = REQ
  )extends
    smtdv_sequencer #(REQ, RSP);

  `uvm_sequencer_param_utils(smtdv_master_sequencer#(REQ, RSP))

  function new(string name = "smtdv_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass


class smtdv_slave_sequencer #(
  type REQ = uvm_sequence_item,
  type RSP = REQ
  )extends
    smtdv_sequencer #(REQ, RSP);

  `uvm_sequencer_param_utils(smtdv_slave_sequencer#(REQ, RSP))

    // get transfer from apb slave monitor
    uvm_blocking_get_port #(REQ) mon_get_port;

  function new(string name = "smtdv_sequencer", uvm_component parent);
    super.new(name, parent);
    mon_get_port= new("mon_get_port", this);
  endfunction


endclass


`endif // end of __SMTDV_SEQUENCER_SV__
