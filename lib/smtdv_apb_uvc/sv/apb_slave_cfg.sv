`ifndef __APB_SLAVE_CFG_SV__
`define __APB_SLAVE_CFG_SV__

class apb_slave_cfg
  extends
    smtdv_slave_cfg;

  bit block_pready = 0;

  `uvm_object_param_utils_begin(`APB_SLAVE_CFG)
    `uvm_field_int(block_pready, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_slave_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __APB_SLAVE_CFG_SV__
