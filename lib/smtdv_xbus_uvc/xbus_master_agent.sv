
`ifndef __XBUS_MASTER_AGENT_SV__
`define __XBUS_MASTER_AGENT_SV__

class xbus_master_agent #(
  ADDR_WIDTH  = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      `XBUS_VIF,
      `XBUS_MASTER_CFG,
      `XBUS_MASTER_SEQUENCER,
      `XBUS_MASTER_DRIVER,
      `XBUS_MONITOR);

  `uvm_component_param_utils_begin(`XBUS_MASTER_AGENT)
  `uvm_component_utils_end

  function new(string name = "xbus_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // end of __XBUS_MASTER_AGENT_SV__

