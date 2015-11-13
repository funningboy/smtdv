`ifndef __SMTDV_IF_SV__
`define __SMTDV_IF_SV__

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

interface smtdv_if #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
) (
  input clk, // hclk
  input resetn // hresetn
  );
endinterface: smtdv_if

`endif
