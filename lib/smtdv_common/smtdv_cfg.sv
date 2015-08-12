`ifndef __SMTDV_CFG_SV__
`define __SMTDV_CFG_SV__

class smtdv_cfg extends uvm_object;

  bit has_force = 0;
  bit has_error = 0;
  bit clock_req = 0; // Master Cfg =1, Slave Cfg =0
  bit has_coverage = 0;
  bit has_export = 0;

  smtdv_component cmp;

  `uvm_object_param_utils_begin(smtdv_cfg)
    `uvm_field_int(has_force, UVM_DEFAULT)
    `uvm_field_int(has_error, UVM_DEFAULT)
    `uvm_field_int(clock_req, UVM_DEFAULT)
    `uvm_field_int(has_coverage, UVM_DEFAULT)
    `uvm_field_int(has_export, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_cfg", smtdv_component cmp=null);
    super.new(name);
    cmp = cmp;
  endfunction

endclass

`endif // __SMTDV_CFG_SV__

