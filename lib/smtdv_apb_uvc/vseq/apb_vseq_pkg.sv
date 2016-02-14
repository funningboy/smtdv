`ifndef __APB_VSEQ_PKG_SV__
`define __APB_VSEQ_PKG_SV__

`timescale 1ns/10ps

package apb_vseq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_util_pkg::*;

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_common_seq_pkg::*;

  import apb_pkg::*;
  import apb_seq_pkg::*;

  `include "apb_defines.svh"
  `include "apb_virtual_sequencer.sv"
  `include "apb_master_vseqs_lib.sv"
  `include "apb_slave_vseqs_lib.sv"

endpackage : apb_vseq_pkg

`endif // __APB_VSEQ_PKG_SV__
