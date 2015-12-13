`ifndef __SMTDV_IF_SV__
`define __SMTDV_IF_SV__

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "smtdv_macros.svh"

interface smtdv_if (
  input clk, // hclk
  input resetn // hresetn
  );

  bit has_force = `TRUE;
  bit has_checks = `TRUE;
  bit has_coverage = `TRUE;
  bit has_performance = `TRUE;

endinterface: smtdv_if

`endif
