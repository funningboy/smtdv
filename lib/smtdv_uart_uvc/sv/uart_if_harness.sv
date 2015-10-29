`ifndef __UART_IF_HARNESS_SV__
`define __UART_IF_HARNESS_SV__

`timescale 1ns/10ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "uart_if.sv"
`include "smtdv_macros.svh"

interface uart_tx_if_harness #(
  parameter integer UID = 0
  ) (
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

  logic baud_clk  // TODO: Baud Rate Clock not used ??
  );

  bit has_force = 1;

  uart_if #(
  ) vif
  (
    .clk(clk),
    .resetn(resetn),

    .txd(),    // Transmit Data
    .rxd(),    // Receive Data

    .intrpt(),  // Interrupt

    .ri_n(),    // ring indicator
    .cts_n(),   // clear to send
    .dsr_n(),   // data set ready
    .rts_n(),   // request to send
    .dtr_n(),   // data terminal ready
    .dcd_n(),   // data carrier detect

    .baud_clk()  // TODO: Baud Rate Clock not used ??
    );

    `ifndef UARTTXATTR
        $fatal("please define UARTTXATTR as forced.vif at top design");
    `endif
      `SMTDV_VIF2PORT(has_force, clk, vif.txd, `UARTTXATTR(UID).txd)
      `SMTDV_VIF2PORT(has_force, clk, vif.rts_n, `UARTTXATTR(UID).rts_n)
      `SMTDV_VIF2PORT(has_force, clk, vif.dtr_n, `UARTTXATTR(UID).dtr_n)
      `SMTDV_VIF2PORT(has_force, clk, vif.dcd_n, `UARTTXATTR(UID).dcd_n)
      `SMTDV_VIF2PORT(has_force, clk, vif.baud_clk, `UARTTXATTR(UID).baud_clk)
      `SMTDV_VIF2PORT(has_force, clk, vif.intrpt, `UARTTXATTR(UID).intrpt)

      `SMTDV_PORT2VIF(has_force, clk, `UARTTXATTR(UID).rxd,   vif.rxd)
      `SMTDV_PORT2VIF(has_force, clk, `UARTTXATTR(UID).cts_n, vif.cts_n)
      `SMTDV_PORT2VIF(has_force, clk, `UARTTXATTR(UID).dsr_n, vif.dsr_n)
      `SMTDV_PORT2VIF(has_force, clk, `UARTTXATTR(UID).ri_n,  vif.ri_n)

endinterface


interface uart_rx_if_harness #(
  parameter integer UID = 0
  ) (
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

  logic baud_clk  // TODO: Baud Rate Clock not used ??
  );

  bit has_force = 1;

  uart_if #(
  ) vif
  (
    .clk(clk),
    .resetn(resetn),

    .txd(),    // Transmit Data
    .rxd(),    // Receive Data

    .intrpt(),  // Interrupt

    .ri_n(),    // ring indicator
    .cts_n(),   // clear to send
    .dsr_n(),   // data set ready
    .rts_n(),   // request to send
    .dtr_n(),   // data terminal ready
    .dcd_n(),   // data carrier detect

    .baud_clk()  // TODO: Baud Rate Clock not used ??
    );

    `ifndef UARTRXATTR
        $fatal("please define UARTRXATTR as forced.vif at top design");
    `endif
      `SMTDV_PORT2VIF(has_force, clk, `UARTRXATTR(UID).txd, vif.txd)
      `SMTDV_PORT2VIF(has_force, clk, `UARTRXATTR(UID).rts_n, vif.rts_n)
      `SMTDV_PORT2VIF(has_force, clk, `UARTRXATTR(UID).dtr_n, vif.dtr_n)
      `SMTDV_PORT2VIF(has_force, clk, `UARTRXATTR(UID).dcd_n, vif.dcd_n)
      `SMTDV_PORT2VIF(has_force, clk, `UARTRXATTR(UID).baud_clk, vif.baud_clk)
      `SMTDV_VIF2PORT(has_force, clk, `UARTRXATTR(UID).intrpt, vif.intrpt)

      `SMTDV_VIF2PORT(has_force, clk, vif.rxd,   `UARTRXATTR(UID).rxd)
      `SMTDV_VIF2PORT(has_force, clk, vif.cts_n, `UARTRXATTR(UID).cts_n)
      `SMTDV_VIF2PORT(has_force, clk, vif.dsr_n, `UARTRXATTR(UID).dsr_n)
      `SMTDV_VIF2PORT(has_force, clk, vif.ri_n,  `UARTRXATTR(UID).ri_n)

endinterface

`endif
