
`ifndef __APB_MASTER_1W1R_VSEQ_SV__
`define __APB_MASTER_1W1R_VSEQ_SV__

/*
* sequence graph test
*/
class apb_master_1w1r_vseq
  extends
  apb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_master_1w1r_vseq vseq_t;
  typedef apb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef apb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  seq_1w_t seq_1w;
  seq_1r_t seq_1r;

  static const bit [ADDR_WIDTH-1:0] start_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_addr = 'h100;
  bit [ADDR_WIDTH-1:0] cur_addr;

  rand int cnt;

  constraint c_cnt { cnt inside {[10:20]}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_1w1r_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    cur_addr = start_addr;

    `uvm_create_on(seq_1w, vseqr.apb_magt[0].seqr)
    `SMTDV_RAND_WITH(seq_1w,
      {
        seq_1w.start_addr == cur_addr;
      })
    $cast(bseq, seq_1w);
    seqs.push_back(bseq);
    seq_blder._create_seq_node(0);
    seq_1w.set(seq_blder.seq_graph.get_node(0));

    `uvm_create_on(seq_1r, vseqr.apb_magt[0].seqr)
    `SMTDV_RAND_WITH(seq_1r,
      {
        seq_1r.start_addr == cur_addr;
      })
    $cast(bseq, seq_1r);
    seqs.push_back(bseq);
    seq_blder._create_seq_node(1);
    seq_1r.set(seq_blder.seq_graph.get_node(1));

    seq_blder._create_seq_edge(0, 1);

    seq_blder._finalize_seq_graph();
  endtask : pre_body

  // read after write
  virtual task body();
    super.body();
    fork
      begin seq_1w.start(vseqr.apb_magt[0].seqr, this, 0); end
      begin seq_1r.start(vseqr.apb_magt[0].seqr, this, 0); end
    join_none
    #10;
  endtask : body

  virtual task post_body();
    wait(vseqr.apb_magt[0].seqr.finish);
  endtask : post_body

endclass : apb_master_1w1r_vseq

`endif // __APB_MASTER_1W1R_VSEQ_SV__


