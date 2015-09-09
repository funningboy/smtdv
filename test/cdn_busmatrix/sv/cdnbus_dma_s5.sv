`ifndef __CDNBUS_MASTER_0_SV__
`define __CDNBUS_MASTER_0_SV__


class cdnbus_master_0 #(
  MASTER_ADDR_WIDTH = 14,
  MASTER_DATA_WIDTH = 32,
  SLAVE_ADDR_WIDTH = ,
  SLAVE_DATA_WIDTH =
) extends

  uvm_reg
  `AHB_MASTER_AGENT
  `AHB_SLAVE_AGENT
  `AHB_IRQ_AGENT

  `uvm_component_param_utils_begin(`CDNBUS_MASTER_0)
  `uvm_component_utils_end

  function new(string name = "cndbus_master_0", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    type_id::create
    set type
  endfunction

endclass

`endif // end of __CDNBUS_MASTER_0_SV__


