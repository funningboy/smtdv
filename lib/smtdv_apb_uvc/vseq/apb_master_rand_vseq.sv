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

  seq_1w_t seq_1w[$];
  seq_1r_t seq_1r[$];

  static const bit [ADDR_WIDTH-1:0] start_wr_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] start_rd_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_wr_addr = 'h100;
  static const bit [ADDR_WIDTH-1:0] incr_rd_addr = 'h100;
  bit [ADDR_WIDTH-1:0] cur_wr_addr;
  bit [ADDR_WIDTH-1:0] cur_rd_addr;

  int nodeid = 0;
  int edgeid = 0;

  rand int cnt;
  constraint c_cnt { cnt inside {[10:20]}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_rand_seq");
    super.new(name);
  endfunction : new

  virtual task dec_rand_wr_seq();
    cur_wr_addr = start_wr_addr;

    for(int i=0; i<cnt; i++) begin
      `uvm_create_on(seq_1w[i], vseqr.apb_magts[0].seqr)
      `SMTDV_RAND_WITH(seq_1w[i],
        {
          seq_1w[i].start_addr == cur_wr_addr;
        })
        cur_wr_addr += incr_wr_addr;

        graph.nodes[i] = '{
            uuid: i,
            seq: seq_1w[i],
            seqr: vseqr.apb_magts[0].seqr,
            desc: {$psprintf("Node[%0d]", i)}
        };
    end

    for(int i=0; i<cnt-1; i++) begin
        graph.edges[i] = '{
            uuid: i,
            sourceid: i,
        };
    end

      seq_1w[i].start(vseqr.apb_magts[0].seqr, this, -1);
    end
  endtask : do_rand_wr_seq

  virtual task do_rand_rd_seq();
  endtask : do_rand_rd_seq

  virtual task body();
    super.body();
    fork
      fork
        do_rand_wr_seq();
        do_rand_rd_seq();
      join
    join
    disable fork;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.apb_magts[0].seqr.finish);
  endtask : post_body

endclass : apb_master_rand_vseq

`endif // __APB_MASTER_RAND_VSEQ_SV__
