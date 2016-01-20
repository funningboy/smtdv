//`ifndef __XBUS_master_V__
//`define __XBUS_master_V__

`timescale 1ns/10ps

module xbus_master #(
  parameter ADDR_WIDTH  = 14,
  parameter DATA_WIDTH = 32
  ) (
    clk,
    resetn,
    req,
    rw,
    addr,
    ack,
    byten,
    rdata,
    wdata
);
  input [0:0]   clk;
  input [0:0]   resetn;
  output [0:0]   req;
  output [0:0]    rw;
  output [ADDR_WIDTH-1:0]  addr;
  input [0:0]   ack;
  output [(DATA_WIDTH>>3)-1:0] byten;
  input [DATA_WIDTH-1:0] rdata;
  output [DATA_WIDTH-1:0] wdata;
  reg [ADDR_WIDTH-1:0] addr;
  reg [DATA_WIDTH-1:0] wdata;

  // implement your func here...
  always@(posedge clk) begin
    addr <= 'hdeaddead;
  end
  always@(posedge clk) begin
    wdata <= 'hdeaddead;
  end
endmodule

//`endif // end of __XBUS_master_V__
