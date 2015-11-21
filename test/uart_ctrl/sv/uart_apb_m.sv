`ifndef __UART_APB_S0_SV__
`define __UART_APB_S0_SV__

// bind apb master uvc to UART Wishbone slave port
class uart_apb_s_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_MASTER_AGENT;

  `uvm_component_param_utils_begin(`UART_APB_S_AGENT)
  `uvm_component_utils_end

  function new(string name = "uart_apb_s_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass


class uart_apb_s_cfg
 extends
  `APB_MASTER_CFG;

  `uvm_object_param_utils_begin(`UART_APB_S_CFG)
  `uvm_object_utils_end

  function new(string name = "uart_apb_s_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

// type override for self coverage group, update addr, data
class uart_apb_s_cover_group #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  `APB_COLLECT_COVER_GROUP;

   `uvm_object_param_utils_begin(`UART_APB_S_COVER_GROUP)
   `uvm_object_utils_end

    function new(string name = "uart_apb_s_cover_group");
      super.new(name);
      apb_coverage = new();
    endfunction

endclass

`endif // end of __UART_APB_S0_SV__
