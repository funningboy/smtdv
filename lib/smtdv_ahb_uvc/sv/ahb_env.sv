`ifndef __AHB_ENV_SV__
`define __AHB_ENV_SV__

class ahb_env
  extends
    smtdv_env;

    parameter ADDR_WIDTH = `AHB_ADDR_WIDTH;
    parameter DATA_WIDTH = `AHB_DATA_WIDTH;

    `AHB_MASTER_CFG     master_cfg[$];
    `AHB_MASTER_AGENT   master_agent[$];
    `AHB_SLAVE_CFG      slave_cfg[$];
    `AHB_SLAVE_AGENT    slave_agent[$];
    // override cover_group to top/system level define
    `AHB_COLLECT_COVER_GROUP master_covgroup[$];
    `AHB_COLLECT_COVER_GROUP slave_covgroup[$];

  `uvm_component_param_utils_begin(`AHB_ENV)
    `uvm_field_queue_object(master_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(master_agent, UVM_ALL_ON)
    `uvm_field_queue_object(slave_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(slave_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "ahb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif // __AHB_ENV_SV__
