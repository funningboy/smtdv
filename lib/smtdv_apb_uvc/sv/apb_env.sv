`ifndef __APB_ENV_SV__
`define __APB_ENV_SV__

class apb_env
  extends
    smtdv_env;

    parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
    parameter DATA_WIDTH = `APB_DATA_WIDTH;

    `APB_MASTER_CFG     master_cfg[$];
    `APB_MASTER_AGENT   master_agent[$];
    `APB_SLAVE_CFG      slave_cfg[$];
    `APB_SLAVE_AGENT    slave_agent[$];
    // override cover_group to top/system level defne
    `APB_COLLECT_COVER_GROUP master_covgroup[$];
    `APB_COLLECT_COVER_GROUP slave_covgroup[$];

  `uvm_component_param_utils_begin(`APB_ENV)
    `uvm_field_queue_object(master_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(master_agent, UVM_ALL_ON)
    `uvm_field_queue_object(slave_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(slave_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif // __APB_ENV_SV__
