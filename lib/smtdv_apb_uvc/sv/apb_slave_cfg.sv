`ifndef __APB_SLAVE_CFG_SV__
`define __APB_SLAVE_CFG_SV__

class apb_slave_cfg
  extends
    smtdv_slave_cfg;

  typedef apb_slave_cfg cfg_t;

  rand bit block_pready = TRUE;
  rand bit has_error = FALSE;

  `uvm_object_param_utils_begin(cfg_t)
    `uvm_field_int(block_pready, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_slave_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction : new

endclass : apb_slave_cfg

`endif // __APB_SLAVE_CFG_SV__
