
`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

//define XBUS virtual interface
// TODO bind force interface ...
// coverage group
interface xbus_if #(
  parameter int ADDR_WIDTH  = 14,
  parameter int BYTEN_WIDTH = 4,
  parameter int DATA_WIDTH = 32
  ) (
    input clk,
    input resetn
  );

  logic [0:0]   req;
  logic [0:0]    rw;
  logic [ADDR_WIDTH-1:0]  addr;
  logic [0:0]   ack;
  logic [BYTEN_WIDTH-1:0] byten;
  logic [DATA_WIDTH-1:0] rdata;
  logic [DATA_WIDTH-1:0] wdata;

  bit has_checks = 1;
  bit has_coverage = 1;
  bit has_performance = 1;
  bit has_force = 0;

  longint cyc = 0;

  clocking slave @(posedge clk or negedge resetn);
    default input #1ns output #1ns;
    input   clk;
    input   resetn;
    input   req;
    input   rw;
    input   addr;
    output  ack;
    input   byten;
    input   wdata;
    output  rdata;
  endclocking

  clocking master @(posedge clk or negedge resetn);
    default input #1ns output #1ns;
    input   clk;
    input   resetn;
    output  req;
    output  rw;
    output  addr;
    input   ack;
    output  byten;
    output  wdata;
    input   rdata;
  endclocking

  always @(negedge clk)
    cyc += 1;

  // check XBUS protocol assertions
  always @(negedge clk)
  begin
    // addr must not be X or Z during R/W phase (req = 1'b1)
    assert_addr : assert property (
      disable iff(!has_checks)
      ($onehot(req) |-> !$isunknown(addr)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("addr = %d went to X or Z during R/W phase when the req = %d", addr, req)})

    // rw must not be X or Z during R/W phase (req = 1'b1)
    assert_rw : assert property (
      disable iff(!has_checks)
      ($onehot(req) |-> !$isunknown(rw)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("rw = %d went to X or Z during R/W phase when the req = %d", rw, req)})

    // be must not be X or Z during R/W phase (req = 1'b1)
    assert_byten : assert property (
      disable iff(!has_checks)
      ($onehot(req) && !$isunknown(rw) |-> !$isunknown(byten)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("byten = %d went to X or Z during R/W phase when the req = %d", byten, req)})

    // wdata must not be X or Z during R phase (req = 1'b1 and rw = 1'b1)
    assert_wdata : assert property (
      disable iff(!has_checks)
      ($onehot(req) && $onehot(rw) |-> !$isunknown(wdata)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("wdata = %d went to X or Z during W phase when the req = %d and rw = %d", wdata, req, rw)})

    // rdata must not be X or Z during R phase (req = 1'b1 and rw = 1'b0)
    assert_rdata : assert property (
      disable iff(!has_checks)
      ($onehot(req) && !$onehot(rw) && $onehot(ack) |-> !$isunknown(rdata)))
    else
      `uvm_error("XBUS_VIF", {$psprintf("rdata = %d went to X or Z during R phase when the req = %d, ack = %d, and rw = %d", rdata, req, ack, rw)})

    // ack must not be X or Z during R/W phase (req = 1'b1)
    // ...
  end
endinterface : xbus_if

