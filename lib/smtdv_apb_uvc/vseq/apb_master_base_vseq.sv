
`ifndef __APB_MASTER_BASE_VSEQ_SV__
`define __APB_MASTER_BASE_VSEQ_SV__

//typedef class apb_master_sequencer;

// bind virtual sequencer as physical sequencer
class apb_master_base_vseq
  extends
  smtdv_seq_env;

  typedef apb_master_base_vseq vseq_t;
  typedef apb_virtual_sequencer vseqr_t;

  vseqr_t vseqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(vseqr_t)

  function new(string name = "apb_master_base_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();
    // p_sequencer == this.get_sequencer()
    //$cast(seqr, p_sequencer);
    $cast(vseqr, this.get_sequencer());

    seq_blder._create_seq_graph();
  endtask : pre_body

endclass : apb_master_base_vseq

`endif // __APB_MASTER_BASE_VSEQ_SV__

