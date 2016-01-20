`ifndef __UART_MONITOR_SV__
`define __UART_MONITOR_SV__

typedef class uart_item;
typedef class uart_rx_sequencer;
typedef class uart_rx_sequencer;
typedef class uart_tx_cfg;
typedef class uart_rx_cfg;

class uart_monitor#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = uart_rx_cfg,
  type SEQR = uart_rx_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    smtdv_monitor#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(CFG),
      .SEQR(SEQR),
      .T1(uart_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef uart_monitor#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) mon_t;
  typedef uart_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef uart_gen_sample_rate#(ADDR_WIDTH, DATA_WIDTH)     gen_smp_rate_t;
  typedef uart_start_synchronizer#(ADDR_WIDTH, DATA_WIDTH)  start_sync_t;
  typedef uart_sample_and_store#(ADDR_WIDTH, DATA_WIDTH)    smp_and_store_t;
  typedef uart_collect_stop_signal#(ADDR_WIDTH, DATA_WIDTH) coll_stop_sin_t;
  typedef uart_collect_cover_group#(ADDR_WIDTH, DATA_WIDTH) coll_cov_grp_t;
  typedef uart_export_collected_items#(ADDR_WIDTH, DATA_WIDTH) exp_coll_items_t;
  typedef smtdv_thread_handler#(mon_t) hdler_t;

  hdler_t th_handler;

  mailbox#(item_t) cbox;
  mailbox#(item_t) ebox;

  gen_smp_rate_t th0;
  start_sync_t   th1;
  smp_and_store_t th2;
  coll_stop_sin_t th3;
  coll_cov_grp_t th4;
  exp_coll_items_t th5;

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

  bit has_rx = 0;
  bit has_tx = 0;

  `uvm_component_param_utils_begin(mon_t)
  `uvm_component_utils_end

  function new (string name = "uart_monitor", uvm_component parent);
    super.new(name, parent);
    cbox = new();
    ebox = new();
  endfunction : new

  // register thread to thread handler
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = gen_smp_rate_t::type_id::create("uart_gen_sample_rate", this);
    th1 = start_sync_t::type_id::create("uart_start_synchronizer", this);
    th2 = smp_and_store_t::type_id::create("uart_sample_and_store", this);
    th3 = coll_stop_sin_t::type_id::create("uart_collect_stop_signal", this);

    th4 = coll_cov_grp_t::type_id::create("uart_collect_cover_group", this);
    th5 = exp_coll_items_t::type_id::create("uart_export_collected_items", this);

    th_handler = hdler_t::type_id::create("uart_monitor_handler", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
    th1.register(this); th_handler.add(th1);
    th2.register(this); th_handler.add(th2);
    th3.register(this); th_handler.add(th3);
    th4.register(this); th_handler.add(th4);
    th5.register(this); th_handler.add(th5);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.finalize();
    endfunction : end_of_elaboration_phase

  virtual task run_threads();
    super.run_threads();
    th_handler.run();
  endtask : run_threads

endclass : uart_monitor

`endif // end of __UART_MONITOR_SV__

