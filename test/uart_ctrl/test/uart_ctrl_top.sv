`timescalse 1ns/10ps

`include "test/uart_ctrl_defines.svh"
`include "tb/uart_ctrl_top.sv"
`include "test/uart_ctrl_if_harness.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import uart_ctrl_pkg::*;
  `include "uart_ctrl_typedefs.svh"

  `include "../test/uart_ctrl_test_list.sv"

  parameter APB_ADDR_WIDTH = `APB_ADDR_WIDTH;
  parameter APB_DATA_WIDTH = `APB_DATA_WIDTH;

  reg clk;
  reg resetn;

  wire [3:0] wb_sel;
  wire [31:0] dummy_dbus;
  wire [31:0] dummy_rdbus;
  reg [2:0] div8_clk;

  smtdv_gen_rst_if uart_ctl_rst_if(resetn);
  defparam uart_ctl_rst_if.if_name       = "uart_ctl_rst_if";
  defparam uart_ctl_rst_if.PWRST_PERIOD  = 100;
  defparam uart_ctl_rst_if.POLARITY      = 0;

  initial begin
    clk = 0;
    #5 clk = ~clk;
  end

  always @(posedge clk) begin
    if (!resetn)
      div8_clk = 3'b000;
    else
      div8_clk = div8_clk + 1;
  end

  //RTL Instantiation
  uart_top uart_dut(
	  .wb_clk_i(clk),
	  .wb_rst_i(~resetn)
  );

  bind `UARTTOPATTR uart_ctrl_if_harness #(
    .ADDR_WIDTH(`APB_ADDR_WIDTH),
    .DATA_WIDTH(`APB_DATA_WIDTH)
  ) uart_ctrl_if_harness (
    .clk(`UARTTOPATTR.wb_clk_i)
	  // Wishbone signals
	  .resetn(`UARTTOPATTR.wb_rst_i),
    .wb_adr_i(`UARTTOPATTR.wb_adr_i),
    .wb_dat_i(`UARTTOPATTR.wb_dat_i),
    .wb_dat_o(`UARTTOPATTR.wb_dat_o),
    .wb_we_i(`UARTTOPATTR.wb_we_i),
    .wb_stb_i(`UARTTOPATTR.wb_stb_i),
    .wb_cyc_i(`UARTTOPATTR.wb_cyc_i),
    .wb_ack_o(`UARTTOPATTR.wb_ack_o),
    .wb_sel_i(`UARTTOPATTR.wb_sel_i),
    .int_o(`UARTTOPATTR.int_o), // interrupt request

    // UART	signals
    // serial input/output
    .stx_pad_o(`UARTTOPATTR.srx_pad_o),
    .srx_pad_i(`UARTTOPATTR.srx_pad_i),

    // modem signals
	  .rts_pad_o(`UARTTOPATTR.rts_pad_o),
    .cts_pad_i(`UARTTOPATTR.cts_pad_i),
    .dtr_pad_o(`UARTTOPATTR.dtr_pad_o),
    .dsr_pad_i(`UARTTOPATTR.dsr_pad_i),
    .ri_pad_i(`UARTTOPATTR.ri_pad_i),
    .dcd_pad_i(`UARTTOPATTR.dcd_pad_i)
  );


  initial begin
    uvm_config_db#(`APB_VIF)::set(uvm_root::get(),  ".apb_env.master_agent[*0]*", "vif", uart_ctrl_if_harness.apb_if0);
    uvm_config_db#(`UART_VIF)::set(uvm_root::get(), ".uart_env.slave_agent[*0]*", "vif", uart_ctrl_if_harness.uart_if0);
    run_test();
  end

  initial begin
    $dumpfile("test_uart_ctrl.vcd");
    $dumpvars(0, top);
  end

  final begin
    $display("=======================================================");
    $display("UART CONTROLLER DUT REGISTERS:");
    $displayh("uart_ctrl_top.uart_dut.regs.dl  =",  top.uart_dut.regs.dl);
    $displayh("uart_ctrl_top.uart_dut.regs.fcr = ", top.uart_dut.regs.fcr);
    $displayh("uart_ctrl_top.uart_dut.regs.ier = ", top.uart_dut.regs.ier);
    $displayh("uart_ctrl_top.uart_dut.regs.iir = ", top.uart_dut.regs.iir);
    $displayh("uart_ctrl_top.uart_dut.regs.lcr = ", top.uart_dut.regs.lcr);
    $display("=======================================================");
  end

endmodule
