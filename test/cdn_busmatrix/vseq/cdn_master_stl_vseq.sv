
`ifndef __CDN_MASTER_STL_VSEQ_SV__
`define __CDN_MASTER_STL_VSEQ_SV__

class cdn_master_stl_vseq
  extends
  ahb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef cdn_virtual_sequencer vseqr_t;
  typedef cdn_master_stl_vseq vseq_t;
  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stl_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;



`endif // __CDN_MASTER_STL_VSEQ_SV__

