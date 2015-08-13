
//`ifndef __XBUS_SLAVE_V__
//`define __XBUS_SLAVE_V__

`timescale 1ns/10ps

module xbus_slave #(
  parameter ADDR_WIDTH  = 14,
  parameter BYTEN_WIDTH = 4,
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
  input [0:0]   req;
  input [0:0]    rw;
  input [ADDR_WIDTH-1:0]  addr;
  output [0:0]   ack;
  input [BYTEN_WIDTH-1:0] byten;
  output [DATA_WIDTH-1:0] rdata;
  input [DATA_WIDTH-1:0] wdata;

  reg [DATA_WIDTH-1:0] rdata;

  // implement your func here...

endmodule

//`endif // end of __XBUS_SLAVE_V__
