
`ifndef __APB_MASTER_AGENT_SV__
`define __APB_MASTER_AGENT_SV__

class apb_master_agent #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      `APB_VIF,
      `APB_MASTER_CFG,
      `APB_MASTER_SEQUENCER,
      `APB_MASTER_DRIVER,
      `APB_MONITOR);

  `uvm_component_param_utils_begin(`APB_MASTER_AGENT)
  `uvm_component_utils_end

  function new(string name = "apb_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // end of __APB_MASTER_AGENT_SV__

