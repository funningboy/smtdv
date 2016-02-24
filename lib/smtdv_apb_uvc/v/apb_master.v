
`timescale 1ns/10ps

module apb_master #(
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

  output [ADDR_WIDTH-1:0]  paddr;
  output [0:0]             prwd;
  output [DATA_WIDTH-1:0]  pwdata;
  output [15:0]            psel; // master [15:0], slave[0:0]
  output [0:0]             penable;

  input [DATA_WIDTH-1:0]  prdata;
  input [0:0]             pslverr;
  input [0:0]             pready;
  reg [DATA_WIDTH-1:0]    pwdata;


  // implement your func here ...
  assign penable = 1'b1;
  assign psel = 15'b0;

  always@(posedge clk) begin
    pwdata <= 'hdeaddead;
  end
endmodule
