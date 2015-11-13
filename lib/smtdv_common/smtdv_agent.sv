
`ifndef __SMTDV_AGENT_SV__
`define __SMTDV_AGENT_SV__

class smtdv_agent #( type VIF = virtual smtdv_if,
                    type CFG = smtdv_master_cfg,
                    type SEQR = smtdv_sequencer#(),
                    type DRV = smtdv_driver#(VIF, CFG),
                    type MON = smtdv_monitor#(VIF, CFG))
              extends smtdv_component#(uvm_agent);

  SEQR seqr;
  DRV drv;
  MON mon;

  VIF vif;
  CFG cfg;

  `uvm_component_param_utils_begin(smtdv_agent#(VIF, CFG, SEQR, DRV, MON))
  `uvm_component_utils_end

  function new(string name = "smtdv_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mon= MON::type_id::create("mon", this);

    if(this.get_is_active()) begin
      seqr= SEQR::type_id::create("seqr", this);
      drv= DRV::type_id::create("drv", this);
      end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(this.get_is_active()) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
      end
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // populate vif to child
    if(vif == null) begin
      if(!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    end
    assign_vi(vif);
    // populate cfg to child
    if(cfg == null) begin
      if(!uvm_config_db#(CFG)::get(this, "", "cfg", cfg))
      `uvm_fatal("NOCFG",{"cfg must be set for: ",get_full_name(),".cfg"});
    end
    assign_cfg(cfg);
  endfunction

  virtual function void assign_vi(VIF vif);
    mon.vif= vif;
    if(this.get_is_active())
      drv.vif= vif;
  endfunction

  virtual function void assign_cfg(CFG cfg);
    mon.cfg = cfg;
    if(this.get_is_active())
      drv.cfg = cfg;
  endfunction

endclass : smtdv_agent

`endif // end of __SMTDV_AGENT_SV__
