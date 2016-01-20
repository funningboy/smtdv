`ifndef __UART_CTRL_IF_HARNESS_SV__
`define __UART_CTRL_IF_HARNESS_SV__

`timescale 1ns/10ps

import uvm_pkg::*;
`include "uvm_macros.svh"

import smtdv_common_pkg::*;
`include "smtdv_macros.svh"

// uvc
`include "apb_if.sv"
`include "uart_if.sv"
// rtl defines
`include "uart_defines.v"

interface uart_ctrl_if_harness #(
  parameter integer ADDR_WIDTH = 32,
  parameter integer DATA_WIDTH = 32
) (
  input clk,    // wb_clk_i
  input resetn, // wb_rst_i

  // WISHBONE interface
  logic [ADDR_WIDTH-1:0]  wb_adr_i,
  logic [DATA_WIDTH-1:0]  wb_dat_i,
  logic [DATA_WIDTH-1:0]  wb_dat_o,
  logic [0:0]             wb_we_i,
  logic [0:0]             wb_stb_i,
  logic [0:0]             wb_cyc_i,
  logic [3:0]             wb_sel_i,
  logic [0:0]             wb_ack_o,
  logic [0:0]             int_o,

  // UART	signals
	logic[0:0]					    srx_pad_i,
	logic[0:0]					    stx_pad_o,
	logic[0:0]					    rts_pad_o,
	logic[0:0]					    cts_pad_i,
	logic[0:0]					    dtr_pad_o,
	logic[0:0]					    dsr_pad_i,
	logic[0:0]					    ri_pad_i,
	logic[0:0]					    dcd_pad_i

  // optional baudrate output
  `ifdef UART_HAS_BAUDRATE_OUTPUT
    ,
    logic[0:0]	          baud_o
  `endif
);

  wire [3:0] wb_sel;
  wire [31:0] dummy_dbus;
  wire [31:0] dummy_rdbus;
  reg [2:0] div8_clk;

  // APB 2 Woshbone bus map
  assign wb_sel = (apb_if0.paddr[1:0] == 0) ? 4'b0001 : (apb_if0.paddr[1:0] == 1 ? 4'b0010 : (apb_if0.paddr[1:0] == 2 ? 4'b0100 : 4'b1000));
  assign dummy_dbus = {4{apb_if0.pwdata[7:0]}};
  assign apb_if0.prdata[7:0] = dummy_rdbus[31:24] | dummy_rdbus[23:16] | dummy_rdbus[15:8] | dummy_rdbus[7:0];

  // fifo interface
  assign tx_fifo_ptr = `UARTTOPATTR.regs.transmitter.tf_count;
  assign rx_fifo_ptr = `UARTTOPATTR.regs.receiver.rf_count;

  always @(posedge clk) begin
   if (resetn)
     div8_clk = 3'b000;
   else
     div8_clk = div8_clk + 1;
  end

  // used APB Master driver without Wishbone master driver
  // register at apb_env cluster
  apb_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) apb_if0
    (
      .clk(clk),
      .resetn(~resetn),

      .paddr(),
      .prwd(),
      .pwdata(),
      .psel(),
      .penable(),

      .prdata(),
      .pslverr(),
      .pready()
    );

    // used UART TX/RX
    uart_if #(
    ) uart_if0
    (
      .clk(div8_clk[2]),
      .resetn(~resetn),

      .txd(),
      .rxd(),

      .intrpt(),

      .ri_n(),
      .cts_n(),
      .dsr_n(),
      .rts_n(),
      .dtr_n(),
      .dcd_n(),

      .baud_clk()
    );

    `ifndef UARTTOPATTR
        $fatal("please define UARTTOPATTR at uart_ctrl top design\n");
    `endif

      // Wishbone
     `SMTDV_VIF2PORT(apb_if0.has_force, clk, apb_if0.paddr, `UARTTOPATTR.wb_adr_i)
     `SMTDV_VIF2PORT(apb_if0.has_force, clk, apb_if0.prwd, `UARTTOPATTR.wb_we_i)
     `SMTDV_VIF2PORT(apb_if0.has_force, clk, dummy_dbus, `UARTTOPATTR.wb_dat_i)
     `SMTDV_VIF2PORT(apb_if0.has_force, clk, apb_if0.psel[0], `UARTTOPATTR.wb_stb_i)
     `SMTDV_VIF2PORT(apb_if0.has_force, clk, apb_if0.psel[0], `UARTTOPATTR.wb_cyc_i)
     `SMTDV_PORT2VIF(apb_if0.has_force, clk, `UARTTOPATTR.wb_dat_o, dummy_rdbus)
     `SMTDV_PORT2VIF(apb_if0.has_force, clk, wb_sel, `UARTTOPATTR.wb_sel_i)
     `SMTDV_PORT2VIF(apb_if0.has_force, clk, `UARTTOPATTR.wb_ack_o, apb_if0.pready)

     // UART
    `SMTDV_VIF2PORT(uart_if0.has_force, clk, uart_if0.txd, `UARTTOPATTR.srx_pad_i)
    `SMTDV_VIF2PORT(uart_if0.has_force, clk, uart_if0.cts_n, `UARTTOPATTR.cts_pad_i)
    `SMTDV_VIF2PORT(uart_if0.has_force, clk, uart_if0.dsr_n, `UARTTOPATTR.dsr_pad_i)
    `SMTDV_VIF2PORT(uart_if0.has_force, clk, uart_if0.ri_n, `UARTTOPATTR.ri_pad_i)
    `SMTDV_VIF2PORT(uart_if0.has_force, clk, uart_if0.dcd_n, `UARTTOPATTR.dcd_pad_i)
    `SMTDV_PORT2VIF(uart_if0.has_force, clk, `UARTTOPATTR.stx_pad_o, uart_if0.rxd)
    `SMTDV_PORT2VIF(uart_if0.has_force, clk, `UARTTOPATTR.dtr_pad_o, uart_if0.dtr_n)

endinterface

`endif // end of __UART_CTRL_IF_HARNESS_SV__
