`ifndef __SMTDV_SLAVE_AGENT_SV__
`define __SMTDV_SLAVE_AGENT_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_slave_cfg;
typedef class smtdv_sequencer;
typedef class smtdv_driver;
typedef class smtdv_monitor;
typedef class smtdv_component;
//typedef class smtdv_slave_base_seq;

/**
* smtdv_slave_agent
* a basic smtdv_slave_agent to build up itself seqr, drv, mon, cfg, vif,
* sequence ...
*
* @class smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, DRV, MON,
* T1)
*
*/
class smtdv_slave_agent#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_slave_cfg,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type DRV = smtdv_driver#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type MON = smtdv_monitor#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, T1)
  ) extends
    smtdv_agent#(
      ADDR_WIDTH,
      DATA_WIDTH,
      VIF,
      CFG,
      T1,
      SEQR,
      DRV,
      MON);

  typedef smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1, SEQR, DRV, MON) agent_t;
  //typedef smtdv_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;

   uvm_tlm_analysis_fifo#(T1) fifo_mon_sqr;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_slave_agent", uvm_component parent=null);
    super.new(name, parent);
    fifo_mon_sqr = new("fifo_mon_sqr", this);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : smtdv_slave_agent


function void smtdv_slave_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // you need to set default seq to it's specific sequencer at top level test
  // put default base seq to sequencer,
  //uvm_config_db#(uvm_object_wrapper)::set(this,
  //  "seqr.run_phase",
  //  "default_sequence",
  //  seq_t::type_id::get());

  if(this.get_is_active())
    mon.seqr = seqr;
endfunction : build_phase


function void smtdv_slave_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // connect monitor to sequencer via tlm analysis port
  mon.item_asserted_port.connect(fifo_mon_sqr.analysis_export);

  if(get_is_active()) begin
    seqr.mon_get_port.connect(fifo_mon_sqr.get_export);
  end
endfunction : connect_phase


`endif // end of __SMTDV_SLAVE_AGENT_SV__


