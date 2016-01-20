
`timescale 1ns/10ps

module uart_tx (
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

    output txd;
    output rts_n;
    output dtr_n;
    output dcd_n;
    output baud_clk;

    input  rxd;
    input  cts_n;
    input  dsr_n;
    input  ri_n;

    output intrpt;
endmodule
