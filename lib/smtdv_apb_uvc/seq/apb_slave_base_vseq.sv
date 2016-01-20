

`ifndef __APB_SLAVE_BASE_VSEQ_SV__
`define __APB_SLAVE_BASE_VSEQ_SV__

//typedef class apb_slave_sequencer

// bind virtual sequencer as physical sequencer
class apb_slave_base_vseq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_base_vseq;

  typedef apb_slave_base_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  seqr_t seqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH))

  function new(string name = "apb_slave_base_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();
    $cast(seqr, p_sequencer);
  endtask : pre_body

endclass : apb_slave_base_vseq

`endif // __APB_SALVE_BASE_VSEQ_SV__
