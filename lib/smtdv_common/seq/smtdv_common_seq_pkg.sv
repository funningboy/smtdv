
`ifndef __SMTDV_COMMON_SEQ_PKG_SV__
`define __SMTDV_COMMON_SEQ_PKG_SV__

`timescale 1ns/10ps

package smtdv_common_seq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  `include "smtdv_master_seqs_lib.sv"
  `include "smtdv_slave_seqs_lib.sv"
  `include "smtdv_master_vseqs_lib.sv"
  `include "smtdv_slave_vseqs_lib.sv"

endpackage : smtdv_common_seq_pkg


`endif // __SMTDV_COMMON_SEQ_PKG_SV__
