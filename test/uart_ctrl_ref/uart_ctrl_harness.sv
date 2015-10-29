

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"


interface uart_top_if_harness #(
  parameter integer APB_ADDR_WIDTH = 14,
  parameter integer APB_DATA_WIDTH = 32
  ) (

    input clk,
    input resetn,
	// Wishbone signals
    logic [APB_ADDR_WIDTH-1:0] wb_adr_i,
    logic [APB_DATA_WIDTH-1:0] wb_dat_i,
    logic [APB_DATA_WIDTH-1:0] wb_dat_o,
    logic wb_we_i,
    logic wb_stb_i,
    logic wb_cyc_i,
    logic wb_ack_o,
    logic wb_sel_i,
	  logic int_o, // interrupt request

	// UART	signals
	// serial input/output
	  logic stx_pad_o,
    logic srx_pad_i,

	// modem signals
	  logic rts_pad_o,
    logic cts_pad_i,
    logic dtr_pad_o,
    logic dsr_pad_i,
    logic ri_pad_i,
    logic dcd_pad_i
  );


