`ifndef __APB_ENV_SV__
`define __APB_ENV_SV__

class apb_env
  extends
    smtdv_env;

    parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
    parameter DATA_WIDTH = `APB_DATA_WIDTH;

    `APB_MASTER_CFG     m_cfg[$];
    `APB_MASTER_AGENT   m_agent[$];
    `APB_SLAVE_CFG      s_cfg[$];
    `APB_SLAVE_AGENT    s_agent[$];

  `uvm_component_param_utils_begin(`APB_ENV)
    `uvm_field_queue_object(m_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(m_agent, UVM_ALL_ON)
    `uvm_field_queue_object(s_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(s_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif // __APB_ENV_SV__
