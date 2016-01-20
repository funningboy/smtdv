
`ifndef __UART_SEQ_PKG_SV__
`define __UART_SEQ_PKG_SV__

`timescale 1ns/10ps

package uart_seq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_stl_pkg::*;
  import smtdv_sqlite3_pkg::*;

  import smtdv_common_pkg::*;
  import smtdv_common_seq_pkg::*;
  `include "smtdv_macros.svh"

  `include "uart_defines.svh"
  import uart_pkg::*;

  `include "uart_tx_seqs_lib.sv"
  `include "uart_rx_seqs_lib.sv"
  `include "uart_tx_vseqs_lib.sv"
  `include "uart_rx_vseqs_lib.sv"

endpackage : uart_seq_pkg

`endif // __UART_SEQ_PKG_SV__
