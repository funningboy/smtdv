

`ifndef __AHB_MASTER_BASE_VSEQ_SV__
`define __AHB_MASTER_BASE_VSEQ_SV__

//typedef class ahb_master_sequencer;

// bind virtual sequencer as physical sequencer
class ahb_master_base_vseq #(
    ADDR_WIDTH = 14,
    DATA_WIDTH = 32
  ) extends
    smtdv_master_base_vseq;

  typedef ahb_master_base_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  seqr_t seqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(seqr_t)

  function new(string name = "ahb_master_base_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();
    // p_sequencer == this.get_sequencer()
    //$cast(seqr, p_sequencer);
    $cast(seqr, this.get_sequencer());
  endtask : pre_body

endclass : ahb_master_base_vseq

`endif // __AHB_MASTER_BASE_VSEQ_SV__

