
`ifndef __SMTDV_SEQUENCE_ITEM_SV__
`define __SMTDV_SEQUENCE_ITEM_SV__

class smtdv_sequence_item extends uvm_sequence_item;

  rand mod_type_t    mod_t;  // {MASTER/SLAVE}
  rand trs_type_t    trs_t;  // {RD/WR}
  rand run_type_t    run_t;  // {FORCE/NORMAL/SKIP/ERRORINJECT}

  longint       bg_cyc;
  longint       ed_cyc;

  `uvm_object_param_utils_begin(smtdv_sequence_item)
    `uvm_field_enum(mod_type_t, mod_t, UVM_ALL_ON)
    `uvm_field_enum(trs_type_t, trs_t, UVM_ALL_ON)
    `uvm_field_enum(run_type_t, run_t, UVM_ALL_ON)
    `uvm_field_int(bg_cyc, UVM_ALL_ON)
    `uvm_field_int(ed_cyc, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_sequence_item");
    super.new(name);
  endfunction

endclass : smtdv_sequence_item

`endif // end of __SMTDV_SEQUENCE_ITEM_SV__
