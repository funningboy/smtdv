
`ifndef __UART_IF_SV__
`define __UART_IF_SV__

`timescalse 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

interface uart_if(
  input clk,
  input resetn,

  logic txd,    // Transmit Data
  logic rxd,    // Receive Data

  logic intrpt,  // Interrupt

  logic ri_n,    // ring indicator
  logic cts_n,   // clear to send
  logic dsr_n,   // data set ready
  logic rts_n,   // request to send
  logic dtr_n,   // data terminal ready
  logic dcd_n,   // data carrier detect

  logic baud_clk,  // Baud Rate Clock

  // Control flags
  bit                has_checks = 1;
  bit                has_coverage = 1;
  bit                has_performance = 1;

  longint cyc = 0;

  clocking tx @();

  clocking rx @();
/*  FIX TO USE CONCURRENT ASSERTIONS
  always @(posedge clock)
  begin
    // rxd must not be X or Z
    assertRxdUnknown:assert property (
                       disable iff(!has_checks || !reset)(!$isunknown(rxd)))
                       else
                         $error("ERR_UART001_Rxd_XZ\n Rxd went to X or Z");
  end
*/

endinterface : uart_if
