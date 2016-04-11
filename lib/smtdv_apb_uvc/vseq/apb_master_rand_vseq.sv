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

  seq_1w_t seq_1ws[$];
  seq_1r_t seq_1rs[$];
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

  virtual task pre_body();
    cur_wr_addr = start_wr_addr;
    cur_rd_addr = start_rd_addr;
    super.pre_body();

    if (!$cast(vseqr, this.get_sequencer()))
      `uvm_error("SMTDV_UCAST_V/PSEQR",
         {$psprintf("UP CAST TO SMTDV V/PSEQR FAIL")})

    `uvm_create_on(seq_1ws[0], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1ws[0],
      {
        start_addr == cur_wr_addr;
      })

    `uvm_create_on(seq_1rs[0], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1rs[0],
      {
        start_addr == cur_rd_addr;
      })

    `uvm_create_on(seq_stop, vseqr.apb_magts[0].seqr)

    graph = '{
        nodes:
        '{
            '{
                uuid: 0,
                seq: seq_1ws[0],
                seqr: vseqr.apb_magts[0].seqr,
                prio: -1,
                desc: {$psprintf("Node[%0d]", 0)}
            },
            '{
                uuid: 1,
                seq: seq_1rs[0],
                seqr: vseqr.apb_magts[0].seqr,
                prio: -1,
                desc: {$psprintf("Node[%0d]", 1)}
            },
            '{
                uuid: 2,
                seq: seq_stop,
                seqr: vseqr.apb_magts[0].seqr,
                prio: -1,
                desc: {$psprintf("Node[%0d]", 2)}
            }
        },
        edges:
        '{
            '{
                uuid: 0,
                sourceid: 0,
                sinkid: 1,
                desc: {$psprintf("Edge[%0d]", 0)}
            }
        }
    };

  endtask : pre_body

  virtual task body();
    super.body();
    seq_1ws[0].start(vseqr.apb_magts[0].seqr, this, -1);
    seq_1rs[0].start(vseqr.apb_magts[0].seqr, this, -1);
    seq_stop.start(vseqr.apb_magts[0].seqr, this, -1);
    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.apb_magts[0].seqr.finish);
  endtask : post_body

endclass : apb_master_rand_vseq

`endif // __APB_MASTER_RAND_VSEQ_SV__
