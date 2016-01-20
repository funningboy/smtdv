`ifndef __UART_RX_SEQUENCER_SV__
`define __UART_RX_SEQUENCER_SV__

typedef class uart_rx_cfg;
typedef class uart_item;

class uart_rx_sequencer#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_sequencer#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .VIF(virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH)),
    .CFG(uart_rx_cfg),
    .REQ(uart_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef uart_rx_sequencer#(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  `uvm_component_param_utils_begin(seqr_t)
  `uvm_component_utils_end

  function new(string name = "uart_rx_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    fork
      super.run_phase(phase);
      join_none

    reset_restart_sqr(phase);
  endtask : run_phase

  virtual task reset_restart_sqr(uvm_phase phase);
    while(1) begin
      @(negedge resetn);
      m_req_fifo.flush();

      stop_sequences();
      wait(resetn == 1);
      start_phase_sequence(phase);
      end
  endtask :reset_restart_sqr

endclass : uart_rx_sequencer

`endif //__UART_RX_SEQUENCER_SV__

