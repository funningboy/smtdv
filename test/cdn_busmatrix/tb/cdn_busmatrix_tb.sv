`timescale 1ns/10ps

`include "ahb_defines.svh"
`include "ahb_if_harness.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import ahb_pkg::*;

  `include "./test/cdn_busmatrix_test_list.sv"

  reg clk;
  reg resetn;

  initial begin
    clk = 0;
    forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if cdnbus_rst_if(resetn);
  defparam apb_rst_if.if_name       = "cdnbus_rst_if";
  defparam apb_rst_if.PWRST_PERIOD  = 100;
  defparam apb_rst_if.POLARITY      = 0;

  /* -----------------------------
  * load DUT
  -------------------------------* */

