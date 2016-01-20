
`ifndef __UART_RX_AGENT_SV__
`define __UART_RX_AGENT_SV__

typedef class uart_rx_cfg;
typedef class uart_item;
typedef class uart_rx_sequencer;
typedef class uart_rx_driver;
typedef class uart_monitor;

class uart_rx_agent#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(uart_rx_cfg),
      .T1(uart_item#(ADDR_WIDTH, DATA_WIDTH)),
      .SEQR(uart_rx_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(uart_rx_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(uart_monitor#(ADDR_WIDTH, DATA_WIDTH, uart_rx_cfg, uart_rx_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef uart_rx_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "uart_rx_agent", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // put seq to sequencer
    //if(this.get_is_active())
    //  uvm_config_db#(uvm_object_wrapper)::set(this,
    //    "seqr.run_phase",
    //    "default_sequence",
    //    seq_t::type_id::get());

    if(this.get_is_active()) begin
      txmon= ::type_id::create("txmon", this);
      txmon.seqr = seqr;
    end
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // connect monitor to sequencer via tlm analysis port
    txmon.item_asserted_port.connect(fifo_mon_sqr.analysis_export);

    if(get_is_active()) begin
      seqr.mon_get_port.connect(fifo_mon_sqr.get_export);
    end
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    txmon.vif = vif;
    txmon.cfg = cfg;
    txmon.has_tx = 1;
    mon.has_rx = 1;
  endfunction : end_of_elaboration_phase

endclass : uart_rx_agent

`endif  // __UART_RX_AGENT_SV__
