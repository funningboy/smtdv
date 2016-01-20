
`ifndef __APB_MASTER_AGENT_SV__
`define __APB_MASTER_AGENT_SV__

typedef class apb_master_cfg;
typedef class apb_item;
typedef class apb_master_sequencer;
typedef class apb_master_driver;
typedef class apb_monitor;

class apb_master_agent#(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_master_cfg),
      .T1(apb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .SEQR(apb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(apb_master_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(apb_monitor#(ADDR_WIDTH, DATA_WIDTH,apb_master_cfg, apb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
    );

  typedef apb_master_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "apb_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : apb_master_agent

`endif // end of __APB_MASTER_AGENT_SV__

