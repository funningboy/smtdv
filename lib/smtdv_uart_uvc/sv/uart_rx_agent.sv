
`ifndef __UART_RX_AGENT_SV__
`define __UART_RX_AGENT_SV__

class uart_rx_agent #(
  ) extends
    smtdv_agent#(
      `UART_VIF,
      `UART_RX_CFG,
      `UART_RX_SEQUENCER,
      `UART_RX_DRIVER,
      `UART_MONITOR);

  uvm_tlm_analysis_fifo #(`UART_ITEM) fifo_mon_sqr;

  `UART_TX_MONITOR txmon;

  `uvm_component_param_utils_begin(`UART_RX_AGENT)
  `uvm_component_utils_end

  function new(string name = "uart_rx_agent", uvm_component parent);
    super.new(name, parent);
    fifo_mon_sqr = new("fifo_mon_sqr", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // put seq to sequencer
    if(this.get_is_active())
      uvm_config_db#(uvm_object_wrapper)::set(this,
        "seqr.run_phase",
        "default_sequence",
        `UART_BASE_SEQ::type_id::get());

    if(this.get_is_active()) begin
      txmon= `UART_TX_MONITOR::type_id::create("txmon", this);
      txmon.seqr = seqr;
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // connect monitor to sequencer via tlm analysis port
    txmon.item_asserted_port.connect(fifo_mon_sqr.analysis_export);

    if(get_is_active()) begin
      seqr.mon_get_port.connect(fifo_mon_sqr.get_export);
    end
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    txmon.vif = vif;
    txmon.cfg = cfg;
    txmon.has_tx = 1;
    mon.has_rx = 1;
  endfunction



endclass

`endif  // __UART_RX_AGENT_SV__
