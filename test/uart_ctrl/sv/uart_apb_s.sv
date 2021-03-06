`ifndef __UART_CTRL_APB_S0_SV__
`define __UART_CTRL_APB_S0_SV__

// type override for self coverage group, update addr, data
class uart_apb_s_cover_group #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  `SMTDV_COLLECT_COVER_GROUP(apb, ADDR_WIDTH, DATA_WIDTH);

  // start_addr = `APB_START_ADDR(0);
  // end_addr `APB_END_ADDR(0);
   `uvm_object_param_utils_begin(`UART_APB_S_COVER_GROUP)
   `uvm_object_utils_end

    function new(string name = "uart_apb_s_cover_group", smtdv_component parent=null);
      super.new(name, parent);
    endfunction

endclass



// bind apb master uvc to UART Wishbone slave port
class uart_apb_s_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `SMTDV_MASTER_AGENT(apb, ADDR_WIDTH, DATA_WIDTH);

  // extend cover_group thread to mon
  `UART_APB_S_COVER_GROUP th5;

  `uvm_component_param_utils_begin(`UART_APB_S_AGENT)
  `uvm_component_utils_end

  function new(string name = "uart_apb_s_agent", uvm_component parent=null);
    super.new(name, parent);
    th5 = `UART_APB_S_COVER_GROUP::type_id::create("uart_apb_s_cover_group", this.mon);

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    // override cover group to subsystem define
    this.mon.th_handler.del(this.mon.th4);
    th5.cmp = this.mon; this.mom.th_handler.add(th5);

    //
  endfunction


endclass


class uart_apb_s_cfg
 extends
  `SMTDV_MASTER_CFG(apb);

  `uvm_object_param_utils_begin(`UART_APB_S_CFG)
  `uvm_object_utils_end

  function new(string name = "uart_apb_s_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

`endif // end of __UART_CTRL_APB_S0_SV__
