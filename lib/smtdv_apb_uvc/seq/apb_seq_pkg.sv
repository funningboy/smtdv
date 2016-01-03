
`ifndef __APB_SEQ_PKG_SV__
`define __APB_SEQ_PKG_SV__

`timescale 1ns/10ps

package apb_seq_pkg;

  `include "apb_defines.svh"

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_stl_pkg::*;
  import smtdv_sqlite3_pkg::*;

  import smtdv_common_pkg::*;
  import smtdv_common_seq_pkg::*;
  `include "smtdv_macros.svh"

  import apb_pkg::*;

  `include "apb_master_seqs_lib.sv"
  `include "apb_master_vseqs_lib.sv"
  `include "apb_slave_seqs_lib.sv"
  `include "apb_slave_vseqs_lib.sv"

endpackage : apb_seq_pkg

`endif // __APB_SEQ_PKG_SV__
