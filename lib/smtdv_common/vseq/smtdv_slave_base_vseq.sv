
`ifndef __SMTDV_SLAVE_BASE_VSEQ_SV__
`define __SMTDV_SLAVE_BASE_VSEQ_SV__

class smtdv_slave_base_vseq
  extends
  smtdv_base_vseq;

  typedef smtdv_slave_base_vseq vseq_t;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_slave_base_vseq");
    super.new(name);
  endfunction : new

endclass : smtdv_slave_base_vseq


`endif // __SMTDV_SLAVE_BASE_VSEQ_SV__
