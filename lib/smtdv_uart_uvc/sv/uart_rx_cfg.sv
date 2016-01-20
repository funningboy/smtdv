
`ifndef __UART_RX_CFG_SV__
`define __UART_RX_CFG_SV__

typedef class uart_base_cfg;

class uart_rx_cfg
  extends
    uart_base_cfg;

  typedef uart_rx_cfg cfg_t;

  `uvm_object_param_utils_begin(cfg_t)
  `uvm_object_utils_end

  function new(string name = "uart_rx_cfg");
    super.new(name);
  endfunction : new

endclass : uart_rx_cfg

`endif // __UART_RX_CFG_SV__
