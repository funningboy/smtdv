`ifndef __APB_MASTER_CFG_SV__
`define __APB_MASTER_CFG_SV__

/**
 * a template apb master cfg
 *
 * @class apb_master_cfg
 */
class apb_master_cfg
  extends
    smtdv_master_cfg;

  typedef apb_master_cfg cfg_t;

  rand bit block_psel;
  rand bit block_penable;

  constraint c_block_psel { block_psel inside {TRUE, FALSE}; }
  constraint c_block_penable { block_penable inside {TRUE, FALSE}; }

  `uvm_object_param_utils_begin(cfg_t)
    `uvm_field_int(block_psel, UVM_DEFAULT)
    `uvm_field_int(block_penable, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction : new

endclass : apb_master_cfg

`endif // __APB_MASTER_CFG_SV__
