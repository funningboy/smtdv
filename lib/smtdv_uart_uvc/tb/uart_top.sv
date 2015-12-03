
`timescale 1ns/10ps

`include "uart_defines.svh"
`include "uart_if_harness.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import uart_pkg::*;
  `include "uart_typedefs.svh"

  `include "./test/uart_test_list.sv"

  reg clk;
  reg resetn;

  initial begin
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if uart_rst_if(resetn);
  defparam uart_rst_if.if_name       = "uart_rst_if";
  defparam uart_rst_if.PWRST_PERIOD  = 100;
  defparam uart_rst_if.POLARITY      = 0;

/*-------------------------------------------
*  used as Master UVC/slave is real design
*-------------------------------------------*/
  dut_1m1s #(
  ) u_dut_1m1s (
    .clk(clk),
    .resetn(resetn)
  );

  bind `UARTTXATTR(0) uart_tx_if_harness#(
     .UID(0)
  ) uart_tx_if_harness (
    .clk(`UARTTXATTR(0).clk),
    .resetn(`UARTTXATTR(0).resetn),

    .txd(`UARTTXATTR(0).txd),    // Transmit Data
    .rxd(`UARTTXATTR(0).rxd),    // Receive Data

    .intrpt(`UARTTXATTR(0).intrpt),  // Interrupt

    .ri_n(`UARTTXATTR(0).ri_n),    // ring indicator
    .cts_n(`UARTTXATTR(0).cts_n),   // clear to send
    .dsr_n(`UARTTXATTR(0).dsr_n),   // data set ready
    .rts_n(`UARTTXATTR(0).rts_n),   // request to send
    .dtr_n(`UARTTXATTR(0).dtr_n),   // data terminal ready
    .dcd_n(`UARTTXATTR(0).dcd_n),   // data carrier detect

    .baud_clk(`UARTTXATTR(0).baud_clk)  // TODO: Baud Rate Clock not used ??
  );

  bind `UARTRXATTR(0) uart_rx_if_harness#(
     .UID(0)
  ) uart_rx_if_harness (
    .clk(`UARTRXATTR(0).clk),
    .resetn(`UARTRXATTR(0).resetn),

    .txd(`UARTRXATTR(0).txd),    // Transmit Data
    .rxd(`UARTRXATTR(0).rxd),    // Receive Data

    .intrpt(`UARTRXATTR(0).intrpt),  // Interrupt

    .ri_n(`UARTRXATTR(0).ri_n),    // ring indicator
    .cts_n(`UARTRXATTR(0).cts_n),   // clear to send
    .dsr_n(`UARTRXATTR(0).dsr_n),   // data set ready
    .rts_n(`UARTRXATTR(0).rts_n),   // request to send
    .dtr_n(`UARTRXATTR(0).dtr_n),   // data terminal ready
    .dcd_n(`UARTRXATTR(0).dcd_n),   // data carrier detect

    .baud_clk(`UARTRXATTR(0).baud_clk)  // TODO: Baud Rate Clock not used ??
  );

  initial begin
    uvm_config_db#(`UART_VIF)::set(uvm_root::get(), "*.master_agent[*0]*", "vif", `UARTTXVIF(0)); // bind TX as master
    uvm_config_db#(`UART_VIF)::set(uvm_root::get(), "*.slave_agent[*0]*", "vif", `UARTRXVIF(0));  // bind RX as slave
    uvm_config_db#(`UART_RST_VIF)::set(uvm_root::get(), "*", "uart_rst_vif", uart_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_uart.vcd");
    $dumpvars(0, top);
  end

endmodule
