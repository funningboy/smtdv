`ifndef __AHB_SLAVE_CFG_SV__
`define __AHB_SLAVE_CFG_SV__

class ahb_slave_cfg
  extends
    smtdv_slave_cfg;

  typedef ahb_slave_cfg cfg_t;

  rand bit block_hready = TRUE;
  rand bit has_error = TRUE;
  rand bit has_split = TRUE;
  rand bit has_retry = TRUE;

  `uvm_object_param_utils_begin(cfg_t)
    `uvm_field_int(block_hready, UVM_DEFAULT)
    `uvm_field_int(has_error, UVM_DEFAULT)
    `uvm_field_int(has_split, UVM_DEFAULT)
    `uvm_field_int(has_retry, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction : new

endclass : ahb_slave_cfg

`endif // __AHB_SLAVE_CFG_SV__
