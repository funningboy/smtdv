`ifndef __UART_RX_DRIVER_SV__
`define __UART_RX_DRIVER_SV__

class uart_rx_driver #(
  ) extends
    smtdv_driver#(
      `UART_VIF,
      `UART_RX_CFG,
      `UART_ITEM
    );

  mailbox #(`UART_ITEM) mbox;

  bit sample_clk;
  bit [15:0] ua_brgr;
  bit [7:0] ua_bdiv;
  int num_of_bits_sent;
  int num_items_sent = 0;

  `UART_RX_DRIVE_ITEMS th0;
  `UART_RX_SAMPLE_RATE th1;

  `uvm_component_param_utils_begin(`UART_RX_DRIVER)
    `uvm_field_int(ua_brgr, UVM_DEFAULT + UVM_NOPRINT)
    `uvm_field_int(ua_bdiv, UVM_DEFAULT + UVM_NOPRINT)
  `uvm_component_utils_end

  function new(string name = "uart_rx_driver", uvm_component parent);
    super.new(name, parent);
    mbox = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `UART_RX_DRIVE_ITEMS::type_id::create("uart_rx_drive_items"); th0.cmp = this; this.th_handler.add(th0);
    th1 = `UART_RX_SAMPLE_RATE::type_id::create("uart_rx_sample_rate"); th1.cmp = this; this.th_handler.add(th1);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task uart_rx_driver::reset_driver();
  reset_inf();
  mbox = new();
endtask

task uart_rx_driver::reset_inf();
   vif.rx.rxd <= 1;        //Receive Data
   vif.rx.cts_n <= 0;      //Clear to Send
   vif.rx.dsr_n <= 0;      //Data Set Ready
   vif.rx.ri_n <= 0;       //Ring Indicator
endtask

task uart_rx_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: \n%s", req.sprint()))
  endcase
endtask

`endif // end of __UART_RX_DRIVER_SV__

