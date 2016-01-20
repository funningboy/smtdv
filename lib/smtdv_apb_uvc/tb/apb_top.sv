
`timescale 1ns/10ps

`include "apb_defines.svh"
`include "apb_if_harness.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import test_apb_pkg::*;

  parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
  parameter DATA_WIDTH = `APB_DATA_WIDTH;

  typedef virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH) apb_if_t;
  typedef virtual interface smtdv_gen_rst_if#("apb_rst_if", 100, 0) rst_if_t;

  reg clk;
  wire resetn;
  wire fresetn;

  initial begin
    clk= 0;
     forever clk=#5 ~clk;
  end

  //-------------------------------------------//
  // due to MTI is got compiler error at costructing the init virtual vif of each template component.
  // we use fake vif to skip it
  // for reset vif, apb vif
  smtdv_if    fk_smtdv_if(.clk(clk), .resetn(fresetn));
  smtdv_gen_rst_if rst_if(fresetn);
  defparam rst_if.if_name       = "smtdv_rst_if";
  defparam rst_if.PWRST_PERIOD  = 100;
  defparam rst_if.POLARITY      = 0;
  //-------------------------------------------//


  smtdv_gen_rst_if apb_rst_if(resetn);
  defparam apb_rst_if.if_name       = "apb_rst_if";
  defparam apb_rst_if.PWRST_PERIOD  = 100;
  defparam apb_rst_if.POLARITY      = 0;

/*-------------------------------------------
*  used as Master UVC/slave is real design
*-------------------------------------------*/
  dut_1m2s#(
    .ADDR_WIDTH (`APB_ADDR_WIDTH),
    .DATA_WIDTH (`APB_DATA_WIDTH)
  ) u_dut_1m2s (
    .clk(clk),
    .resetn(resetn)
  );

  bind `APBMASTERATTR(0) apb_master_if_harness#(
     .UID(0),
     .ADDR_WIDTH(`APB_ADDR_WIDTH),
     .DATA_WIDTH(`APB_DATA_WIDTH)
  ) apb_master_if_harness (
    .clk(`APBMASTERATTR(0).clk),
    .resetn(`APBMASTERATTR(0).resetn),

    .paddr(`APBMASTERATTR(0).paddr),
    .prwd(`APBMASTERATTR(0).prwd),
    .pwdata(`APBMASTERATTR(0).pwdata),
    .psel(`APBMASTERATTR(0).psel),
    .penable(`APBMASTERATTR(0).penable),

    .prdata(`APBMASTERATTR(0).prdata),
    .pready(`APBMASTERATTR(0).pready),
    .pslverr(`APBMASTERATTR(0).pslverr)
  );

  bind `APBSLAVEATTR(0) apb_slave_if_harness#(
     .UID(0),
     .ADDR_WIDTH(`APB_ADDR_WIDTH),
     .DATA_WIDTH(`APB_DATA_WIDTH)
  ) apb_slave_if_harness (
    .clk(`APBSLAVEATTR(0).clk),
    .resetn(`APBSLAVEATTR(0).resetn),

    .paddr(`APBSLAVEATTR(0).paddr),
    .prwd(`APBSLAVEATTR(0).prwd),
    .pwdata(`APBSLAVEATTR(0).pwdata),
    .psel({15'h0, `APBSLAVEATTR(0).psel}),
    .penable(`APBSLAVEATTR(0).penable),

    .prdata(`APBSLAVEATTR(0).prdata),
    .pready(`APBSLAVEATTR(0).pready),
    .pslverr(`APBSLAVEATTR(0).pslverr)
  );

  bind `APBSLAVEATTR(1) apb_slave_if_harness#(
     .UID(1),
     .ADDR_WIDTH(`APB_ADDR_WIDTH),
     .DATA_WIDTH(`APB_DATA_WIDTH)
  ) apb_slave_if_harness (
    .clk(`APBSLAVEATTR(1).clk),
    .resetn(`APBSLAVEATTR(1).resetn),

    .paddr(`APBSLAVEATTR(1).paddr),
    .prwd(`APBSLAVEATTR(1).prwd),
    .pwdata(`APBSLAVEATTR(1).pwdata),
    .psel({14'h0, `APBSLAVEATTR(1).psel, 1'h0}),
    .penable(`APBSLAVEATTR(1).penable),

    .prdata(`APBSLAVEATTR(1).prdata),
    .pready(`APBSLAVEATTR(1).pready),
    .pslverr(`APBSLAVEATTR(1).pslverr)
  );


  initial begin
    uvm_config_db#(apb_if_t)::set(uvm_root::get(), "*.slave_agent[*0]*", "vif", `APBSLAVEVIF(0));
    uvm_config_db#(apb_if_t)::set(uvm_root::get(), "*.slave_agent[*1]*", "vif", `APBSLAVEVIF(1));
    uvm_config_db#(apb_if_t)::set(uvm_root::get(), "*.master_agent[*0]*", "vif",`APBMASTERIVF(0));
    uvm_config_db#(rst_if_t)::set(uvm_root::get(), "*", "rst_vif", apb_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_apb.vcd");
    $dumpvars(0, top);
  end

endmodule
