`ifndef __AHB_MASTER_AGENT_SV__
`define __AHB_MASTER_AGENT_SV__

typedef class ahb_master_cfg;
typedef class ahb_item;
typedef class ahb_master_sequencer;
typedef class ahb_master_driver;
typedef class ahb_monitor;

class ahb_master_agent #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_master_cfg),
      .T1(ahb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .SEQR(ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(ahb_master_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(ahb_monitor#(ADDR_WIDTH, DATA_WIDTH, ahb_master_cfg, ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
    );

  typedef ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "ahb_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : ahb_master_agent

`endif // end of __AHB_MASTER_AGENT_SV__

