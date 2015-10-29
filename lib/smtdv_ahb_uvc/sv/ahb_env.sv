`ifndef __AHB_ENV_SV__
`define __AHB_ENV_SV__

class ahb_env
  extends
    smtdv_env;

    parameter ADDR_WIDTH = `AHB_ADDR_WIDTH;
    parameter DATA_WIDTH = `AHB_DATA_WIDTH;

    `AHB_MASTER_CFG     m_cfg[$];
    `AHB_MASTER_AGENT   m_agent[$];
    `AHB_SLAVE_CFG      s_cfg[$];
    `AHB_SLAVE_AGENT    s_agent[$];

  `uvm_component_param_utils_begin(`AHB_ENV)
    `uvm_field_queue_object(m_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(m_agent, UVM_ALL_ON)
    `uvm_field_queue_object(s_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(s_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "ahb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif // __AHB_ENV_SV__
