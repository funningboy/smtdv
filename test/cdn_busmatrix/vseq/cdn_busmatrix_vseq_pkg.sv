`ifndef __CDN_BUSMATRIX_VSEQ_PKG_SV__
`define __CDN_BUSMATRIX_VSEQ_PKG_SV__

`timescale 1ns/10ps

package cdn_busmatrix_vseq_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_util_pkg::*;
  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_common_seq_pkg::*;
  import smtdv_common_vseq_pkg::*;

  `include "ahb_macros.svh"
  import ahb_pkg::*;
  import ahb_seq_pkg::*;
  import ahb_vseq_pkg::*;

  import cdn_busmatrix_pkg::*;

  `include "cdn_busmatrix_defines.svh"
  `include "cdn_busmatrix_virtual_sequencer.sv"
  `include "cdn_busmatrix_master_vseqs_lib.sv"
  `include "cdn_busmatrix_slave_vseqs_lib.sv"

endpackage : cdn_busmatrix_vseq_pkg

`endif // __CDN_BUSMATRIX_VSEQ_PKG_SV__

