
`timescale 1ns/10ps

`include "xbus_master.v"
`include "xbus_slave.v"

module dut_1m1s #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer BYTEN_WIDTH = 4,
  parameter integer DATA_WIDTH = 32
  ) (
    clk,
    resetn
);

  input [0:0]   clk;
  input [0:0]   resetn;

  wire [0:0]    w_req;
  wire [0:0]    w_rw;
  wire [ADDR_WIDTH-1:0]  w_addr;
  wire  [0:0]   w_ack;
  wire [BYTEN_WIDTH-1:0] w_byten;
  wire  [DATA_WIDTH-1:0] w_rdata;
  wire [DATA_WIDTH-1:0] w_wdata;

  genvar i;
  generate
  for (i=0; i < 1; i++) begin: M
    // instances: top.u_dut_1m1s.M[0].u_xbus_master,
    xbus_master #(
      .ADDR_WIDTH   (ADDR_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) u_xbus_master (
      .clk(clk),
      .resetn(resetn),

      .req(w_req),
      .rw(w_rw),
      .addr(w_addr),
      .ack(w_ack),
      .byten(w_byten),
      .rdata(w_rdata),
      .wdata(w_wdata)
    );
  end
  endgenerate

  generate
  for (i=0; i < 1; i++) begin: S
    // instances: top.u_dut_1m1s.S[0].u_xbus_slave,
    xbus_slave #(
      .ADDR_WIDTH   (ADDR_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) u_xbus_slave (
      .clk(clk),
      .resetn(resetn),

      .req(w_req),
      .rw(w_rw),
      .addr(w_addr),
      .ack(w_ack),
      .byten(w_byten),
      .rdata(w_rdata),
      .wdata(w_wdata)
    );
  end
  endgenerate

endmodule
