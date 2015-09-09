
`ifndef __CDNBUS_MASTER_0_SV__
`define __CDNBUS_MASTER_0_SV__


class cdnbus_master_0 #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  ahb_master_agent(
    ADDR_WIDTH,
    DATA_WIDTH
  );

  `uvm_component_param_utils_begin(`CDNBUS_MASTER_0)
  `uvm_component_utils_end

  function new(string name = "cndbus_master_0", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // end of __CDNBUS_MASTER_0_SV__


