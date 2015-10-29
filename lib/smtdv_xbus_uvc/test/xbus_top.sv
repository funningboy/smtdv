
`timescale 1ns/10ps

`include "xbus_defines.svh"
`include "xbus_if_harness.sv"

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
  defparam xbus_rst_if.PWRST_PERIOD  = 100;
  defparam xbus_rst_if.POLARITY      = 0;

  dut_1m1s #(
    .ADDR_WIDTH (`XBUS_ADDR_WIDTH),
    .BYTEN_WIDTH(`XBUS_BYTEN_WIDTH),
    .DATA_WIDTH (`XBUS_DATA_WIDTH)
  ) u_dut_1m1s (
    .clk(clk),
    .resetn(resetn)
  );

  bind `XBUSMASTERATTR(0) xbus_master_if_harness#(
    .UID(0),
    .ADDR_WIDTH (`XBUS_ADDR_WIDTH),
    .BYTEN_WIDTH(`XBUS_BYTEN_WIDTH),
    .DATA_WIDTH (`XBUS_DATA_WIDTH)
  ) xbus_master_if_harness (
    .clk(`XBUSMASTERATTR(0).clk),
    .resetn(`XBUSMASTERATTR(0).resetn),
    .req(`XBUSMASTERATTR(0).req),
    .rw(`XBUSMASTERATTR(0).rw),
    .addr(`XBUSMASTERATTR(0).addr),
    .ack(`XBUSMASTERATTR(0).ack),
    .byten(`XBUSMASTERATTR(0).byten),
    .rdata(`XBUSMASTERATTR(0).rdata),
    .wdata(`XBUSMASTERATTR(0).wdata)
  );

  // bind to xbus_slave.v
  // with DUT = xbus_slave.v TB = xbus_master uvc
  // ref: http://www.synapse-da.com/Uploads/PDFFiles/03_UVM-Harness.pdf
  bind `XBUSSLAVEATTR(0) xbus_slave_if_harness#(
     .UID(0),
     .ADDR_WIDTH(`XBUS_ADDR_WIDTH),
     .BYTEN_WIDTH(`XBUS_BYTEN_WIDTH),
     .DATA_WIDTH(`XBUS_DATA_WIDTH)
  ) xbus_slave_if_harness (
    .clk(`XBUSSLAVEATTR(0).clk),
    .resetn(`XBUSSLAVEATTR(0).resetn),
    .req(`XBUSSLAVEATTR(0).req),
    .rw(`XBUSSLAVEATTR(0).rw),
    .addr(`XBUSSLAVEATTR(0).addr),
    .ack(`XBUSSLAVEATTR(0).ack),
    .byten(`XBUSSLAVEATTR(0).byten),
    .rdata(`XBUSSLAVEATTR(0).rdata),
    .wdata(`XBUSSLAVEATTR(0).wdata)
  );

  initial begin
    // assign top if to harness if
    uvm_config_db#(`XBUS_VIF)::set(uvm_root::get(), "*.master_agent[*0]*", "vif", `XBUSMASTERVIF(0));
    uvm_config_db#(`XBUS_VIF)::set(uvm_root::get(), "*.slave_agent[*0]*", "vif", `XBUSSLAVEVIF(0));
    uvm_config_db#(`XBUS_RST_VIF)::set(uvm_root::get(), "*", "xbus_rst_vif", xbus_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_xbus.vcd");
    $dumpvars(0, top);
  end


  initial begin
    $display("%s", $system ("pwd"));
    $display("--------------------------\n");
  end
endmodule

// macro port as channel declear
module test(
  `XBUSPORT(m, 0)
);

endmodule
