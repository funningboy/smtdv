
`timescale 1ns/10ps

//`include "ahb_typedefs.svh"

module ahb_slave #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (

    clk,
    resetn,
    // DECODER
    hsel,

    haddr,
    htrans,
    hwrite,
    hsize,
    hburst,
    hprot,
    hwdata,
    hmastlock,
    hready,

    hrdata,
    hreadyout,
    hresp
  );
  input [0:0]             clk;
  input [0:0]             resetn;

  input [ADDR_WIDTH-1:0]  haddr;
  input [1:0]             htrans;
  input [0:0]             hwrite;
  input [2:0]             hsize;
  input [2:0]             hburst;
  input [3:0]             hprot;
  input [DATA_WIDTH-1:0]  hwdata;
  input [0:0]             hmastlock;
  input [0:0]             hready;
  input [0:0]             hsel; // master [15:0], slave[0:0]

  output [DATA_WIDTH-1:0]  hrdata;
  output [0:0]             hreadyout;
  output [1:0]             hresp;
  reg [DATA_WIDTH-1:0]     hrdata;

  // implement your func here ...
  assign hresp = 'h0;
  assign hreadyout = 1'b1;

  always@(posedge clk) begin
    hrdata <= 'hdeadead;
  end
  endmodule

