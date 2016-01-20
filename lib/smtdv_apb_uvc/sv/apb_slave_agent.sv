`ifndef __APB_SLAVE_AGENT_SV__
`define __APB_SLAVE_AGENT_SV__

typedef class apb_slave_cfg;
typedef class apb_item;
typedef class apb_slave_sequencer;
typedef class apb_slave_driver;
typedef class apb_monitor;
//typedef class apb_slave_base_seq;


class apb_slave_agent#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_slave_cfg),
      .T1(apb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .SEQR(apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(apb_slave_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(apb_monitor#(ADDR_WIDTH, DATA_WIDTH, apb_slave_cfg, apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef apb_slave_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;
  //typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "apb_slave_agent", uvm_component parent);
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

endclass : apb_slave_agent

`endif // enf of __APB_SLAVE_AGENT_SV__

