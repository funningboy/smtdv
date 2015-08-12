
`timescale 1ns/10ps

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import xbus_pkg::*;
  `include "xbus_typedefs.svh"

  `include "./test/xbus_test_list.sv"

  parameter ADDR_WIDTH = `XBUS_ADDR_WIDTH;
  parameter BYTEN_WIDTH = `XBUS_BYTEN_WIDTH;
  parameter DATA_WIDTH = `XBUS_DATA_WIDTH;

  reg clk;
  reg resetn;

  initial begin
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if xbus_rst_if(resetn);
  defparam xbus_rst_if.if_name       = "xbus_rst_if";
  defparam xbus_rst_if.PWRST_PERIOD  = 5000;
  defparam xbus_rst_if.POLARITY      = 0;

  xbus_if #(
    .ADDR_WIDTH   (`XBUS_ADDR_WIDTH),
    .BYTEN_WIDTH  (`XBUS_BYTEN_WIDTH),
    .DATA_WIDTH   (`XBUS_DATA_WIDTH)
  ) xbus_if_0
  (
    .clk(clk),
    .resetn(resetn)
  );

  initial begin
    uvm_config_db#(`XBUS_VIF)::set(uvm_root::get(), "*", "vif", xbus_if_0);
    uvm_config_db#(`XBUS_RST_VIF)::set(uvm_root::get(), "*", "xbus_rst_vif", xbus_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_xbus.vcd");
    $dumpvars(0, top);
  end

endmodule
