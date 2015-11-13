`ifndef __AHB_MASTER_CFG_SV__
`define __AHB_MASTER_CFG_SV__

class ahb_master_cfg
  extends
    smtdv_master_cfg;

  rand bit   block_hbusreq;
  rand bit   block_hnonseq;
  rand bit   has_busy = 0;

  constraint c_block_hbusreq { block_hbusreq ==0; }
  constraint c_block_hnonseq { block_hnonseq ==0; }

  `uvm_object_param_utils_begin(`AHB_MASTER_CFG)
    `uvm_field_int(block_hbusreq, UVM_DEFAULT)
    `uvm_field_int(block_hnonseq, UVM_DEFAULT)
    `uvm_field_int(has_busy, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "ahb_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // __AHB_MASTER_CFG_SV__
