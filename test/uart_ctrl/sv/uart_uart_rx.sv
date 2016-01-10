`ifndef __UART_UART_RX_SV__
`define __UART_UART_RX_SV__

// bind uart tx uvc to UART rx port
class uart_uart_rx_agent #(
  ) extends
    uart_tx_agent;

endclass

`endif // end of __UART_UART_RX_SV__
