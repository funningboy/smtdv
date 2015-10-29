
`timescale 1ns/10ps

`include "ahb_defines.svh"
`include "ahb_if_harness.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import ahb_pkg::*;
  `include "ahb_typedefs.svh"

  `include "./test/ahb_test_list.sv"

  parameter ADDR_WIDTH = `AHB_ADDR_WIDTH;
  parameter DATA_WIDTH = `AHB_DATA_WIDTH;

  reg clk;
  reg resetn;

  initial begin
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if ahb_rst_if(resetn);
  defparam ahb_rst_if.if_name       = "ahb_rst_if";
  defparam ahb_rst_if.PWRST_PERIOD  = 100;
  defparam ahb_rst_if.POLARITY      = 0;

/*-------------------------------------------
*  used as Master UVC/slave is real design
*-------------------------------------------*/

  dut_1m1s #(
    .ADDR_WIDTH (`AHB_ADDR_WIDTH),
    .DATA_WIDTH (`AHB_DATA_WIDTH)
  ) u_dut_1m1s (
    .clk(clk),
    .resetn(resetn)
  );

    bind `AHBMASTERATTR(0) ahb_master_if_harness #(
       .UID(0),
       .ADDR_WIDTH(`AHB_ADDR_WIDTH),
       .DATA_WIDTH(`AHB_DATA_WIDTH)
    ) ahb_master_if_harness (
      .clk(`AHBMASTERATTR(0).clk),
      .resetn(`AHBMASTERATTR(0).resetn),

      .hbusreq(`AHBMASTERATTR(0).hbusreq),
      .hmastlock(`AHBMASTERATTR(0).hmastlock),
      .hgrant(`AHBMASTERATTR(0).hgrant),
      // to ahb slave
      .haddr(`AHBMASTERATTR(0).haddr),
      .htrans(`AHBMASTERATTR(0).htrans),
      .hwrite(`AHBMASTERATTR(0).hwrite),
      .hsize(`AHBMASTERATTR(0).hsize),
      .hburst(`AHBMASTERATTR(0).hburst),
      .hprot(`AHBMASTERATTR(0).hprot),
      .hwdata(`AHBMASTERATTR(0).hwdata),
      .hrdata(`AHBMASTERATTR(0).hrdata),
      .hready(`AHBMASTERATTR(0).hready),
      .hresp(`AHBMASTERATTR(0).hresp)
    );

    bind `AHBSLAVEATTR(0) ahb_slave_if_harness #(
      .UID(0),
      .ADDR_WIDTH(`AHB_ADDR_WIDTH),
      .DATA_WIDTH(`AHB_DATA_WIDTH)
    ) ahb_slave_if_harness (
      .clk(`AHBSLAVEATTR(0).clk),
      .resetn(`AHBSLAVEATTR(0).resetn),

      .haddr(`AHBSLAVEATTR(0).haddr),
      .htrans(`AHBSLAVEATTR(0).htrans),
      .hwrite(`AHBSLAVEATTR(0).hwrite),
      .hsize(`AHBSLAVEATTR(0).hsize),
      .hburst(`AHBSLAVEATTR(0).hburst),
      .hprot(`AHBSLAVEATTR(0).hprot),
      .hmastlock(`AHBSLAVEATTR(0).hmastlock),
      .hsel({15'h0, 1'b1}),
      .hwdata(`AHBSLAVEATTR(0).hwdata),
      .hrdata(`AHBSLAVEATTR(0).hrdata),
      .hready(`AHBSLAVEATTR(0).hready),
      .hreadyout(`AHBSLAVEATTR(0).hreadyout),
      .hresp(`AHBSLAVEATTR(0).hresp)
    );

  initial begin
    uvm_config_db#(`AHB_VIF)::set(uvm_root::get(), "*.slave_agent[*0]*", "vif", `AHBSLAVEVIF(0));
    uvm_config_db#(`AHB_VIF)::set(uvm_root::get(), "*.master_agent[*0]*", "vif", `AHBMASTERVIF(0));
    uvm_config_db#(`AHB_RST_VIF)::set(uvm_root::get(), "*", "ahb_rst_vif", ahb_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_ahb.vcd");
    $dumpvars(0, top);
  end

endmodule
