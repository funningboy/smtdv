`ifndef __SPI_IF_SV__
`define __SPI_IF_SV__

`tiescale 1ns/10ps
import uvm_pkg::*
`include "uvm_macros.svh"

interface spi_if #(
  parameter interface DATA_WIDTH = 32
  ) (
  input clk,    // hclk
  input resetn, // hresetn
      logic [

`endif
