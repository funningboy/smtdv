`ifndef __UART_TX_CFG_SV__
`define __UART_TX_CFG_SV__

class uart_tx_cfg
  extends
    uart_base_cfg;

  `uvm_object_param_utils_begin(`UART_TX_CFG)
  `uvm_object_utils_end

  function new(string name = "uart_tx_cfg");
    super.new(name);
  endfunction

endclass

`endif // __UART_TX_CFG_SV__
