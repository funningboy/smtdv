`ifndef __XBUS_MASTER_CFG_SV__
`define __XBUS_MASTER_CFG_SV__

class xbus_master_cfg
  extends
    smtdv_cfg;

  bit block_req = 0;
  bit clock_req = 1;

  `uvm_object_param_utils_begin(`XBUS_MASTER_CFG)
    `uvm_field_int(block_req, UVM_DEFAULT)
    `uvm_field_int(clock_req, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "xbus_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __XBUS_MASTER_CFG_SV__
