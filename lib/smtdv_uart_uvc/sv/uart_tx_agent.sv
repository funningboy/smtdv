`ifndef __UART_TX_AGENT_SV__
`define __UART_TX_AGENT_SV__

typedef class uart_tx_cfg;
typedef class uart_item;
typedef class uart_tx_sequencer;
typedef class uart_tx_driver;
typedef class uart_monitor;

class uart_tx_agent#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(uart_tx_cfg),
      .T1(uart_item#(ADDR_WIDTH, DATA_WIDTH)),
      .SEQR(uart_tx_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(uart_tx_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(uart_monitor#(ADDR_WIDTH, DATA_WIDTH, uart_tx_cfg, uart_tx_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef uart_tx_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "uart_tx_agent", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_tx_agent

`endif // enf of __UART_TX_AGENT_SV__

