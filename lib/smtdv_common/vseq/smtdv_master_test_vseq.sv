
`ifndef __SMTDV_MASTER_TEST_VSEQ_SV__
`define __SMTDV_MASTER_TEST_VSEQ_SV__

class smtdv_master_test_vseq
  extends
  smtdv_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef smtdv_master_test_vseq vseq_t;
  typedef smtdv_virtual_sequencer vseqr_t;
  typedef smtdv_master_do_a_seq#(ADDR_WIDTH, DATA_WIDTH) a_seq_t;
  typedef smtdv_master_do_b_seq#(ADDR_WIDTH, DATA_WIDTH) b_seq_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  a_seq_t a_seq;
  b_seq_t b_seq;

  vseqr_t vseqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(vseqr_t)

  function new(string name = "smtdv_master_test_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();
    // p_sequencer == this.get_sequencer()
    //$cast(seqr, p_sequencer);
    $cast(vseqr, this.get_sequencer());

    `uvm_create_on(a_seq, vseqr.smtdv_magt.seqr)
    $cast(bseq, a_seq);
    seqs.push_back(bseq);
    seq_blder._create_seq_node(0);
    a_seq.set(seq_blder.seq_graph.get_node(0));

    `uvm_create_on(b_seq, vseqr.smtdv_magt.seqr)
    $cast(bseq, b_seq);
    seqs.push_back(bseq);
    seq_blder._create_seq_node(1);
    b_seq.set(seq_blder.seq_graph.get_node(1));

    seq_blder._create_seq_edge(0, 1);

    seq_blder._finalize_seq_graph();
  endtask : pre_body

  virtual task body();
    fork
      begin a_seq.start(vseqr.smtdv_magt.seqr); end
      begin b_seq.start(vseqr.smtdv_magt.seqr); end
    join_none
    #10;
  endtask : body

  virtual task post_body();
    wait(vseqr.smtdv_magt.seqr.finish);
  endtask : post_body

endclass : smtdv_master_test_vseq


`endif // __SMTDV_MASTER_TEST_VSEQ_SV__
