`ifndef __SMTDV_MASTER_BASE_VSEQ_SV__
`define __SMTDV_MASTER_BASE_VSEQ_SV__

class smtdv_master_base_vseq
  extends
  smtdv_base_vseq;

  typedef smtdv_master_base_vseq vseq_t;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_base_vseq");
    super.new(name);
  endfunction : new

endclass : smtdv_master_base_vseq


`endif // __SMTDV_MASTER_BASE_VSEQ_SV__
