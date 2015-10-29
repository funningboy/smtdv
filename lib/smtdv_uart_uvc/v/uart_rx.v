`timescale 1ns/10ps

module uart_rx (
  clk,
  resetn,

  txd,    // Transmit Data
  rxd,    // Receive Data

  intrpt,  // Interrupt

  ri_n,    // ring indicator
  cts_n,   // clear to send
  dsr_n,   // data set ready
  rts_n,   // request to send
  dtr_n,   // data terminal ready
  dcd_n,   // data carrier detect

  baud_clk  // TODO: Baud Rate Clock not used ??
  );

    input clk;
    input resetn;

    input txd;
    input rts_n;
    input dtr_n;
    input dcd_n;
    output baud_clk;

    output  rxd;
    output  cts_n;
    output  dsr_n;
    output  ri_n;

    output intrpt;

endmodule
