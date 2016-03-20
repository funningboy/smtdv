
`ifndef __APB_MASTER_STL_VSEQ_SV__
`define __APB_MASTER_STL_VSEQ_SV__

class apb_master_stl_vseq
  extends
  apb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_virtual_sequencer vseqr_t;
  typedef apb_master_stl_vseq vseq_t;
  typedef apb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stl_t;
  typedef apb_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stop_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  seq_stl_t seq_stls[$];
  seq_stop_t seq_stop;

  typedef struct {
    string q[$];
  } stls_t;

  stls_t stls = '{
    q:
        '{
            {getenv("SMTDV_HOME"), "/lib/smtdv_apb_uvc/stl/preload1.stl"},
            {getenv("SMTDV_HOME"), "/lib/smtdv_apb_uvc/stl/preload0.stl"}
        }
  };

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_stl_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

   `uvm_create_on(seq_stls[0], vseqr.apb_magts[0].seqr)
    seq_stls[0].m_file = stls.q[0];

   `uvm_create_on(seq_stls[1], vseqr.apb_magts[0].seqr)
    seq_stls[1].m_file = stls.q[1];

    `uvm_create_on(seq_stop, vseqr.apb_magts[0].seqr)

    graph = '{
        nodes:
           '{
               '{
                   uuid: 0,
                   seq: seq_stls[0],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "stls[0]")}
               },
               '{
                   uuid: 1,
                   seq: seq_stls[1],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 1, "stls[1]")}
               },
               '{
                    uuid: 2,
                    seq: seq_stop,
                    seqr: vseqr.apb_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", 2, "stop_seqr")}
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
      begin seq_stls[0].start(vseqr.apb_magts[0].seqr); end
      begin seq_stls[1].start(vseqr.apb_magts[0].seqr); end
      begin seq_stop.start(vseqr.apb_magts[0].seqr); end
    join_none;
    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.apb_magts[0].seqr.finish);
  endtask : post_body

endclass : apb_master_stl_vseq

`endif // __APB_MASTER_STL_VSEQ_SV__
