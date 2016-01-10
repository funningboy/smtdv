`ifndef __CDN_BUSMATRIX_IF_HARNESS_SV__
`define __CDN_BUSMATRIX_IF_HARNESS_SV__


`timescale 1ns/10ps

`include "bm_defs.v"

import uvm_pkg::*;
`include "uvm_macros.svh"

import smtdv_common_pkg::*;
`include "smtdv_macros.svh"

`include "ahb_if.sv"

interface cdn_busmatrix_if_harness #(
  ) (
    `ifdef SLAVE0 `CDNBUS_SLAVE_PORT(0) `endif
    `ifdef SLAVE1 `CDNBUS_SLAVE_PORT(1) `endif
    `ifdef SLAVE2 `CDNBUS_SLAVE_PORT(2) `endif
    `ifdef SLAVE3 `CDNBUS_SLAVE_PORT(3) `endif
    `ifdef SLAVE4 `CDNBUS_SLAVE_PORT(4) `endif
    `ifdef SLAVE5 `CDNBUS_SLAVE_PORT(5) `endif
    `ifdef SLAVE6 `CDNBUS_SLAVE_PORT(6) `endif
    `ifdef SLAVE7 `CDNBUS_SLAVE_PORT(7) `endif
    `ifdef SLAVE8 `CDNBUS_SLAVE_PORT(8) `endif
    `ifdef SLAVE9 `CDNBUS_SLAVE_PORT(9) `endif
    `ifdef SLAVE10 `CDNBUS_SLAVE_PORT(10) `endif
    `ifdef SLAVE11 `CDNBUS_SLAVE_PORT(11) `endif
    `ifdef SLAVE12 `CDNBUS_SLAVE_PORT(12) `endif
    `ifdef SLAVE13 `CDNBUS_SLAVE_PORT(13) `endif
    `ifdef SLAVE14 `CDNBUS_SLAVE_PORT(14) `endif
    `ifdef SLAVE15 `CDNBUS_SLAVE_PORT(15) `endif

    `ifdef MASTER0 `CDNBUS_MASTER_PORT(0) `endif
    `ifdef MASTER1 `CDNBUS_MASTER_PORT(1) `endif
    `ifdef MASTER2 `CDNBUS_MASTER_PORT(2) `endif
    `ifdef MASTER3 `CDNBUS_MASTER_PORT(3) `endif
    `ifdef MASTER4 `CDNBUS_MASTER_PORT(4) `endif
    `ifdef MASTER5 `CDNBUS_MASTER_PORT(5) `endif
    `ifdef MASTER6 `CDNBUS_MASTER_PORT(6) `endif
    `ifdef MASTER7 `CDNBUS_MASTER_PORT(7) `endif
    `ifdef MASTER8 `CDNBUS_MASTER_PORT(8) `endif
    `ifdef MASTER9 `CDNBUS_MASTER_PORT(9) `endif
    `ifdef MASTER10 `CDNBUS_MASTER_PORT(10) `endif
    `ifdef MASTER11 `CDNBUS_MASTER_PORT(11) `endif
    `ifdef MASTER12 `CDNBUS_MASTER_PORT(12) `endif
    `ifdef MASTER13 `CDNBUS_MASTER_PORT(13) `endif
    `ifdef MASTER14 `CDNBUS_MASTER_PORT(14) `endif
    `ifdef MASTER15 `CDNBUS_MASTER_PORT(15) `endif

    input clk,
    input resetn
  );

    parameter integer ADDR_WIDTH = `AHB_ADDR_WIDTH;
    parameter integer DATA_WIDTH = `AHB_DATA_WIDTH;

    bit has_master_force[`NUM_OF_MASTERS];
    bit has_slave_force[`NUM_OF_SLAVES];

    wire 	        tie_hi_1bit;
    wire [3:0]    tie_lo_4bit;
    assign tie_hi_1bit = 1'b1;
    assign tie_lo_4bit = 4'b0;

    initial begin
      foreach(has_slave_force[i])
        has_slave_force[i] = 1'b1;
    end

    initial begin
      foreach(has_master_force[i])
        has_master_force[i] = 1'b1;
    end

    genvar i;
    generate
    for(i=0; i < `NUM_OF_MASTERS; i++) begin : M
      // Master intf
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
        .hresp(),

        .hreadyout()
      );
    end
    endgenerate

    // CDNBUS master port to slave uvc
    `ifndef CDNBUSMATRIX
        $fatal("please define CDNBUSMATRIX as forced.vif at top design\n");
    `endif

    `ifdef MASTER0 `CDNBUS_MASTER_VIF(0) `endif
    `ifdef MASTER1 `CDNBUS_MASTER_VIF(1) `endif
    `ifdef MASTER2 `CDNBUS_MASTER_VIF(2) `endif
    `ifdef MASTER3 `CDNBUS_MASTER_VIF(3) `endif
    `ifdef MASTER4 `CDNBUS_MASTER_VIF(4) `endif
    `ifdef MASTER5 `CDNBUS_MASTER_VIF(5) `endif
    `ifdef MASTER6 `CDNBUS_MASTER_VIF(6) `endif
    `ifdef MASTER7 `CDNBUS_MASTER_VIF(7) `endif
    `ifdef MASTER8 `CDNBUS_MASTER_VIF(8) `endif
    `ifdef MASTER9 `CDNBUS_MASTER_VIF(9) `endif
    `ifdef MASTER10 `CDNBUS_MASTER_VIF(10) `endif
    `ifdef MASTER11 `CDNBUS_MASTER_VIF(11) `endif
    `ifdef MASTER12 `CDNBUS_MASTER_VIF(12) `endif
    `ifdef MASTER13 `CDNBUS_MASTER_VIF(13) `endif
    `ifdef MASTER14 `CDNBUS_MASTER_VIF(14) `endif
    `ifdef MASTER15 `CDNBUS_MASTER_VIF(15) `endif

    generate
    for(i=0; i < `NUM_OF_SLAVES; i++) begin : S
      // Slave intf
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
        .hresp(),

        .hreadyout()
      );
    end
    endgenerate

    // master uvc to CDNBUS slave port
    `ifndef CDNBUSMATRIX
        $fatal("please define CDNBUSMATRIX as forced.vif at top design");
    `endif

    `ifdef SLAVE0 `CDNBUS_SLAVE_VIF(0) `endif
    `ifdef SLAVE1 `CDNBUS_SLAVE_VIF(1) `endif
    `ifdef SLAVE2 `CDNBUS_SLAVE_VIF(2) `endif
    `ifdef SLAVE3 `CDNBUS_SLAVE_VIF(3) `endif
    `ifdef SLAVE4 `CDNBUS_SLAVE_VIF(4) `endif
    `ifdef SLAVE5 `CDNBUS_SLAVE_VIF(5) `endif
    `ifdef SLAVE6 `CDNBUS_SLAVE_VIF(6) `endif
    `ifdef SLAVE7 `CDNBUS_SLAVE_VIF(7) `endif
    `ifdef SLAVE8 `CDNBUS_SLAVE_VIF(8) `endif
    `ifdef SLAVE9 `CDNBUS_SLAVE_VIF(9) `endif
    `ifdef SLAVE10 `CDNBUS_SLAVE_VIF(10) `endif
    `ifdef SLAVE11 `CDNBUS_SLAVE_VIF(11) `endif
    `ifdef SLAVE12 `CDNBUS_SLAVE_VIF(12) `endif
    `ifdef SLAVE13 `CDNBUS_SLAVE_VIF(13) `endif
    `ifdef SLAVE14 `CDNBUS_SLAVE_VIF(14) `endif
    `ifdef SLAVE15 `CDNBUS_SLAVE_VIF(15) `endif

endinterface

`endif // __CDN_BUSMATRIX_IF_HARNESS_SV__
