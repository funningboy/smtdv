`ifndef __SMTDV_MASTER_BASE_SEQ_SV__
`define __SMTDV_MASTER_BASE_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;
//typedef class smtdv_sequence;
//typedef class smtdv_seq_node;

/**
* smtdv_master_base_seq
* a basic master seq
*
* @class smtdv_master_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR)
*
*/
class smtdv_master_base_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type NODE = smtdv_seq_node#(uvm_object, uvm_component)
  ) extends
    smtdv_sequence#(T1);

    typedef smtdv_master_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR, NODE) seq_t;

    T1 item;  // default item
    T1 mitem; // item from mon
    T1 bitem; // item from mbox
    mailbox#(T1) mbox;
    SEQR seqr;
    NODE node;

    rand int retry_delay;

    constraint c_retry_delay { retry_delay inside {[2:10]}; }

    `uvm_object_param_utils_begin(seq_t)
    `uvm_object_utils_end

    function new(string name = "smtdv_master_base_seq");
      super.new(name);
      mbox = new();
    endfunction : new

    virtual function void set(NODE inode);
      node = inode;
    endfunction : set

    virtual task pre_body();
      super.pre_body();
      // m_sequencer == this.get_sequencer()
      //$cast(seqr, m_sequencer);
      $cast(seqr, this.get_sequencer());

      if (node==null)
        `uvm_warning("SMTDV_MASTER_BASE_SEQ",
            $psprintf({"find null seq_node, please register seq_node first if needed"}))

      if (node)
        node.pre_do();
    endtask : pre_body

    virtual task body();
      if (node)
        node.mid_do();
    endtask : body

    virtual task post_body();
      super.post_body();
      if (node)
        node.post_do();
    endtask : post_body

endclass : smtdv_master_base_seq


`endif // end of __SMTDV_MASTER_BASE_SEQ_SV__
