`ifndef __XBUS_ENV_SV__
`define __XBUS_ENV_SV__

class xbus_env
  extends
    smtdv_env;

    parameter ADDR_WIDTH = `XBUS_ADDR_WIDTH;
    parameter DATA_WIDTH = `XBUS_DATA_WIDTH;
    parameter BYTEN_WIDTH = `XBUS_BYTEN_WIDTH;

    `XBUS_MASTER_CFG     m_cfg[$];
    `XBUS_MASTER_AGENT   m_agent[$];
    `XBUS_SLAVE_CFG      s_cfg[$];
    `XBUS_SLAVE_AGENT    s_agent[$];

  `uvm_component_param_utils_begin(`XBUS_ENV)
    `uvm_field_queue_object(m_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(m_agent, UVM_ALL_ON)
    `uvm_field_queue_object(s_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(s_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "xbus_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif // __XBUS_ENV_SV__
