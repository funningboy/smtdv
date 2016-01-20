`ifndef __UART_TX_DRIVER_SV__
`define __UART_TX_DRIVER_SV__

typedef class uart_tx_cfg;
typedef class uart_item;
typedef class uart_tx_drive_items;
typedef class uart_tx_sample_rate;

class uart_tx_driver#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_driver#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .VIF(virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH)),
    .CFG(uart_tx_cfg),
    .REQ(uart_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef uart_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef uart_tx_driver#(ADDR_WIDTH, DATA_WIDTH) drv_t;
  typedef uart_tx_drive_items#(ADDR_WIDTH, DATA_WIDTH) drv_items_t;
  typedef uart_tx_sample_rate#(ADDR_WIDTH, DATA_WIDTH) smp_rate_t;
  typedef smtdv_thread_handler#(drv_t) hdler_t;

  hdler_t th_handler;

  mailbox#(item_t) mbox;
  drv_items_t th0;
  smp_rate_t th1;

  bit sample_clk;
  bit baud_clk;
  bit [15:0] ua_brgr;
  bit [7:0] ua_bdiv;
  int num_of_bits_sent;
  int num_items_sent = 0;

  `uvm_component_param_utils_begin(drv_t)
    `uvm_field_int(sample_clk, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  function new(string name = "uart_tx_driver", uvm_component parent);
    super.new(name, parent);
    mbox = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = drv_items_t::type_id::create("uart_tx_drive_items", this);
    th1 = smp_rate_t::type_id::create("uart_tx_sample_rate", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
    th1.register(this); th_handler.add(th1);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();
  extern virtual task run_threads();

endclass : uart_tx_driver

task uart_tx_driver::run_threads();
  super.run_threads();
  th_handler.run();
endtask : run_threads

task uart_tx_driver::reset_driver();
  mbox = new();
  reset_inf();
endtask : reset_driver

task uart_tx_driver::reset_inf();
  this.vif.tx.txd <= 'h1;
  this.vif.tx.rts_n <= 'h0;
  this.vif.tx.dtr_n <= 'h0;
  this.vif.tx.dcd_n <= 'h0;
  this.vif.tx.baud_clk <= 'h0;
endtask : reset_inf

task uart_tx_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask : drive_bus

`endif // end of __UART_TX_DRIVER_SV__

