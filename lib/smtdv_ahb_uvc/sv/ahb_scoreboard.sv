
`ifndef __AHB_SCOREBOARD_SV__
`define __AHB_SCOREBOARD_SV__

class ahb_base_scoreboard #(
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
      .T1(ahb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .T2(ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .T3(ahb_slave_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(smtdv_cfg)
  );

  typedef ahb_base_scoreboard #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS) scb_t;

  `uvm_component_param_utils_begin(scb_t)
  `uvm_component_utils_end

  function new (string name = "ahb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ahb_base_scoreboard

`endif // __AHB_SCOREBOARD_SV__
