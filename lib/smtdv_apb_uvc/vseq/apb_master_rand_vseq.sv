`ifndef __APB_MASTER_RAND_VSEQ_SV__
`define __APB_MASTER_RAND_VSEQ_SV__

//typedef class apb_master_base_seq;

// bind physical seqs to virtual seqs
class apb_master_rand_vseq
  extends
  apb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_master_rand_vseq vseq_t;
  typedef apb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef apb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;
  typedef apb_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stop_t;

  seq_1w_t seq_1w[$];
  seq_1r_t seq_1r[$];
  seq_stop_t seq_stop;

  static const bit [ADDR_WIDTH-1:0] start_wr_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] start_rd_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_wr_addr = 'h100;
  static const bit [ADDR_WIDTH-1:0] incr_rd_addr = 'h100;
  bit [ADDR_WIDTH-1:0] cur_wr_addr;
  bit [ADDR_WIDTH-1:0] cur_rd_addr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_rand_seq");
    super.new(name);
  endfunction : new

  virtual task dec_rand_wr_seq();
    cur_wr_addr = start_wr_addr;

    `uvm_create_on(seq_1w[0], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1w[0],
      {
        seq_1w[0].start_addr == cur_wr_addr;
      })
      cur_wr_addr += incr_wr_addr;

    `uvm_create_on(seq_1w[1], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1w[1],
      {
        seq_1w[1].start_addr == cur_wr_addr;
      })
      cur_wr_addr += incr_wr_addr;

    graph.nodes[0] =
        '{
            uuid: 0,
            seq: seq_1w[0],
            seqr: vseqr.apb_magts[0].seqr,
            prio: -1,
            desc: {$psprintf("Node[%0d]", 0)}
    };

    graph.nodes[1] =
        '{
            uuid: 1,
            seq: seq_1w[1],
            seqr: vseqr.apb_magts[0].seqr,
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

    `uvm_create_on(seq_1r[0], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1r[0],
      {
        seq_1r[0].start_addr == cur_rd_addr;
      })
      cur_rd_addr += incr_rd_addr;

    graph.nodes[2] =
        '{
            uuid: 2,
            seq: seq_1r[0],
            seqr: vseqr.apb_magts[0].seqr,
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

  virtual task dec_stop_seqr_seq();
    graph.nodes[3] =
        '{
            uuid: 3,
            seq: seq_stop,
            seqr: vseqr.apb_magts[0].seqr,
            prio: -1,
            desc: {$psprintf("Node[%0d]", 2)}
    };
  endtask : dec_stop_seqr_seq

  virtual task run_rand_wr_seq();
    foreach (seq_1w[i]) begin
      automatic int k;
      k = i;
      fork
        seq_1w[k].start(vseqr.apb_magts[0].seqr, this, -1);
      join_none
    end
  endtask : run_rand_wr_seq


  virtual task run_rand_rd_seq();
    foreach (seq_1r[i]) begin
      automatic int k;
      k = i;
      fork
        seq_1r[k].start(vseqr.apb_magts[0].seqr, this, -1);
      join_none
    end
  endtask : run_rand_rd_seq

  virtual task run_stop_seqr_seq();
    seq_stop.start(vseqr.apb_magts[0].seqr, this, -1);
  endtask : run_stop_seqr_seq

  virtual task pre_body();
    super.pre_body();
    dec_rand_wr_seq();
    dec_rand_rd_seq();
    dec_stop_seqr_seq();
  endtask : pre_body

  virtual task body();
    super.body();
    run_rand_wr_seq();
    run_rand_rd_seq();
    run_stop_seqr_seq();
     #1000;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.apb_magts[0].seqr.finish);
  endtask : post_body

endclass : apb_master_rand_vseq

`endif // __APB_MASTER_RAND_VSEQ_SV__
