`ifndef __AHB_IF_HARNESS_SV__
`define __AHB_IF_HARNESS_SV__

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "ahb_if.sv"
`include "smtdv_macros.svh"

interface ahb_master_if_harness #(
  parameter integer UID = 0,
  parameter integer ADDR_WIDTH = 14,
  parameter integer DATA_WIDTH = 32
)(
  input clk, // hclk
  input resetn, // hresetn

  logic [ADDR_WIDTH-1:0]  haddr,
  logic [1:0]             htrans,
  logic [0:0]             hwrite,
  logic [2:0]             hsize,
  logic [2:0]             hburst,
  logic [3:0]             hprot,
  logic [DATA_WIDTH-1:0]  hwdata,
  logic [0:0]             hmastlock,

  logic [0:0]             hbusreq,
  logic [0:0]             hgrant,

  logic [DATA_WIDTH-1:0]  hrdata,
  logic [0:0]             hready,
  logic [1:0]             hresp
  );

  bit has_force = 1;

  ahb_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) vif
  (
    .clk(clk),
    .resetn(resetn),

    .hsel(),

    .haddr(),
    .htrans(),
    .hwrite(),
    .hsize(),
    .hburst(),
    .hprot(),
    .hwdata(),
    .hmastlock(),
    .hbusreq(),
    .hgrant(),
    .hrdata(),
    .hready(),
    .hresp()
  );

    `ifndef AHBMASTERATTR
        $fatal("please define AHBMASTERATTR as forced.vif at top design");
    `endif
    `SMTDV_VIF2PORT(has_force, clk, vif.haddr, `AHBMASTERATTR(UID).haddr)
    `SMTDV_VIF2PORT(has_force, clk, vif.htrans, `AHBMASTERATTR(UID).htrans)
    `SMTDV_VIF2PORT(has_force, clk, vif.hwrite, `AHBMASTERATTR(UID).hwrite)
    `SMTDV_VIF2PORT(has_force, clk, vif.hsize, `AHBMASTERATTR(UID).hsize)
    `SMTDV_VIF2PORT(has_force, clk, vif.hburst, `AHBMASTERATTR(UID).hburst)
    `SMTDV_VIF2PORT(has_force, clk, vif.hprot, `AHBMASTERATTR(UID).hprot)
    `SMTDV_VIF2PORT(has_force, clk, vif.hwdata, `AHBMASTERATTR(UID).hwdata)
    `SMTDV_VIF2PORT(has_force, clk, vif.hmastlock, `AHBMASTERATTR(UID).hmastlock)
    `SMTDV_VIF2PORT(has_force, clk, vif.hburst, `AHBMASTERATTR(UID).hburst)
    `SMTDV_VIF2PORT(has_force, clk, vif.hbusreq, `AHBMASTERATTR(UID).hbusreq)
    `SMTDV_PORT2VIF(has_force, clk, `AHBMASTERATTR(UID).hgrant, vif.hgrant)
    `SMTDV_PORT2VIF(has_force, clk, `AHBMASTERATTR(UID).hrdata, vif.hrdata)
    `SMTDV_PORT2VIF(has_force, clk, `AHBMASTERATTR(UID).hready, vif.hready)
    `SMTDV_PORT2VIF(has_force, clk, `AHBMASTERATTR(UID).hresp, vif.hresp)

endinterface


interface ahb_slave_if_harness #(
  parameter integer UID = 0,
  parameter integer ADDR_WIDTH = 14,
  parameter integer DATA_WIDTH = 32
)(
  input clk, // hclk
  input resetn, // hresetn

  logic [ADDR_WIDTH-1:0]  haddr,
  logic [1:0]             htrans,
  logic [0:0]             hwrite,
  logic [2:0]             hsize,
  logic [2:0]             hburst,
  logic [3:0]             hprot,
  logic [DATA_WIDTH-1:0]  hwdata,
  logic [0:0]             hmastlock,

  logic [15:0]             hsel,

  logic [DATA_WIDTH-1:0]  hrdata,
  logic [0:0]             hready,
  logic [1:0]             hresp
  );

  bit has_force = 1;

  ahb_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) vif
  (
    .clk(clk),
    .resetn(resetn),

    .hbusreq(),
    .hgrant(),

    .haddr(),
    .htrans(),
    .hwrite(),
    .hsize(),
    .hburst(),
    .hprot(),
    .hwdata(),
    .hmastlock(),

    .hsel(),

    .hrdata(),
    .hready(),
    .hresp()
  );

    `ifndef AHBSLAVEATTR
        $fatal("please define AHBSLAVEATTR as forced.vif at top design");
    `endif
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).haddr, vif.haddr)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).htrans, vif.htrans)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hwrite, vif.hwrite)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hsize, vif.hsize)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hburst, vif.hburst)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hprot, vif.hprot)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hwdata, vif.hwdata)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hmastlock, vif.hmastlock)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hburst, vif.hburst)
    `SMTDV_PORT2VIF(has_force, clk, `AHBSLAVEATTR(UID).hsel, vif.hsel)
    `SMTDV_VIF2PORT(has_force, clk, vif.hrdata, `AHBSLAVEATTR(UID).hrdata)
    `SMTDV_VIF2PORT(has_force, clk, vif.hready, `AHBSLAVEATTR(UID).hready)
    `SMTDV_VIF2PORT(has_force, clk, vif.hresp, `AHBSLAVEATTR(UID).hresp)

endinterface

`endif // __AHB_IF_HARNESS_SV__
