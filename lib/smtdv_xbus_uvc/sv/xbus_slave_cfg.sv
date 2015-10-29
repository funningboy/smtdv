
`ifndef __XBUS_SLAVE_CFG_SV__
`define __XBUS_SLAVE_CFG_SV__

class xbus_slave_cfg
  extends
    smtdv_cfg;

  bit block_ack = 0;
  bit clock_req = 0;

  `uvm_object_param_utils_begin(`XBUS_SLAVE_CFG)
    `uvm_field_int(block_ack, UVM_DEFAULT)
    `uvm_field_int(clock_req, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "xbus_slave_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __XBUS_SLAVE_CFG_SV__
