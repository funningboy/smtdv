
`ifndef __SMTDV_SEQUENCER_SV__
`define __SMTDV_SEQUENCER_SV__

typedef class smtdv_cfg;
typedef class smtdv_sequence_item;
typedef class smtdv_component;

/**
* smtdv_sequencer
* a basic smtdv_sequencer
*
* @class smtdv_sequencer
*
*/
class smtdv_sequencer#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_cfg,
  type REQ = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type RSP = REQ
  ) extends
    smtdv_component#(uvm_sequencer#(REQ, RSP));

  typedef smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, REQ, RSP) seqr_t;

  VIF vif;
  CFG cfg;

  // get transfer from slave monitor
  uvm_blocking_get_port#(REQ) mon_get_port;

  // register notify event here, that can be used for notify event to top
  // virtual sequencer or top physical sequencer

  `uvm_sequencer_param_utils_begin(seqr_t)
  `uvm_sequencer_utils_end

  function new(string name = "smtdv_sequencer", uvm_component parent);
    super.new(name, parent);
    mon_get_port =  new("mon_get_port", this);
  endfunction : new

  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void cleanup();
  extern virtual function void reorder(ref REQ iitem, int indx);
  extern virtual task reset_restart_sqr(uvm_phase phase);

endclass : smtdv_sequencer

/**
 * drive tlm item to driver
 */
task smtdv_sequencer::run_phase(uvm_phase phase);
  fork
    super.run_phase(phase);
  join_none

  reset_restart_sqr(phase);
endtask : run_phase

/**
 * reset_restart_sequencer while resetn asserted
 */
task smtdv_sequencer::reset_restart_sqr(uvm_phase phase);
  while(1) begin
    @(negedge resetn);
    m_req_fifo.flush();

    stop_sequences();
    wait(resetn == 1);
    start_phase_sequence(phase);
  end
endtask : reset_restart_sqr

/**
 * clean up sequencer fifo
 * @return void
 */
function void smtdv_sequencer::cleanup();
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
endfunction : cleanup

/**
* reorder sequencer fifo while some urgent item put
*
*  //
*  // Specifies the arbitration mode for the sequencer. It is one of
*  //
*  // SEQ_ARB_FIFO          - Requests are granted in FIFO order (default)
*  // SEQ_ARB_WEIGHTED      - Requests are granted randomly by weight
*  // SEQ_ARB_RANDOM        - Requests are granted randomly
*  // SEQ_ARB_STRICT_FIFO   - Requests at highest priority granted in fifo order
*  // SEQ_ARB_STRICT_RANDOM - Requests at highest priority granted in randomly
*  // SEQ_ARB_USER          - Arbitration is delegated to the user-defined
*  //                         function, user_priority_arbitration. That function
*  //                         will specify the next sequence to grant.
*
* @return void
*/
function void smtdv_sequencer::reorder(ref REQ iitem, int indx);
//  m_req_fifo.size();
//  m_req_fifo.can_put()
//  m_req_fifo.put()...
endfunction : reorder

`endif // end of __SMTDV_SEQUENCER_SV__
