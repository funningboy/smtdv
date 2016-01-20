`ifndef __UART_TX_CFG_SV__
`define __UART_TX_CFG_SV__

typedef class uart_base_cfg;

class uart_tx_cfg
  extends
  uart_base_cfg;

  typedef uart_tx_cfg cfg_t;

  `uvm_object_param_utils_begin(cfg_t)
  `uvm_object_utils_end

  function new(string name = "uart_tx_cfg");
    super.new(name);
  endfunction : new

endclass : uart_tx_cfg

`endif // __UART_TX_CFG_SV__
