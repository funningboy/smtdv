`ifndef __UART_ENV_SV__
`define __UART_ENV_SV__

class uart_env#(
  type MCFG = uart_master_cfg,
  type MAGT = uart
  )extends
    smtdv_env#(
        .MCFG(MCFG),
        .MAGT(MAGT),
    );

    // align master=tx, slave=rx
    `UART_TX_CFG     master_cfg[$];
    `UART_TX_AGENT   master_agent[$];
    `UART_RX_CFG     slave_cfg[$];
    `UART_RX_AGENT   slave_agent[$];

  `uvm_component_param_utils_begin(`UART_ENV)
    `uvm_field_queue_object(master_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(master_agent, UVM_ALL_ON)
    `uvm_field_queue_object(slave_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(slave_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "uart_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif // __UART_ENV_SV__
