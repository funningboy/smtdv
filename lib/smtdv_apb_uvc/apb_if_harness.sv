`ifndef __APB_IF_HARNESS_SV__
`define __APB_IF_HARNESS_SV__

// ref apb master.v port type
// map table
// type : interface type
// reg out: ref logic
// input: inout logic
// assign out(wire): inout logic
//
`include "apb_if.sv"

`define APBVIF2PORT(port)\
  always @(vif.port) begin \
    if (has_force) \
      force port = vif.port; \
    else release port; \
  end

`define APBPORT2VIF(port)\
  always @(port) begin \
    if (has_force) \
      vif.port = port; \
  end

interface apb_master_if_harness #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [ADDR_WIDTH-1:0]  paddr,
    logic [0:0]             prwd,
    logic [DATA_WIDTH-1:0]  pwdata,
    logic [15:0]            psel,
    logic [0:0]             penable,

    logic [DATA_WIDTH-1:0]  prdata,
    logic [0:0]             pslverr,
    logic [0:0]             pready
  );

    bit has_force = 1;

    apb_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn)
    );

    `APBVIF2PORT(paddr)
    `APBVIF2PORT(prwd)
    `APBVIF2PORT(pwdata)
    `APBVIF2PORT(psel)
    `APBVIF2PORT(penable)

    `APBPORT2VIF(prdata)
    `APBPORT2VIF(pslverr)
    `APBPORT2VIF(pready)

endinterface


interface apb_slave_if_harness #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [ADDR_WIDTH-1:0]  paddr,
    logic [0:0]             prwd,
    logic [DATA_WIDTH-1:0]  pwdata,
    logic [15:0]             psel,
    logic [0:0]             penable,

    logic [DATA_WIDTH-1:0]  prdata,
    logic [0:0]             pslverr,
    logic [0:0]             pready
  );

    bit has_force = 1;

    apb_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn)
    );

    `APBPORT2VIF(paddr)
    `APBPORT2VIF(prwd)
    `APBPORT2VIF(pwdata)
    `APBPORT2VIF(psel)
    `APBPORT2VIF(penable)

    `APBVIF2PORT(prdata)
    `APBVIF2PORT(pslverr)
    `APBVIF2PORT(pready)

endinterface

`endif // end of  __APB_IF_HARNESS_SV__
