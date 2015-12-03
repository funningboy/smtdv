`ifndef __XBUS_IF_HARNESS_SV__
`define __XBUS_IF_HARNESS_SV__

// MTI set
// ref xbus master.v port type
// map table
// type : interface type
// reg out: ref logic
// input: inout logic
// assign out(wire): inout logic
//

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "xbus_if.sv"
`include "smtdv_macros.svh"

interface xbus_master_if_harness #(
  parameter integer UID = 0,
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [0:0]   req,
    logic [0:0]    rw,
    logic [ADDR_WIDTH-1:0]  addr,
    logic [0:0]   ack,
    logic [(DATA_WIDTH>>3)-1:0] byten,
    logic [DATA_WIDTH-1:0] rdata,
    logic [DATA_WIDTH-1:0] wdata
  );

    xbus_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn),

      .req(),
      .rw(),
      .addr(),
      .ack(),
      .byten(),
      .rdata(),
      .wdata()
    );

      `ifndef XBUSMASTERATTR
        $fatal("please define XBUSMASTERATTR as forced.vif at top design");
      `endif
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.req, `XBUSMASTERATTR(UID).req)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.rw, `XBUSMASTERATTR(UID).rw)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.addr, `XBUSMASTERATTR(UID).addr)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.byten, `XBUSMASTERATTR(UID).byten)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.wdata, `XBUSMASTERATTR(UID).wdata)
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSMASTERATTR(UID).ack, vif.ack)
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSMASTERATTR(UID).rdata, vif.rdata)

endinterface


interface xbus_slave_if_harness #(
  parameter integer UID = 0,
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [0:0]   req,
    logic [0:0]    rw,
    logic [ADDR_WIDTH-1:0]  addr,
    logic [0:0]   ack,
    logic [(DATA_WIDTH>>3)-1:0] byten,
    logic [DATA_WIDTH-1:0] rdata,
    logic [DATA_WIDTH-1:0] wdata
  );

    xbus_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) vif
    (
      .clk(clk),
      .resetn(resetn),

      .req(),
      .rw(),
      .addr(),
      .ack(),
      .byten(),
      .rdata(),
      .wdata()
    );

    // ex: force initial seq or memory init or as switch to swap DUT or UVC to drive
      `ifndef XBUSSLAVEATTR
        $error("please define XBUSSLAVEATTR as forced vif at top design");
      `endif
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSSLAVEATTR(UID).req, vif.req)
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSSLAVEATTR(UID).rw, vif.rw)
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSSLAVEATTR(UID).addr, vif.addr)
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSSLAVEATTR(UID).byten, vif.byten)
      `SMTDV_PORT2VIF(vif.has_force, clk, `XBUSSLAVEATTR(UID).wdata, vif.wdata)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.ack, `XBUSSLAVEATTR(UID).ack)
      `SMTDV_VIF2PORT(vif.has_force, clk, vif.rdata, `XBUSSLAVEATTR(UID).rdata)

endinterface

`endif // end of  __XBUS_IF_HARNESS_SV__
