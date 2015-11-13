`ifndef __APB_MASTER_CFG_SV__
`define __APB_MASTER_CFG_SV__

class apb_master_cfg
  extends
    smtdv_master_cfg;

  rand bit block_psel = 0;
  rand bit block_penable = 0;

  constraint c_block_psel { block_psel == 0; }
  constraint c_block_penable { block_penable == 0; }

  `uvm_object_param_utils_begin(`APB_MASTER_CFG)
    `uvm_field_int(block_psel, UVM_DEFAULT)
    `uvm_field_int(block_penable, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __APB_MASTER_CFG_SV__
