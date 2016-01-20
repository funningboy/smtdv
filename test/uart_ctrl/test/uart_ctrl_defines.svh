

`ifndef __UART_CTRL_DEFINES_SV__
`define __UART_CTRL_DEFINES_SV__

`include "apb_if.sv"
`include "uart_if.sv"

`define UARTTOPATTR u_tb_top

`ifdef APB_VIF
  `undef APB_VIF
`endif
`define APB_VIF virtual interface apb_if #(APB_ADDR_WIDTH, APB_DATA_WIDTH)

`ifdef UART_VIF
  `undef UART_VIF
`endif
`define UART_VIF virtual interface uart_if #()

`ifndef UART_CTRL_DEFINES_SVH
`define UART_CTRL_DEFINES_SVH
`endif

`define RX_FIFO_REG 32'h00
`define TX_FIFO_REG 32'h00
`define INTR_EN 32'h01
`define INTR_ID 32'h02
`define FIFO_CTRL 32'h02
`define LINE_CTRL 32'h03
`define MODM_CTRL 32'h04
`define LINE_STAS 32'h05
`define MODM_STAS 32'h06

`define DIVD_LATCH1 32'h00
`define DIVD_LATCH2 32'h01

`define UA_TX_FIFO_DEPTH 14


`endif // end of __UART_CTRL_DEFINES_SV__
