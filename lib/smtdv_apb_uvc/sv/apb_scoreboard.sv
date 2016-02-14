
`ifndef __APB_SCOREBOARD_SV__
`define __APB_SCOREBOARD_SV__

//typedef class apb_item;
//typedef class apb_master_agent;
//typedef class apb_slave_agent;

class apb_base_scoreboard#(
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
      .T1(apb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .T2(apb_master_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .T3(apb_slave_agent#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(smtdv_cfg)
  );

  typedef apb_base_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS) scb_t;

  `uvm_component_param_utils_begin(scb_t)
  `uvm_component_utils_end

  function new (string name = "apb_base_scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : apb_base_scoreboard

`endif // __APB_SCOREBOARD_SV__
