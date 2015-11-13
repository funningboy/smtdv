`ifndef __AHB_SLAVE_CFG_SV__
`define __AHB_SLAVE_CFG_SV__

class ahb_slave_cfg
  extends
    smtdv_slave_cfg;

  rand bit block_hready = 0;
  rand bit has_error = 0;
  rand bit has_split = 0;
  rand bit has_retry = 0;

  `uvm_object_param_utils_begin(`AHB_SLAVE_CFG)
    `uvm_field_int(block_hready, UVM_DEFAULT)
    `uvm_field_int(has_error, UVM_DEFAULT)
    `uvm_field_int(has_split, UVM_DEFAULT)
    `uvm_field_int(has_retry, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __AHB_SLAVE_CFG_SV__
