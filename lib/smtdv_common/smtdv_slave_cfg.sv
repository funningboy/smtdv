`ifndef __SMTDV_SLAVE_CFG_SV__
`define __SMTDV_SLAVE_CFG_SV__

class smtdv_slave_cfg
  extends
    smtdv_cfg;

 `uvm_object_param_utils_begin(smtdv_slave_cfg)
 `uvm_object_utils_end

  function new(string name = "smtdv_slave_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __SMTDV_SLAVE_CFG_SV__
