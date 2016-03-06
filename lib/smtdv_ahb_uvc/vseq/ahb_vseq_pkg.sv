
`ifndef __AHB_VSEQ_PKG_SV__
`define __AHB_VSEQ_PKG_SV__

`timescale 1ns/10ps

package ahb_vseq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_util_pkg::*;

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_common_seq_pkg::*;
  import smtdv_common_vseq_pkg::*;

  import ahb_pkg::*;
  import ahb_seq_pkg::*;

  `include "ahb_defines.svh"
  `include "ahb_virtual_sequencer.sv"
  `include "ahb_master_vseqs_lib.sv"
  `include "ahb_slave_vseqs_lib.sv"

endpackage : ahb_vseq_pkg

`endif // __AHB_VSEQ_PKG_SV__

