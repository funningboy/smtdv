/*-------------------------------------------------------------------------
File name   : uart_ctrl_config.svh
Title       : UART Controller configuration
Project     :
Created     :
Description : This file contains multiple configuration classes:
                apb_config
                   master_config
                   slave_configs[N]
                uart_config
Notes       :
----------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


`ifndef UART_CTRL_CONFIG_SV
`define UART_CTRL_CONFIG_SV

// UART Controller Configuration Class
class uart_ctrl_config
  extends
  uvm_object;

  parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
  parameter DATA_WIDTH = `APB_DATA_WIDTH;

  `APB_SLAVE_CFG  apb_s_cfg[$];
  `APB_MASTER_CFG apb_m_cfg[$];
  `UART_BASE_CFG  uart_cfg[$];

  `uvm_object_utils_begin(uart_ctrl_config)
      `uvm_field_queue_object(apb_s_cfg, UVM_DEFAULT)
      `uvm_field_queue_object(apb_m_cfg, UVM_DEFAULT)
      `uvm_field_queue_object(uart_cfg, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "uart_ctrl_config");
    super.new(name);
    uart_cfg[0] = `UART_BASE_CFG::type_id::create({$psprintf("uart_cfg[%0d", 0)});
    apb_m_cfg[0] = `APB_MASTER_CFG::type_id::create({$psprintf("slave_cfg[%0d]", 0)});
    apb_s_cfg[0] = `APB_SLAVE_CFG::type_id::create({$psprintf("slave_cfg[%0d]", 0)});
  endfunction : new

endclass : uart_ctrl_config

//================================================================
class default_uart_ctrl_config extends uart_ctrl_config;

  `uvm_object_utils(default_uart_ctrl_config)

  function new(string name = "default_uart_ctrl_config");
    super.new(name);
    apb_m_cfg[0].add_slave(apb_s_cfg[0], 0, 32'h0000_0000, 32'h7FFF_FFFF);
  endfunction

endclass : default_uart_ctrl_config

`endif // UART_CTRL_CONFIG_SV
