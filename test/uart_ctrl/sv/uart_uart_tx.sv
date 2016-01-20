
`ifndef __UART_CTRL_UART_TX0_SV__
`define __UART_CTRL_UART_TX0_SV__

// bind uart rx uvc to UART tx port
class uart_uart_tx_agent#(
  ) extends
    `SMTDV_RX_AGENT(uart);

`endif
