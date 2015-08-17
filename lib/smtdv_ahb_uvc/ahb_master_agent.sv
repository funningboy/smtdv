`ifndef __AHB_MASTER_AGENT_SV__
`define __AHB_MASTER_AGENT_SV__

class ahb_master_agent #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      `AHB_VIF,
      `AHB_MASTER_CFG,
      `AHB_MASTER_SEQUENCER,
      `AHB_MASTER_DRIVER,
      `AHB_MONITOR);

  `uvm_component_param_utils_begin(`AHB_MASTER_AGENT)
  `uvm_component_utils_end

  function new(string name = "ahb_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // end of __AHB_MASTER_AGENT_SV__

