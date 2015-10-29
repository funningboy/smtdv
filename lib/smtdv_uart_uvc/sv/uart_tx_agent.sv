`ifndef __UART_TX_AGENT_SV__
`define __UART_TX_AGENT_SV__

class uart_tx_agent #(
  ) extends
    smtdv_agent#(
      `UART_VIF,
      `UART_TX_CFG,
      `UART_TX_SEQUENCER,
      `UART_TX_DRIVER,
      `UART_MONITOR);

  `uvm_component_param_utils_begin(`UART_TX_AGENT)
  `uvm_component_utils_end

  function new(string name = "uart_tx_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // enf of __UART_TX_AGENT_SV__

