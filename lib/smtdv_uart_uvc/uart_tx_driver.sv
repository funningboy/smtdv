`ifndef __UART_TX_DRIVER_SV__
`define __UART_TX_DRIVER_SV__

class uart_tx_driver #(
) extends
  smtdv_driver#(
    `UART_VIF,
    `UART_TX_CFG,
    `UART_ITEM
  );

  mailbox #(`UART_ITEM) mbox;

  bit sample_clk;
  bit baud_clk;
  bit [15:0] ua_brgr;
  bit [7:0] ua_bdiv;
  int num_of_bits_sent;
  int num_frames_sent;

  `UART_TX_DRIVE_ITEMS th0;
  `UART_TX_SAMPLE_RATE th1;

  `uvm_component_param_utils_begin(`UART_TX_DRIVER)
    `uvm_field_int(sample_clk, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(baud_clk, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_brgr, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  function new(string name = "uart_tx_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `UART_TX_DRIVE_ITEMS::type_id::create("uart_tx_drive_items");
    th0.cmp = this;
    this.th_handler.add(th0);
    th1 = `UART_TX_SAMPLE_RATE::type_id::create("uart_tx_sample_rate");
    th1.cmp = this;
    this.th_handler.add(th1);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task uart_tx_driver::reset_driver();
  mbox = new();
  reset_inf();
endtask

task uart_tx_driver::reset_inf();
  this.vif.tx.txd <= 1;
  this.vif.tx.rts_n <= 0;
  this.vif.tx.dtr_n <= 0;
  this.vif.tx.dcd_n <= 0;
  this.vif.tx.baud_clk <= 0;
endtask

task uart_tx_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask

`endif // end of __uart_tx_DRIVER_SV__

