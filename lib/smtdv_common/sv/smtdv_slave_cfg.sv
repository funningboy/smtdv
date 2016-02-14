`ifndef __SMTDV_SLAVE_CFG_SV__
`define __SMTDV_SLAVE_CFG_SV__

/**
* smtdv_slave_cfg
* a basic smtdv_slave_cfg
*
* @class smtdv_slave_cfg
*
*/
class smtdv_slave_cfg
  extends
    smtdv_cfg;

  typedef smtdv_slave_cfg cfg_t;

 `uvm_object_param_utils_begin(cfg_t)
 `uvm_object_utils_end

  function new(string name = "smtdv_slave_cfg",  uvm_component parent=null);
    super.new(name, parent);
    mod = SLAVE;
  endfunction : new

endclass : smtdv_slave_cfg

`endif // __SMTDV_SLAVE_CFG_SV__
