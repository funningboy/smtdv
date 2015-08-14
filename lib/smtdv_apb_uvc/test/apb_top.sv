
`timescale 1ns/10ps

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import apb_pkg::*;
  `include "apb_typedefs.svh"

  `include "./test/apb_test_list.sv"

  parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
  parameter DATA_WIDTH = `APB_DATA_WIDTH;

  reg clk;
  reg resetn;

  initial begin
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if apb_rst_if(resetn);
  defparam apb_rst_if.if_name       = "apb_rst_if";
  defparam apb_rst_if.PWRST_PERIOD  = 5000;
  defparam apb_rst_if.POLARITY      = 0;

/*-------------------------------------------
*  used as Master UVC/slave is real design
*-------------------------------------------*/

  dut_1m2s #(
    .ADDR_WIDTH (`APB_ADDR_WIDTH),
    .DATA_WIDTH (`APB_DATA_WIDTH)
  ) u_dut_1m2s (
    .clk(clk),
    .resetn(resetn)
  );

  `define APBMASTERATTR(i) u_dut_1m2s.M[i].u_apb_master
  `define APBSLAVEATTR(i) u_dut_1m2s.S[i].u_apb_slave

  genvar i;
  generate
  for (i=0; i < 1; i++) begin: M
    apb_master_if_harness#(
       .ADDR_WIDTH(`APB_ADDR_WIDTH),
       .DATA_WIDTH(`APB_DATA_WIDTH)
    ) apb_master_if_harness (
      .clk(`APBMASTERATTR(i).clk),
      .resetn(`APBMASTERATTR(i).resetn),

      .paddr(`APBMASTERATTR(i).paddr),
      .prwd(`APBMASTERATTR(i).prwd),
      .pwdata(`APBMASTERATTR(i).pwdata),
      .psel(`APBMASTERATTR(i).psel),
      .penable(`APBMASTERATTR(i).penable),

      .prdata(`APBMASTERATTR(i).prdata),
      .pready(`APBMASTERATTR(i).pready),
      .pslverr(`APBMASTERATTR(i).pslverr)
    );
  end
  endgenerate

  `define APBSLAVESELATTR(i)\

  generate
  for (i=0; i < 2; i++) begin: S
    //bind `APBSLAVEATTR(i) apb_slave_if_harness#(
    wire [15:0] w_psel;
    if (i==0)
       assign w_psel = {15'b0000_0000_0000_000,`APBSLAVEATTR(i).psel};
    else
       assign w_psel = {14'b0000_0000_0000_00, `APBSLAVEATTR(i).psel, 1'b0};

    apb_slave_if_harness#(
       .ADDR_WIDTH(`APB_ADDR_WIDTH),
       .DATA_WIDTH(`APB_DATA_WIDTH)
    ) apb_slave_if_harness (
      .clk(`APBSLAVEATTR(i).clk),
      .resetn(`APBSLAVEATTR(i).resetn),

      .paddr(`APBSLAVEATTR(i).paddr),
      .prwd(`APBSLAVEATTR(i).prwd),
      .pwdata(`APBSLAVEATTR(i).pwdata),
      .psel(w_psel),
      .penable(`APBSLAVEATTR(i).penable),

      .prdata(`APBSLAVEATTR(i).prdata),
      .pready(`APBSLAVEATTR(i).pready),
      .pslverr(`APBSLAVEATTR(i).pslverr)
    );
  end
  endgenerate

  initial begin
    uvm_config_db#(`APB_VIF)::set(uvm_root::get(), "*.slave_agent[*0]*", "vif", top.S[0].apb_slave_if_harness.vif);
    uvm_config_db#(`APB_VIF)::set(uvm_root::get(), "*.slave_agent[*1]*", "vif", top.S[1].apb_slave_if_harness.vif);
    uvm_config_db#(`APB_VIF)::set(uvm_root::get(), "*.master_agent[*0]*", "vif", top.M[0].apb_master_if_harness.vif);
    uvm_config_db#(`APB_RST_VIF)::set(uvm_root::get(), "*", "apb_rst_vif", apb_rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_apb.vcd");
    $dumpvars(0, top);
  end

endmodule
