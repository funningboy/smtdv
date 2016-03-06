`ifndef __AHB_MASTER_RAND_VSEQ_SV__
`define __AHB_MASTER_RAND_VSEQ_SV__

//typedef class ahb_master_base_seq;

// bind physical seqs to virtual seqs
class ahb_master_rand_vseq
  extends
  ahb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef ahb_master_rand_vseq vseq_t;
  typedef ahb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef ahb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;

  seq_1w_t seq_1w[$];
  seq_1r_t seq_1r[$];

  static const bit [ADDR_WIDTH-1:0] start_wr_addr = `AHB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] start_rd_addr = `AHB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_wr_addr = 'h100;
  static const bit [ADDR_WIDTH-1:0] incr_rd_addr = 'h100;
  bit [ADDR_WIDTH-1:0] cur_wr_addr;
  bit [ADDR_WIDTH-1:0] cur_rd_addr;

  rand bst_type_t           bst_type;
  rand trx_size_t           trx_size;
  rand int cnt;
  rand int wr_cyc, rd_cyc;

  constraint c_cnt { cnt inside {[10:20]}; }
  constraint c_bst_type { bst_type inside {INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16}; }
  constraint c_trx_size { trx_size inside {B32}; }
  constraint c_wr_cyc { wr_cyc inside {[0:10]}; }
  constraint c_rd_cyc { rd_cyc inside {[0:10]}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_rand_seq");
    super.new(name);
  endfunction : new

  virtual task dec_rand_wr_seq();
    cur_wr_addr = start_wr_addr;

    `uvm_create_on(seq_1w[0], vseqr.ahb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1w[0],
      {
        seq_1w[0].start_addr == cur_wr_addr;
        seq_1w[0].bst_type == bst_type;
        seq_1w[0].trx_size == trx_size;
      })
      cur_wr_addr += incr_wr_addr;

    `uvm_create_on(seq_1w[1], vseqr.ahb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1w[1],
      {
        seq_1w[1].start_addr == cur_wr_addr;
        seq_1w[1].bst_type == bst_type;
        seq_1w[1].trx_size == trx_size;
      })
      cur_wr_addr += incr_wr_addr;

    graph.nodes[0] =
        '{
            uuid: 0,
            seq: seq_1w[0],
            seqr: vseqr.ahb_magts[0].seqr,
            prio: -1,
            desc: {$psprintf("Node[%0d]", 0)}
    };

    graph.nodes[1] =
        '{
            uuid: 1,
            seq: seq_1w[1],
            seqr: vseqr.ahb_magts[0].seqr,
            prio: -1,
            desc: {$psprintf("Node[%0d]", 1)}
    };

    graph.edges[0] =
        '{
            uuid: 0,
            sourceid: 0,
            sinkid: 1,
            desc: {$psprintf("Edge[%0d]", 0)}
    };
  endtask : dec_rand_wr_seq

  virtual task dec_rand_rd_seq();
    cur_rd_addr = start_rd_addr;

     `uvm_create_on(seq_1r[0], vseqr.ahb_magts[0].seqr)
     `SMTDV_RAND_WITH(seq_1r[0],
       {
          seq_1r[0].start_addr == cur_rd_addr;
          seq_1r[0].bst_type == bst_type;
          seq_1r[0].trx_size == trx_size;
       })
      cur_rd_addr += incr_rd_addr;

    graph.nodes[2] =
        '{
            uuid: 2,
            seq: seq_1r[0],
            seqr: vseqr.ahb_magts[0].seqr,
            prio: -1,
            desc: {$psprintf("Node[%0d]", 2)}
        };

    graph.edges[1] = '{
         uuid: 1,
         sourceid: 1,
         sinkid: 2,
         desc: {$psprintf("Edge[%0d]", 1)}
     };

  endtask : dec_rand_rd_seq


  virtual task run_rand_wr_seq();
    foreach (seq_1w[i]) begin
      automatic int k;
      k = i;
      fork
        seq_1w[k].start(vseqr.ahb_magts[0].seqr, this, -1);
      join_none
    end
  endtask : run_rand_wr_seq


  virtual task run_rand_rd_seq();
    foreach (seq_1r[i]) begin
      automatic int k;
      k = i;
      fork
        seq_1r[k].start(vseqr.ahb_magts[0].seqr, this, -1);
      join_none
    end
  endtask : run_rand_rd_seq


  virtual task pre_body();
    super.pre_body();
    dec_rand_wr_seq();
    dec_rand_rd_seq();
  endtask : pre_body


  virtual task body();
    super.body();
    run_rand_wr_seq();
    run_rand_rd_seq();
     #1000;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.ahb_magts[0].seqr.finish);
  endtask : post_body

endclass : ahb_master_rand_vseq

`endif // __AHB_MASTER_RAND_VSEQ_SV__
