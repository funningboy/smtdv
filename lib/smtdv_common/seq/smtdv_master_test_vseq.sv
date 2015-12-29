
`ifndef __SMTDV_MASTER_TEST_VSEQ_SV__
`define __SMTDV_MASTER_TEST_VSEQ_SV__

class smtdv_master_test_vseq #(
    ADDR_WIDTH,
    DATA_WIDTH
  ) extends
    smtdv_master_base_vseq;

  typedef smtdv_master_cfg  cfg_t;
  typedef smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef smtdv_master_test_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, virtual interface smtdv_if, cfg_t, item_t) seqr_t;
  typedef smtdv_master_wait_seq#(ADDR_WIDTH, DATA_WIDTH) wait_seq_t;
  typedef smtdv_master_do_a_seq#(ADDR_WIDTH, DATA_WIDTH) a_seq_t;
  typedef smtdv_master_do_b_seq#(ADDR_WIDTH, DATA_WIDTH) b_seq_t;
  typedef smtdv_master_do_grab_seq#(ADDR_WIDTH, DATA_WIDTH) grab_seq_t;

  wait_seq_t wait_seq;
  a_seq_t a_seq;
  b_seq_t b_seq;
  grab_seq_t grab_seq;

  seqr_t seqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(seqr_t)

  function new(string name = "smtdv_master_test_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();
    // p_sequencer == this.get_sequencer()
    //$cast(seqr, p_sequencer);
    $cast(seqr, this.get_sequencer());
  endtask : pre_body

  virtual task do_seq_wait();
    `uvm_create_on(wait_seq, seqr)
    wait_seq.start(seqr, this, 0);
  endtask : do_seq_wait

  virtual task do_seq_a();
    `uvm_create_on(a_seq, seqr)
    a_seq.start(seqr, this, -1);
  endtask : do_seq_a

  virtual task do_seq_b();
    `uvm_create_on(b_seq, seqr)
    b_seq.start(seqr, this, -1);
  endtask : do_seq_b

  virtual task do_seq_grab();
    `uvm_create_on(grab_seq, seqr)
    grab_seq.start(seqr, this, 0);
  endtask : do_seq_grab

  virtual task body();
    fork
      fork
        do_seq_wait();
        do_seq_a();
        do_seq_b();
        do_seq_grab();
      join
    join

    seqr.finish = TRUE;
  endtask : body

endclass : smtdv_master_test_vseq


`endif // __SMTDV_MASTER_TEST_VSEQ_SV__
