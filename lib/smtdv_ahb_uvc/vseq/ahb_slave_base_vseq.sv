`ifndef __AHB_SLAVE_BASE_VSEQ_SV__
`define __AHB_SLAVE_BASE_VSEQ_SV__

//typedef class ahb_slave_sequencer

// bind virtual sequencer as physical sequencer
class ahb_slave_base_vseq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_base_vseq;

  typedef ahb_slave_base_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  seqr_t seqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH))

  function new(string name = "ahb_slave_base_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();
    if (!$cast(seqr, p_sequencer))
      `uvm_error("SMTDV_UCAST_V/PSEQR",
         {$psprintf("UP CAST TO SMTDV V/PSEQR FAIL")})

  endtask : pre_body

endclass : ahb_slave_base_vseq

`endif // __AHB_SALVE_BASE_VSEQ_SV__
