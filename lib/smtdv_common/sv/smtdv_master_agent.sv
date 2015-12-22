`ifndef __SMTDV_MASTER_AGENT_SV__
`define __SMTDV_MASTER_AGENT_SV__

typedef class smtdv_master_cfg;
typedef class smtdv_sequencer;
typedef class smtdv_driver;
typedef class smtdv_monitor;
typedef class smtdv_component;
typedef class smtdv_sequence_item;

/**
* smtdv_master_agent
* a basic smtdv_master_agent to build up itself seqr, drv, mon, cfg, vif,
  * sequence ...
*
* @class smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, DRV, MON,
* T1)
*
*/
class smtdv_master_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_master_cfg,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type DRV = smtdv_driver#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type MON = smtdv_monitor#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, T1)
  ) extends
    smtdv_agent #(
      ADDR_WIDTH,
      DATA_WIDTH,
      VIF,
      CFG,
      T1,
      SEQR,
      DRV,
      MON);

  typedef smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1, SEQR, DRV, MON) agent_t;

   uvm_tlm_analysis_fifo #(T1) fifo_mon_sqr;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_master_agent", uvm_component parent=null);
    super.new(name, parent);
    fifo_mon_sqr = new("fifo_mon_sqr", this);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : smtdv_master_agent

function void smtdv_master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // always on watch retry trx when err/retry received
  mon.seqr = seqr;
endfunction

function void smtdv_master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // connect monitor to sequencer via tlm analysis port
  mon.item_asserted_port.connect(fifo_mon_sqr.analysis_export);

  seqr.mon_get_port.connect(fifo_mon_sqr.get_export);
endfunction


`endif // end of __SMTDV_MASTER_AGENT_SV__


