`ifndef __UART_MONITOR_SV__
`define __UART_MONITOR_SV__

typedef class uart_rx_sequencer;

class uart_monitor #(
  type CFG = `UART_BASE_CFG
) extends
  smtdv_monitor#(
    `UART_VIF,
    CFG
  );

  `UART_RX_SEQUENCER seqr;

  int num_items;
  bit sample_clk;
  bit baud_clk;
  bit [15:0] ua_brgr;
  bit [7:0] ua_bdiv;
  int num_of_bits_rcvd;
  bit sop_detected;
  bit tmp_bit0;
  bit serial_d1;
  bit serial_bit;
  bit serial_b;
  bit [1:0]  msb_lsb_data;
  int transmit_delay;

  /* tlm analysis port to dumper/scoreboard or third part golden model(c/systemc) */
  uvm_analysis_port #(`UART_ITEM) item_collected_port;
  uvm_analysis_port #(`UART_ITEM) item_asserted_port;
  mailbox #(`UART_ITEM) cbox;
  mailbox #(`UART_ITEM) ebox;

  `UART_GEN_SAMPLE_RATE     th0;
  `UART_START_SYNCHRONIZER  th1;
  `UART_SAMPLE_AND_STORE    th2;
  `UART_COLLECT_STOP_SIGNAL th3;
  `UART_COLLECT_COVER_GROUP th4;
  `UART_EXPORT_COLLECTED_ITEMS th5;

  `uvm_component_param_utils_begin(`UART_MONITOR)
  `uvm_component_utils_end

  function new (string name = "uart_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    item_asserted_port = new("item_asserted_port", this);
    cbox = new();
    ebox = new();
  endfunction

  // register thread to thread handler
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `UART_GEN_SAMPLE_RATE::type_id::create("uart_gen_sample_rate"); th0.cmp = this; this.th_handler.add(th0);
    th1 = `UART_START_SYNCHRONIZER::type_id::create("uart_start_synchronizer");   th1.cmp = this; this.th_handler.add(th1);
    th2 = `UART_SAMPLE_AND_STORE::type_id::create("uart_sample_and_store"); th2.cmp = this; this.th_handler.add(th2);
    th3 = `UART_COLLECT_STOP_SIGNAL::type_id::create("uart_collect_stop_signal"); th3.cmp = this; this.th_handler.add(th3);
    th4 = `UART_COLLECT_COVER_GROUP::type_id::create("uart_collect_cover_group"); th4.cmp = this; this.th_handler.add(th4);
    th5 = `UART_EXPORT_COLLECTED_ITEMS::type_id::create("uart_export_collected_items"); th5.cmp = this; this.th_handler.add(th5);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // populate vif to child
    if(seqr == null) begin
      if(!uvm_config_db#(`UART_RX_SEQUENCER)::get(this, "", "seqr", seqr))
      `uvm_warning("NOSEQR",{"tx sequencer must be set for: ",get_full_name(),".seqr"});
    end
  endfunction

endclass

`endif // end of __UART_MONITOR_SV__

