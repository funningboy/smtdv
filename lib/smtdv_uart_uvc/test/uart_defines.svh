
`define UARTTXATTR(i) u_dut_1m1s.M[i].u_uart_tx
`define UARTRXATTR(i) u_dut_1m1s.S[i].u_uart_rx
`define UARTTXVIF(i)  `UARTTXATTR(i).uart_tx_if_harness.vif
`define UARTRXVIF(i)  `UARTRXATTR(i).uart_rx_if_harness.vif
