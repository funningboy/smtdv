
`include "uart_tx.v"
`include "uart_rx.v"

module dut_1m1s(
  input clk,
  input resetn
);

  wire w_txd;
  wire w_rts_n;
  wire w_dtr_n;
  wire w_dcd_n;
  wire w_baud_clk;

  wire w_rxd;
  wire w_cts_n;
  wire w_dsr_n;
  wire w_ri_n;

  wire w_intrpt;

  genvar i;
  generate
  for (i=0; i < 1; i++) begin: M
    uart_tx u_uart_tx (
        .clk(clk),
        .resetn(resetn),
        .txd(w_txd),    // Transmit Data
        .rxd(w_rxd),    // Receive Data
        .intrpt(),  // Interrupt
        .ri_n(w_ri_n),    // ring indicator
        .cts_n(w_cts_n),   // clear to send
        .dsr_n(w_dsr_n),   // data set ready
        .rts_n(w_rts_n),   // request to send
        .dtr_n(w_dtr_n),   // data terminal ready
        .dcd_n(w_dcd_n),   // data carrier detect
        .baud_clk(w_baud_clk)  // TODO: Baud Rate Clock not used ??
    );
  end
  endgenerate

  generate
  for (i=0; i < 1; i++) begin: S
    uart_tx u_uart_rx (
        .clk(clk),
        .resetn(resetn),
        .txd(w_txd),    // Transmit Data
        .rxd(w_rxd),    // Receive Data
        .intrpt(),  // Interrupt
        .ri_n(w_ri_n),    // ring indicator
        .cts_n(w_cts_n),   // clear to send
        .dsr_n(w_dsr_n),   // data set ready
        .rts_n(w_rts_n),   // request to send
        .dtr_n(w_dtr_n),   // data terminal ready
        .dcd_n(w_dcd_n),   // data carrier detect
        .baud_clk(w_baud_clk)  // TODO: Baud Rate Clock not used ??
    );
  end
  endgenerate

endmodule


