
`timescale 1ns/10ps

//`include "ahb_typedefs.svh"

module ahb_master #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (

    clk,
    resetn,
    // to arbiter
    hbusreq,
    hmastlock,
    hgrant,
    // to ahb slave
    haddr,
    htrans,
    hwrite,
    hsize,
    hburst,
    hprot,
    hwdata,
    hrdata,
    hready,
    hresp
  );

  input clk;
  input resetn;

  output [ADDR_WIDTH-1:0]  haddr;
  output [1:0]             htrans;
  output [0:0]             hwrite;
  output [2:0]             hsize;
  output [2:0]             hburst;
  output [3:0]             hprot;
  output [DATA_WIDTH-1:0]  hwdata;
  output [0:0]             hmastlock;

  input [DATA_WIDTH-1:0]  hrdata;
  input [0:0]             hready;
  input [1:0]             hresp;

  output [0:0]            hbusreq;
  input [0:0]             hgrant;

  reg [ADDR_WIDTH-1:0]    haddr;
  reg [DATA_WIDTH-1:0]    hwdata;

  // implement your func here ...
  assign hbusreq = 1'b1;

  always@(posedge clk) begin
    haddr <= 'hdeaddead;
  end

  always@(posedge clk) begin
    hwdata <= 'hdeaddead;
  end

endmodule
