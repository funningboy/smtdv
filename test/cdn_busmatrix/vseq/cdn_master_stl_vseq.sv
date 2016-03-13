
`ifndef __CDN_MASTER_STL_VSEQ_SV__
`define __CDN_MASTER_STL_VSEQ_SV__

class cdn_master_stl_vseq
  extends
  smtdv_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef cdn_busmatrix_virtual_sequencer vseqr_t;
  typedef cdn_master_stl_vseq vseq_t;
  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stl_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  vseqr_t vseqr;
  bcmp_t bseqr;
  obj_t bseq;

  `uvm_declare_p_sequencer(vseqr_t)

  seq_stl_t seq_stls[$];

  typedef struct {
    string q[$];
    int mid;
  } stls_t;

  stls_t stls[$] = '{
    '{
        mid: 0,
        q: '{
                {getenv("SMTDV_HOME"), "/test/cdn_busmatrix/stl/cdn_dma_m0_0.stl"},
                {getenv("SMTDV_HOME"), "/test/cdn_busmatrix/stl/cdn_dma_m0_1.stl"}
            }
     },
    '{
        mid: 1,
        q: '{
                {getenv("SMTDV_HOME"), "/test/cdn_busmatrix/stl/cdn_cpu_m1_0.stl"},
                {getenv("SMTDV_HOME"), "/test/cdn_busmatrix/stl/cdn_cpu_m1_1.stl"}
            }
     }
  };

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "cdn_master_stl_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
   super.pre_body();

    if (!$cast(vseqr, this.get_sequencer()))
      `uvm_error("SMTDV_UCAST_V/PSEQR",
         {$psprintf("UP CAST TO SMTDV V/PSEQR FAIL")})

    seq_blder._create_seq_graph();

   `uvm_create_on(seq_stls[0], vseqr.ahb_magts[0].seqr)
    seq_stls[0].m_file = stls[0].q[0];

   `uvm_create_on(seq_stls[1], vseqr.ahb_magts[0].seqr)
    seq_stls[1].m_file = stls[0].q[1];

//   `uvm_create_on(seq_stls[2], vseqr.ahb_magts[1].seqr)
//    seq_stls[2].m_file = stls[1].q[0];
//
//   `uvm_create_on(seq_stls[3], vseqr.ahb_magts[1].seqr)
//    seq_stls[3].m_file = stls[1].q[1];

    graph = '{
        nodes:
           '{
               '{
                   uuid: 0,
                   seq: seq_stls[0],
                   seqr: vseqr.ahb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "stls[0][0]")}
               },
               '{
                   uuid: 1,
                   seq: seq_stls[1],
                   seqr: vseqr.ahb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 1, "stls[0][1]")}
               }//,
//               '{
//                    uuid: 2,
//                    seq: seq_stls[2],
//                    seqr: vseqr.ahb_magts[1].seqr,
//                    prio: -1,
//                    desc: {$psprintf("bind Node[%0d] as %s", 2, "stls[1][0]")}
//                },
//                '{
//                    uuid: 3,
//                    seq: seq_stls[3],
//                    seqr: vseqr.ahb_magts[1].seqr,
//                    prio: -1,
//                    desc: {$psprintf("bind Node[%0d] as %s", 3, "stls[1][1]")}
//                }
           },
        edges:
           '{
               '{
                   uuid: 0,
                   sourceid: 0,
                   sinkid: 1,
                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 0, 0, 1)}
               }//,
//               '{
//                   uuid: 1,
//                   sourceid: 2,
//                   sinkid: 3,
//                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 0, 0, 1)}
//               }
           }
     };
  endtask : pre_body

  virtual task body();
    super.body();
    fork
      begin seq_stls[0].start(vseqr.ahb_magts[0].seqr); end
      begin seq_stls[1].start(vseqr.ahb_magts[0].seqr); end
//      begin seq_stls[2].start(vseqr.ahb_magts[1].seqr); end
//      begin seq_stls[2].start(vseqr.ahb_magts[1].seqr); end
    join_none;
    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.ahb_magts[0].seqr.finish);
    //wait(vseqr.ahb_magts[0].seqr.finish && vseqr.ahb_magts[1].seqr.finish);
  endtask : post_body

endclass : cdn_master_stl_vseq


`endif // __CDN_MASTER_STL_VSEQ_SV__

