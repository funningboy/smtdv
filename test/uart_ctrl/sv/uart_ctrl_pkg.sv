
`ifndef UART_CRTL_PKG_SV
`define UART_CRTL_PKG_SV

package uart_ctrl_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_pkg::*;
import uart_pkg::*;

`include "uart_ctrl_config.sv"
`include "uart_ctrl_reg_model.sv"
//`include "reg_to_apb_adapter.sv"
`include "uart_ctrl_scoreboard.sv"
`include "coverage/uart_ctrl_cover.sv"
`include "uart_ctrl_monitor.sv"
`include "uart_ctrl_reg_sequencer.sv"
`include "uart_ctrl_virtual_sequencer.sv"
`include "uart_ctrl_env.sv"

endpackage : uart_ctrl_pkg

`endif //UART_CTRL_PKG_SV
