`timescale 1ns/10ps

`include "bm_defs.v"
`include "test/cdn_busmatrix_defines.svh"
`include "test/cdn_busmatrix_if_harness.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import cdn_busmatrix_pkg::*;
  `include "cdn_typedefs.svh"

  `include "./test/cdn_busmatrix_test_list.sv"

  parameter ADDR_WIDTH = `AHB_ADDR_WIDTH;
  parameter DATA_WIDTH = `AHB_DATA_WIDTH;

  reg clk;
  reg resetn;

  initial begin
    clk = 0;
    forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if cdn_rst_if(resetn);
  defparam cdn_rst_if.if_name       = "cdn_rst_if";
  defparam cdn_rst_if.PWRST_PERIOD  = 100;
  defparam cdn_rst_if.POLARITY      = 0;

  // opt to sub_system/ chip level
  tb_top u_tb_top();
  assign `CDNBUSMATRIX.HCLK = clk;
  assign `CDNBUSMATRIX.HRESETn = resetn;

  bind `CDNBUSMATRIX cdn_busmatrix_if_harness #(
  ) cdn_busmatrix_if_harness (
    `ifdef SLAVE0 `CDNBUS_SLAVE_CONNT(0) `endif
    `ifdef SLAVE1 `CDNBUS_SLAVE_CONNT(1) `endif
    `ifdef SLAVE2 `CDNBUS_SLAVE_CONNT(2) `endif
    `ifdef SLAVE3 `CDNBUS_SLAVE_CONNT(3) `endif
    `ifdef SLAVE4 `CDNBUS_SLAVE_CONNT(4) `endif
    `ifdef SLAVE5 `CDNBUS_SLAVE_CONNT(5) `endif
    `ifdef SLAVE6 `CDNBUS_SLAVE_CONNT(6) `endif
    `ifdef SLAVE7 `CDNBUS_SLAVE_CONNT(7) `endif
    `ifdef SLAVE8 `CDNBUS_SLAVE_CONNT(8) `endif
    `ifdef SLAVE9 `CDNBUS_SLAVE_CONNT(9) `endif
    `ifdef SLAVE10 `CDNBUS_SLAVE_CONNT(10) `endif
    `ifdef SLAVE11 `CDNBUS_SLAVE_CONNT(11) `endif
    `ifdef SLAVE12 `CDNBUS_SLAVE_CONNT(12) `endif
    `ifdef SLAVE13 `CDNBUS_SLAVE_CONNT(13) `endif
    `ifdef SLAVE14 `CDNBUS_SLAVE_CONNT(14) `endif
    `ifdef SLAVE15 `CDNBUS_SLAVE_CONNT(15) `endif

    `ifdef MASTER0 `CDNBUS_MASTER_CONNT(0) `endif
    `ifdef MASTER1 `CDNBUS_MASTER_CONNT(1) `endif
    `ifdef MASTER2 `CDNBUS_MASTER_CONNT(2) `endif
    `ifdef MASTER3 `CDNBUS_MASTER_CONNT(3) `endif
    `ifdef MASTER4 `CDNBUS_MASTER_CONNT(4) `endif
    `ifdef MASTER5 `CDNBUS_MASTER_CONNT(5) `endif
    `ifdef MASTER6 `CDNBUS_MASTER_CONNT(6) `endif
    `ifdef MASTER7 `CDNBUS_MASTER_CONNT(7) `endif
    `ifdef MASTER8 `CDNBUS_MASTER_CONNT(8) `endif
    `ifdef MASTER9 `CDNBUS_MASTER_CONNT(9) `endif
    `ifdef MASTER10 `CDNBUS_MASTER_CONNT(10) `endif
    `ifdef MASTER11 `CDNBUS_MASTER_CONNT(11) `endif
    `ifdef MASTER12 `CDNBUS_MASTER_CONNT(12) `endif
    `ifdef MASTER13 `CDNBUS_MASTER_CONNT(13) `endif
    `ifdef MASTER14 `CDNBUS_MASTER_CONNT(14) `endif
    `ifdef MASTER15 `CDNBUS_MASTER_CONNT(15) `endif

    .clk(`CDNBUSMATRIX.HCLK),               // AHB System Clock
    .resetn(`CDNBUSMATRIX.HRESETn)         // AHB System Reset
  );

  initial begin
    `ifdef SLAVE0 `CDNBUS_SLAVE_ASSIGN_VIF(0) `endif
    `ifdef SLAVE1 `CDNBUS_SLAVE_ASSIGN_VIF(1) `endif
    `ifdef SLAVE2 `CDNBUS_SLAVE_ASSIGN_VIF(2) `endif
    `ifdef SLAVE3 `CDNBUS_SLAVE_ASSIGN_VIF(3) `endif
    `ifdef SLAVE4 `CDNBUS_SLAVE_ASSIGN_VIF(4) `endif
    `ifdef SLAVE5 `CDNBUS_SLAVE_ASSIGN_VIF(5) `endif
    `ifdef SLAVE6 `CDNBUS_SLAVE_ASSIGN_VIF(6) `endif
    `ifdef SLAVE7 `CDNBUS_SLAVE_ASSIGN_VIF(7) `endif
    `ifdef SLAVE8 `CDNBUS_SLAVE_ASSIGN_VIF(8) `endif
    `ifdef SLAVE9 `CDNBUS_SLAVE_ASSIGN_VIF(9) `endif
    `ifdef SLAVE10 `CDNBUS_SLAVE_ASSIGN_VIF(10) `endif
    `ifdef SLAVE11 `CDNBUS_SLAVE_ASSIGN_VIF(11) `endif
    `ifdef SLAVE12 `CDNBUS_SLAVE_ASSIGN_VIF(12) `endif
    `ifdef SLAVE13 `CDNBUS_SLAVE_ASSIGN_VIF(13) `endif
    `ifdef SLAVE14 `CDNBUS_SLAVE_ASSIGN_VIF(14) `endif
    `ifdef SLAVE15 `CDNBUS_SLAVE_ASSIGN_VIF(15) `endif

    `ifdef MASTER0 `CDNBUS_MASTER_ASSIGN_VIF(0) `endif
    `ifdef MASTER1 `CDNBUS_MASTER_ASSIGN_VIF(1) `endif
    `ifdef MASTER2 `CDNBUS_MASTER_ASSIGN_VIF(2) `endif
    `ifdef MASTER3 `CDNBUS_MASTER_ASSIGN_VIF(3) `endif
    `ifdef MASTER4 `CDNBUS_MASTER_ASSIGN_VIF(4) `endif
    `ifdef MASTER5 `CDNBUS_MASTER_ASSIGN_VIF(5) `endif
    `ifdef MASTER6 `CDNBUS_MASTER_ASSIGN_VIF(6) `endif
    `ifdef MASTER7 `CDNBUS_MASTER_ASSIGN_VIF(7) `endif
    `ifdef MASTER8 `CDNBUS_MASTER_ASSIGN_VIF(8) `endif
    `ifdef MASTER9 `CDNBUS_MASTER_ASSIGN_VIF(9) `endif
    `ifdef MASTER10 `CDNBUS_MASTER_ASSIGN_VIF(10) `endif
    `ifdef MASTER11 `CDNBUS_MASTER_ASSIGN_VIF(11) `endif
    `ifdef MASTER12 `CDNBUS_MASTER_ASSIGN_VIF(12) `endif
    `ifdef MASTER13 `CDNBUS_MASTER_ASSIGN_VIF(13) `endif
    `ifdef MASTER14 `CDNBUS_MASTER_ASSIGN_VIF(14) `endif
    `ifdef MASTER15 `CDNBUS_MASTER_ASSIGN_VIF(15) `endif

    uvm_config_db#(`CDN_RST_VIF)::set(uvm_root::get(), "*", "cdn_rst_vif", cdn_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_cdn_busmatrix.vcd");
    $dumpvars(0, top);
  end

endmodule
