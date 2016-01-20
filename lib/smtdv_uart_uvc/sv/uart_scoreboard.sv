
`ifndef __UART_SCOREBOARD_SV__
`define __UART_SCOREBOARD_SV__

/*
* TX(master) to RX(slave) scoreboard
*/
class uart_tx_scoreboard#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4
 ) extends
    smtdv_scoreboard#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .NUM_OF_INITOR(NUM_OF_INITOR),
      .NUM_OF_TARGETS(NUM_OF_TARGETS),
      .T1(uart_item#(ADDR_WIDTH, DATA_WIDTH)),
      .T2(uart_tx_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .T3(uart_rx_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(smtdv_cfg)
  );

  typedef uart_tx_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS) scb_t;

  `uvm_component_param_utils_begin(scb_t)
  `uvm_component_utils_end

  function new (string name = "uart_tx_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_tx_scoreboard

/*
* master(rx) -> slave(tx) scoreboard
*/
class uart_rx_scoreboard#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4
 ) extends
    smtdv_scoreboard#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .NUM_OF_INITOR(NUM_OF_INITOR),
      .NUM_OF_TARGETS(NUM_OF_TARGETS),
      .T1(uart_item#(ADDR_WIDTH, DATA_WIDTH)),
      .T2(uart_rx_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .T3(uart_tx_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(smtdv_cfg)
  );

  typedef uart_rx_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS) scb_t;

  `uvm_component_param_utils_begin(scb_t)
  `uvm_component_utils_end

  function new (string name = "uart_rx_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : uart_rx_scoreboard

`endif // __UART_SCOREBOARD_SV__
