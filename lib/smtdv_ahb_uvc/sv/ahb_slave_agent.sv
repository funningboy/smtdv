`ifndef __AHB_SLAVE_AGENT_SV__
`define __AHB_SLAVE_AGENT_SV__

typedef class ahb_slave_cfg;
typedef class ahb_item;
typedef class ahb_slave_sequencer;
typedef class ahb_slave_driver;
typedef class ahb_monitor;
//typedef class ahb_slave_base_seq;


class ahb_slave_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_slave_cfg),
      .T1(ahb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .SEQR(ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(ahb_slave_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(ahb_monitor#(ADDR_WIDTH, DATA_WIDTH, ahb_slave_cfg, ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef ahb_slave_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;
  //typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "ahb_slave_agent", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // put seq to sequencer
    //uvm_config_db#(uvm_object_wrapper)::set(this,
    //  "seqr.run_phase",
    //  "default_sequence",
    //  seq_t::type_id::get());
  endfunction : build_phase

endclass : ahb_slave_agent

`endif // enf of __AHB_SLAVE_AGENT_SV__

