`ifndef __UART_CTRL_TYPEDEFS_SV__
`define __UART_CTRL_TYPEDEFS_SV__

`include "override_typedefs.svh"

`define UART_CTRL_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)

`define UART_CTRL_REG_SEQUENCER uart_ctrl_reg_sequencer

`define UART_APB_S_AGENT  uart_apb_s_agent `UART_CTRL_PARAMETER
`define UART_APB_S_CFG    uart_apb_s_cfg
`define UART_APB_S_COVER_GROUP  uart_apb_s_cover_group `UART_CTRL_PARAMETER
`define UART_CLUSTER0 uart_cluster0
`define UART_CLUSTER1 uart_cluster1

`endif // end of __UART_CTRL_TYPEDEFS_SV__
