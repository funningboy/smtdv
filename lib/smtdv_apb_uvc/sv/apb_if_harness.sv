`ifndef __APB_IF_HARNESS_SV__
`define __APB_IF_HARNESS_SV__

// ref apb master.v port type
// map table
// type : interface type
// reg out: ref logic
// input: inout logic
// assign out(wire): inout logic
//

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "apb_if.sv"
`include "smtdv_macros.svh"

interface apb_master_if_harness#(
  parameter integer UID = 0,
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
    logic [0:0]             pready,

    logic [0:0]             pirq
  );

    apb_if#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn),

      .paddr(),
      .prwd(),
      .pwdata(),
      .psel(),
      .penable(),

      .prdata(),
      .pslverr(),
      .pready()

    );

    `ifndef APBMASTERATTR
        $fatal("please define APBMASTERATTR as forced.vif at top design");
    `endif
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.paddr, `APBMASTERATTR(UID).paddr)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.prwd, `APBMASTERATTR(UID).prwd)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.pwdata, `APBMASTERATTR(UID).pwdata)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.psel, `APBMASTERATTR(UID).psel)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.penable, `APBMASTERATTR(UID).penable)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBMASTERATTR(UID).prdata, vif.prdata)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBMASTERATTR(UID).pslverr, vif.pslverr)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBMASTERATTR(UID).pready, vif.pready)

endinterface


interface apb_slave_if_harness#(
  parameter integer UID = 0,
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

    apb_if#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn),

      .paddr(),
      .prwd(),
      .pwdata(),
      .psel(),
      .penable(),

      .prdata(),
      .pslverr(),
      .pready()

    );

    `ifndef APBSLAVEATTR
        $fatal("please define APBSLAVEATTR as forced.vif at top design");
    `endif
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBSLAVEATTR(UID).paddr, vif.paddr)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBSLAVEATTR(UID).prwd, vif.prwd)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBSLAVEATTR(UID).pwdata, vif.pwdata)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBSLAVEATTR(UID).psel, vif.psel)
      `SMTDV_PORT2VIF(vif.has_force, clk, `APBSLAVEATTR(UID).penable, vif.penable)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.prdata, `APBSLAVEATTR(UID).prdata)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.pslverr, `APBSLAVEATTR(UID).pslverr)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.pready, `APBSLAVEATTR(UID).pready)

endinterface

`endif // end of  __APB_IF_HARNESS_SV__
