`timescale 1ns/10ps

module apb_slave #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    clk,
    resetn,

    paddr,
    prwd,
    pwdata,
    psel, // master [15:0], slave[0:0]
    penable,

    prdata,
    pslverr,
    pready
  );

  input [0:0]             clk;
  input [0:0]             resetn;

  input [ADDR_WIDTH-1:0]  paddr;
  input [0:0]             prwd;
  input [DATA_WIDTH-1:0]  pwdata;
  input [0:0]            psel; // master [15:0], slave[0:0]
  input [0:0]             penable;

  output [DATA_WIDTH-1:0]  prdata;
  output [0:0]             pslverr;
  output [0:0]             pready;

  // implement your func here ...

endmodule
