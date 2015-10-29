/*-----------------------------------------------------------------
File name     : demo_top.sv
Developers    : Kathleen Meade
Created       : Tue May  4 15:13:46 2010
Description   :
Notes         :
-------------------------------------------------------------------
Copyright 2010 (c) Cadence Design Systems
-----------------------------------------------------------------*/
// migrate to smtdv UVC env
//

`timesclae 1ns/10ps

`include "apb_defines.svh"
`include "apb_if_harness.sv"
`include "dut_dummy.v"

module demo_top();

  parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
  parameter DATA_WIDTH = `APB_DATA_WIDTH;

  // Import the UVM Package
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  // Import the APB OVC Package
  import apb_pkg::*;
  `include "apb_typedefs.svh"

  // Import the test library
  `include "test_lib.sv"

  reg clk;
  reg resetn;

  smtdv_gen_rst_if apb_rst_if(resetn);
  defparam apb_rst_if.if_name       = "apb_rst_if";
  defparam apb_rst_if.PWRST_PERIOD  = 100;
  defparam apb_rst_if.POLARITY      = 0;

  // apb vif construct
  apb_if #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) apb_vif_0
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

  // DUT construct
  dut_dummy dut(
    .apb_clock(clk),
    .apb_reset(resetn),
    .apb_if(apb_if_0)
  );

  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*.demo_tb0.apb0*", "vif", apb_if_0);
    // The specific setting to a sub component will override the setting
    // to its container. In this case, they are all the all the same, so
    // the settings to the sub components are shown but not necessary
    uvm_config_db#(virtual apb_if)::set(null, "*.demo_tb0.apb0.master*", "vif", apb_if_0);
    uvm_config_db#(virtual apb_if)::set(null, "*.demo_tb0.apb0.slave*", "vif", apb_if_0);
    run_test();
  end

  initial begin
    clk <= 1'b0;
  end

  //Generate Clock
  always
    #5 clk = ~clk;

endmodule
