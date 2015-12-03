`ifndef __SMTDV_MASTER_AGENT_SV__
`define __SMTDV_MASTER_AGENT_SV__

class smtdv_master_agent #( type VIF = virtual interface smtdv_if,
                    type CFG = smtdv_master_cfg,
                    type SEQR = smtdv_sequencer#(),
                    type DRV = smtdv_driver#(VIF, CFG),
                    type MON = smtdv_monitor#(VIF, CFG))
      extends smtdv_agent #(
          VIF,
          CFG,
          DRV,
          MON
      );
  `uvm_component_param_utils_begin(smtdv_master_agent#(VIF, CFG, SEQR, DRV, MON))
  `uvm_component_utils_end

  function new(string name = "smtdv_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass : smtdv_master_agent

`endif // end of __SMTDV_MASTER_AGENT_SV__


