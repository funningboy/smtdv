`ifndef __AHB_IF_SV__
`define __AHB_IF_SV__

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

//define ahb virtual interface
// coverage group
interface ahb_if #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    input clk, // hclk
    input resetn, // hresetn

  logic [ADDR_WIDTH-1:0]  haddr,
  logic [1:0]             htrans,
  logic [0:0]             hwrite,
  logic [2:0]             hsize,
  logic [2:0]             hburst,
  logic [3:0]             hprot,
  logic [DATA_WIDTH-1:0]  hwdata,
  logic [0:0]             hmastlock,

  logic [15:0]             hsel, // master [15:0], slave[0:0]

  logic [DATA_WIDTH-1:0]  hrdata,
  logic [0:0]             hready,
  logic [0:0]             hreadyout,
  logic [1:0]             hresp,

  logic [0:0]             hbusreq,
  logic [0:0]             hgrant
  );

  bit has_force = 1;
  bit has_checks = 1;
  bit has_coverage = 1;
  bit has_performance = 1;

  longint cyc = 0;

  clocking slave @(posedge clk or negedge resetn);
    default input #1ns output #1ns;
    input  clk;
    input  resetn;
    // to decoder
    input  hsel;
    // to ahb master
    input  haddr;
    input  htrans;
    input  hwrite;
    input  hsize;
    input  hburst;
    input  hprot;
    input  hwdata;
    input  hready;
    output hrdata;
    output hresp;
    output hreadyout;
  endclocking

  clocking master @(posedge clk or negedge resetn);
    default input #1ns output #1ns;
    input   clk;
    input   resetn;
    // to arbiter
    output  hbusreq;
    output  hmastlock;
    input   hgrant;
    // to ahb slave
    output  haddr;
    output  htrans;
    output  hwrite;
    output  hsize;
    output  hburst;
    output  hprot;
    output  hwdata;
    input   hrdata;
    input   hready;
    input   hresp;
  endclocking

  always @(negedge clk)
    cyc += 1;

  // check AHB protocol assertions
  // TODO:
  always @(negedge clk)
  begin
    // implement Assertion here...
  end

endinterface : ahb_if

`endif //
