
`timescale 1ns/10ps

// define your test env here
`ifndef XBUS_MS_TEST
`define XBUS_MS_TEST
`endif

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

  wire [0:0]  w_req;
  wire [0:0]  w_rw;
  wire [`XBUS_ADDR_WIDTH-1:0] w_addr;
  wire [0:0]  w_ack;
  wire [`XBUS_BYTEN_WIDTH-1:0]  w_byten;
  wire [`XBUS_DATA_WIDTH-1:0] w_rdata;
  wire [`XBUS_DATA_WIDTH-1:0] w_wdata;

  initial begin
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if xbus_rst_if(resetn);
  defparam xbus_rst_if.if_name       = "xbus_rst_if";
  defparam xbus_rst_if.PWRST_PERIOD  = 5000;
  defparam xbus_rst_if.POLARITY      = 0;

/*-----------------------------------------
* used as Master/Slave UVC
*---------------------------------------- */
`ifdef XBUS_MS_UVC
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
`endif

/*-------------------------------------------
*  used as Master UVC/slave is real design
*-------------------------------------------*/
`ifdef XBUS_MS_TEST

  // a normal .v
  xbus_slave #(
    .ADDR_WIDTH   (`XBUS_ADDR_WIDTH),
    .BYTEN_WIDTH  (`XBUS_BYTEN_WIDTH),
    .DATA_WIDTH   (`XBUS_DATA_WIDTH)
  ) u_xbus_slave_0 (
    .clk(clk),
    .resetn(resetn),

    .req(w_req),
    .rw(w_rw),
    .addr(w_addr),
    .ack(w_ack),
    .byten(w_byten),
    .rdata(w_rdata),
    .wdata(w_wdata)
  );

  // bind to xbus_slave.v
  // with DUT = xbus_slave.v TB = xbus_master uvc
  // irun not work for bind
  // ref: http://www.synapse-da.com/Uploads/PDFFiles/03_UVM-Harness.pdf
  //bind u_xbus_slave_0 xbus_slave_if_harness#(
  xbus_slave_if_harness#(
     .ADDR_WIDTH(`XBUS_ADDR_WIDTH),
     .BYTEN_WIDTH(`XBUS_BYTEN_WIDTH),
     .DATA_WIDTH(`XBUS_DATA_WIDTH)
  ) xbus_slave_if_harness_0 (
    .clk(u_xbus_slave_0.clk),
    .resetn(u_xbus_slave_0.resetn),
    .req(u_xbus_slave_0.req),
    .rw(u_xbus_slave_0.rw),
    .addr(u_xbus_slave_0.addr),
    .ack(u_xbus_slave_0.ack),
    .byten(u_xbus_slave_0.byten),
    .rdata(u_xbus_slave_0.rdata),
    .wdata(u_xbus_slave_0.wdata)
  );

  initial begin
    // assign top if to harness if
    uvm_config_db#(`XBUS_VIF)::set(uvm_root::get(), "*", "vif", xbus_slave_if_harness_0.vif);
    uvm_config_db#(`XBUS_RST_VIF)::set(uvm_root::get(), "*", "xbus_rst_vif", xbus_rst_if);
    // preload data to DUT, then release it to normal run mode
    xbus_slave_if_harness_0.has_force = 1;
    run_test();
  end

`endif

  initial begin
    $dumpfile("test_xbus.vcd");
    $dumpvars(0, top);
  end

endmodule
