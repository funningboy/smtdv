
`ifndef __APB_IF_SV__
`define __APB_IF_SV__

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "smtdv_macros.svh"

//define apb virtual interface
// TODO bind force interface ...
// coverage group
interface apb_if#(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    logic [ADDR_WIDTH-1:0]  paddr,
    logic [0:0]             prwd,
    logic [DATA_WIDTH-1:0]  pwdata,
    logic [15:0]            psel, // master [15:0], slave[0:0]
    logic [0:0]             penable,

    logic [DATA_WIDTH-1:0]  prdata,
    logic [0:0]             pslverr,
    logic [0:0]             pready,

    // only for pirq test
    logic [0:0]             dummy

  );

  smtdv_if pvif (
    .clk(clk),
    .resetn(resetn),
    .dummy()
  );

  bit has_force = `TRUE;
  bit has_checks = `TRUE;
  bit has_coverage = `TRUE;
  bit has_performance = `TRUE;

  // declare your sideband debug msg
  bit [ADDR_WIDTH-1:0]  label;

  longint cyc = 0;

  clocking slave @(posedge clk or negedge resetn);
    default input#1ns output#1ns;
    input   clk;
    input   resetn;

    input   paddr;
    input   prwd;
    input   pwdata;
    input   psel;
    input   penable;

    output  prdata;
    output  pready;
    output  pslverr;

  endclocking

  clocking master @(posedge clk or negedge resetn);
    default input#1ns output#1ns;
    input   clk;
    input   resetn;

    output   paddr;
    output   prwd;
    output   pwdata;
    output   psel;
    output   penable;

    input  prdata;
    input  pready;
    input  pslverr;

  endclocking

  always @(negedge clk)
    cyc += 1;

  // check APB protocol assertions
  always @(negedge clk)
  begin
    // addr must not be X or Z during R/W phase (req = 1'b1)
    assert_paddr : assert property (
      disable iff(!has_checks)
      ($onehot(psel) |-> !$isunknown(paddr)))
    else
      $error({$psprintf("APB_VIF, paddr = %d went to X or Z during R/W phase when the psel = %d", paddr, psel)});

    // TODO
  end

endinterface : apb_if

`endif
