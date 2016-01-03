`ifndef __SMTDV_MASTER_BASE_SEQ_SV__
`define __SMTDV_MASTER_BASE_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;
//typedef class smtdv_sequence;

/**
* smtdv_master_base_seq
* a basic master seq
*
* @class smtdv_master_base_seq #(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR)
*
*/
class smtdv_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1)
  ) extends
    smtdv_sequence#(T1);

    typedef smtdv_master_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;

    T1 item;  // default item
    T1 mitem; // item from mon
    T1 bitem; // item from mbox
    mailbox #(T1) mbox;
    SEQR seqr;

    rand int retry_delay;

    constraint c_retry_delay { retry_delay inside {[2:10]}; }

    `uvm_object_param_utils_begin(seq_t)
    `uvm_object_utils_end

    function new(string name = "smtdv_master_base_seq");
      super.new(name);
      mbox = new();
    endfunction

    virtual task pre_body();
      super.pre_body();
      // m_sequencer == this.get_sequencer()
      //$cast(seqr, m_sequencer);
      $cast(seqr, this.get_sequencer());
    endtask : pre_body

endclass : smtdv_master_base_seq


`endif // end of __SMTDV_MASTER_BASE_SEQ_SV__
