
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

    if (!$cast(vseqr, this.get_sequencer()))
      `uvm_error("SMTDV_UCAST_V/PSEQR",
         {$psprintf("UP CAST TO SMTDV V/PSEQR FAIL")})

    `uvm_create_on(a_seq, vseqr.smtdv_magts[0].seqr)
    `uvm_create_on(b_seq, vseqr.smtdv_magts[0].seqr)

    graph = '{
        nodes:
            '{
                '{
                    uuid: 0,
                    seq: a_seq,
                    seqr: vseqr.smtdv_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", 0, a_seq.get_full_name())}
                },
                '{
                    uuid: 1,
                    seq: b_seq,
                    seqr: vseqr.smtdv_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", 1, b_seq.get_full_name())}
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

  virtual task body();
    super.body();

    fork
      begin a_seq.start(vseqr.smtdv_magts[0].seqr); end
      begin b_seq.start(vseqr.smtdv_magts[0].seqr); end
    join_none
    #100;
  endtask : body

  virtual task post_body();
    super.post_body();

    wait(vseqr.smtdv_magts[0].seqr.finish);
  endtask : post_body

endclass : smtdv_master_test_vseq


`endif // __SMTDV_MASTER_TEST_VSEQ_SV__
