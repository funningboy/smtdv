`ifndef __AHB_MASTER_STL_VSEQ_SV__
`define __AHB_MASTER_STL_VSEQ_SV__

class ahb_master_stl_vseq
  extends
  ahb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef ahb_virtual_sequencer vseqr_t;
  typedef ahb_master_stl_vseq vseq_t;
  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stl_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  seq_stl_t seq_stl[$];

  typedef struct {
    string q[$];
  } stls_t;
  stls_t preload[int] = '{
      // master[0] preloads
      0: '{
            '{
                {getenv("SMTDV_HOME"), "/lib/smtdv_ahb_uvc/stl/incr16.stl"},
                {getenv("SMTDV_HOME"), "/lib/smtdv_ahb_uvc/stl/wrap8.stl"}
            }
      }
  };

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_stl_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    for(int i=0; i<preload[0].q.size(); i++) begin
      `uvm_create_on(seq_stl[i], vseqr.ahb_magts[0].seqr)
      seq_stl[i].m_file = preload[0].q[i];
      $cast(bseq, seq_stl[i]);
      seqs.push_back(bseq);
      seq_blder._create_seq_node(i);
      seq_stl[i].set(seq_blder.seq_graph.get_node(i));
    end

    for(int i=0; i<preload[0].q.size()-1; i++) begin
      seq_blder._create_seq_edge(i, i+1);
    end

    seq_blder._finalize_seq_graph();
  endtask : pre_body

  virtual task body();
    super.body();
    fork
      begin seq_stl[0].start(vseqr.ahb_magts[0].seqr); end
      begin seq_stl[1].start(vseqr.ahb_magts[0].seqr); end
    join_none;
    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.ahb_magts[0].seqr.finish);
  endtask : post_body

endclass : ahb_master_stl_vseq

`endif // __AHB_MASTER_STL_VSEQ_SV__
