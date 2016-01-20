`ifndef __AHB_MASTER_CFG_SV__
`define __AHB_MASTER_CFG_SV__

/*
* ahb_master_cfg
* template class with ahb master cfg
*
* @class ahb_master_cfg
*/
class ahb_master_cfg
  extends
    smtdv_master_cfg;

  typedef ahb_master_cfg cfg_t;

  rand bit   block_hbusreq;
  rand bit   block_hnonseq;
  rand bit   has_busy;

  constraint c_block_hbusreq { block_hbusreq inside {TRUE, FALSE}; }
  constraint c_block_hnonseq { block_hnonseq inside {TRUE, FALSE}; }
  constraint c_has_busy { has_busy inside {TRUE, FALSE}; }

  `uvm_object_param_utils_begin(cfg_t)
    `uvm_field_int(block_hbusreq, UVM_DEFAULT)
    `uvm_field_int(block_hnonseq, UVM_DEFAULT)
    `uvm_field_int(has_busy, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "ahb_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction : new

endclass : ahb_master_cfg

`endif // __AHB_MASTER_CFG_SV__
