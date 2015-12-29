
`ifndef __SMTDV_AGENT_SV__
`define __SMTDV_AGENT_SV__

typedef class smtdv_cfg;
typedef class smtdv_sequence_item;
typedef class smtdv_sequencer;
typedef class smtdv_driver;
typedef class smtdv_monitor;
typedef class smtdv_component;

/**
* smtdv_agent
* a basic smtdv_agent to build up itself seqr, drv, mon, cfg, vif ...
*
* @class smtdv_agent#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, DRV, MON, T1)
*
*/
class smtdv_agent #(
  int ADDR_WIDTH = 14,
  int DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_cfg,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type DRV = smtdv_driver#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1),
  type MON = smtdv_monitor#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, T1)
  ) extends
    smtdv_component#(uvm_agent);

  SEQR seqr;
  DRV drv;
  MON mon;

  VIF vif;
  CFG cfg;

  T1 item;

  typedef smtdv_agent#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1, SEQR, DRV, MON) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual function void assign_vi(VIF vif);
  extern virtual function void assign_cfg(CFG cfg);

endclass : smtdv_agent


function void smtdv_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  mon= MON::type_id::create("mon", this);

  if(this.get_is_active()) begin
    seqr= SEQR::type_id::create("seqr", this);
    drv= DRV::type_id::create("drv", this);
  end
endfunction : build_phase


function void smtdv_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(this.get_is_active()) begin
    drv.seq_item_port.connect(seqr.seq_item_export);
  end
endfunction : connect_phase


function void smtdv_agent::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  if(vif == null) begin
    if(!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("SMTDV_AGENT_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET ",get_full_name(),".vif"});
  end
  assign_vi(vif);
  if(cfg == null) begin
    if(!uvm_config_db#(CFG)::get(this, "", "cfg", cfg))
    `uvm_fatal("SMTDV_AGENT_NO_CFG",{"CFG MUST BE SET ",get_full_name(),".cfg"});
  end
  `uvm_info(get_full_name(), {$psprintf("CREATE DEFAULT CFG: %s\n", cfg.sprint())}, UVM_LOW)
  assign_cfg(cfg);
endfunction : end_of_elaboration_phase

function void smtdv_agent::assign_vi(VIF vif);
  mon.vif= vif;
  if(this.get_is_active()) begin
    drv.vif = vif;
    seqr.vif = vif;
  end
endfunction : assign_vi

function void smtdv_agent::assign_cfg(CFG cfg);
  mon.cfg = cfg;
  if(this.get_is_active()) begin
    drv.cfg = cfg;
    seqr.cfg = cfg;
    seqr.cfg = cfg;
  end
endfunction : assign_cfg


`endif // end of __SMTDV_AGENT_SV__
