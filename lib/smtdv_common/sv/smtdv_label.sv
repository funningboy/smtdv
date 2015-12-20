
`ifndef __SMTDV_label_SV__
`define __SMTDV_label_SV__

typedef class smtdv_component;
typedef class smtdv_cfg;
typedef class smtdv_sequence_item;

class smtdv_label #(
  type CMP = smtdv_component
  ) extends
    uvm_object; // uvm_sequence_item???

  CMP cmp;

  `uvm_object_param_utils_begin(smtdv_label#(CMP))
  `uvm_object_utils_end

  function new(string name = "smtdv_label", CMP parent=null);
    super.new(name);
    cmp = parent;
  endfunction

endclass : smtdv_label


`endif // __SMTDV_LABEL_SV__
