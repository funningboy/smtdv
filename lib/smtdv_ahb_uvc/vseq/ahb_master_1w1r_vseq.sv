
`ifndef __AHB_MASTER_1W1R_VSEQ_SV__
`define __AHB_MASTER_1W1R_VSEQ_SV__

class ahb_master_1w1r_vseq
  extends
  ahb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef ahb_master_1w1r_vseq vseq_t;
  typedef ahb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef ahb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;
  typedef ahb_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stop_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  seq_1w_t seq_1w;
  seq_1r_t seq_1r;
  seq_stop_t seq_stop;

  static const bit [ADDR_WIDTH-1:0] start_addr = `AHB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_addr = 'h1000;
  bit [ADDR_WIDTH-1:0] cur_addr;

  rand bst_type_t           bst_type;
  rand trx_size_t           trx_size;
  rand int cnt;

  constraint c_cnt { cnt inside {[10:20]}; }
  constraint c_trx_size { trx_size inside {B32}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_1w1r_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    cur_addr = start_addr;

    // create seq_1w as seq_graph node0
    `SMTDV_RAND_VAR_WITH(bst_type, {
        bst_type inside {SINGLE, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16};
    })
    `uvm_create_on(seq_1w, vseqr.ahb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1w,
      {
        start_addr == cur_addr;
        bst_type == bst_type;
        trx_size == trx_size;
      })

    // create seq_1r as seq_graph node1
    `uvm_create_on(seq_1r, vseqr.ahb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_1r,
      {
        start_addr == cur_addr;
        bst_type == bst_type;
        trx_size == trx_size;
      })

    `uvm_create_on(seq_stop, vseqr.ahb_magts[0].seqr)

    graph = '{
        nodes:
           '{
               '{
                   uuid: 0,
                   seq: seq_1w,
                   seqr: vseqr.ahb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "seq_1w")}
               },
               '{
                   uuid: 1,
                   seq: seq_1r,
                   seqr: vseqr.ahb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 1, "seq_1r")}
               },
               '{
                   uuid: 2,
                   seq: seq_stop,
                   seqr: vseqr.ahb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 2, "seq_stop")}
                }
           },
        edges:
           '{
               '{
                   uuid: 0,
                   sourceid: 0,
                   sinkid: 1,
                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 0, 0, 1)}
               }
           }
     };
  endtask : pre_body

  // read after write
  virtual task body();
    super.body();
    fork
      begin seq_1w.start(vseqr.ahb_magts[0].seqr, this, 0); end
      begin seq_1r.start(vseqr.ahb_magts[0].seqr, this, 0); end
      begin seq_stop.start(vseqr.ahb_magts[0].seqr, this, 0); end
    join_none
    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.ahb_magts[0].seqr.finish);
  endtask : post_body

endclass : ahb_master_1w1r_vseq


`endif // __AHB_MASTER_1W1R_VSEQ_SV__
