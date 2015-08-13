`ifndef __XBUS_IF_HARNESS_SV__
`define __XBUS_IF_HARNESS_SV__

// ref xbus master.v port type
// map table
// type : interface type
// reg out: ref logic
// input: inout logic
// assign out(wire): inout logic
//
`include "xbus_if.sv"

`define VIF2PORT(port)\
  always @(vif.port) begin \
    if (has_force) \
      force port = vif.port; \
    else release port; \
  end

`define PORT2VIF(port)\
  always @(port) begin \
    if (has_force) \
      vif.port = port; \
  end

interface xbus_master_if_harness #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer BYTEN_WIDTH = 4,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [0:0]   req,
    logic [0:0]    rw,
    logic [ADDR_WIDTH-1:0]  addr,
    logic [0:0]   ack,
    logic [BYTEN_WIDTH-1:0] byten,
    logic [DATA_WIDTH-1:0] rdata,
    // irun doesn't work for ref logic
    //ref logic [DATA_WIDTH-1:0] rdata,
    logic [DATA_WIDTH-1:0] wdata
  );

    bit has_force = 1;

    xbus_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .BYTEN_WIDTH(BYTEN_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn)
    );

    `VIF2PORT(req)
    `VIF2PORT(rw)
    `VIF2PORT(addr)
    `VIF2PORT(byten)
    `VIF2PORT(wdata)
    `PORT2VIF(ack)
    `PORT2VIF(rdata)

endinterface


interface xbus_slave_if_harness #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer BYTEN_WIDTH = 4,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [0:0]   req,
    logic [0:0]    rw,
    logic [ADDR_WIDTH-1:0]  addr,
    logic [0:0]   ack,
    logic [BYTEN_WIDTH-1:0] byten,
    logic [DATA_WIDTH-1:0] rdata,
    // irun doesn't work for ref logic
    //ref logic [DATA_WIDTH-1:0] rdata,
    logic [DATA_WIDTH-1:0] wdata
  );

    bit has_force = 1;

    xbus_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .BYTEN_WIDTH(BYTEN_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn)
    );

    `PORT2VIF(req)
    `PORT2VIF(rw)
    `PORT2VIF(addr)
    `PORT2VIF(byten)
    `PORT2VIF(wdata)
    `VIF2PORT(ack)
    `VIF2PORT(rdata)

endinterface

`endif // end of  __XBUS_IF_HARNESS_SV__
