`ifndef __UART_ENV_SV__
`define __UART_ENV_SV__

class uart_env
  extends
    smtdv_env;

    `APB_MASTER_CFG     master_cfg[$];
    `APB_MASTER_AGENT   master_agent[$];
    `APB_SLAVE_CFG      slave_cfg[$];
    `APB_SLAVE_AGENT    slave_agent[$];

  `uvm_component_param_utilslave_begin(`APB_ENV)
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
