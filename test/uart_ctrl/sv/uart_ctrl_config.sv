
`ifndef UART_CTRL_CONFIG_SV
`define UART_CTRL_CONFIG_SV

// UART Controller Configuration Cluster
//class uart_ctrl_config
//  extends
//  uvm_object;
//
//  parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
//  parameter DATA_WIDTH = `APB_DATA_WIDTH;
//
//  `APB_SLAVE_CFG  apb_s_cfg[$];
//  `APB_MASTER_CFG apb_m_cfg[$];
//  `UART_BASE_CFG  uart_cfg[$];
//
//  `uvm_object_utils_begin(uart_ctrl_config)
//      `uvm_field_queue_object(apb_s_cfg, UVM_DEFAULT)
//      `uvm_field_queue_object(apb_m_cfg, UVM_DEFAULT)
//      `uvm_field_queue_object(uart_cfg, UVM_DEFAULT)
//  `uvm_object_utils_end
//
//  function new (string name = "uart_ctrl_config");
//    super.new(name);
//    uart_cfg[0] = `UART_BASE_CFG::type_id::create({$psprintf("uart_cfg[%0d", 0)});
//    apb_m_cfg[0] = `APB_MASTER_CFG::type_id::create({$psprintf("slave_cfg[%0d]", 0)});
//    apb_s_cfg[0] = `APB_SLAVE_CFG::type_id::create({$psprintf("slave_cfg[%0d]", 0)});
//  endfunction : new
//
//endclass : uart_ctrl_config
//
////================================================================
//class default_uart_ctrl_config extends uart_ctrl_config;
//
//  `uvm_object_utils(default_uart_ctrl_config)
//
//  function new(string name = "default_uart_ctrl_config");
//    super.new(name);
//    apb_m_cfg[0].add_slave(apb_s_cfg[0], 0, 32'h0000_0000, 32'h7FFF_FFFF);
//  endfunction
//
//endclass : default_uart_ctrl_config

`endif // UART_CTRL_CONFIG_SV
