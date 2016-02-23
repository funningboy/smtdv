
`ifndef __CDN_BUSMATRIX_PKG_SV__
`define __CDN_BUSMATRIX_PKG_SV__

`timescale 1ns/10ps

package cdn_busmatrix_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;

  `include "ahb_macros.svh"
  import ahb_pkg::*;
  import ahb_seq_pkg::*;
  import ahb_vseq_pkg::*;

  `include "cdn_typedefs.svh"

  `include "cdn_dma_m0.sv"
  `include "cdn_cpu_m1.sv"

  `include "cdn_tcm_s0.sv"
  `include "cdn_sram_s1.sv"
  `include "cdn_busmatrix_env.sv"

endpackage : cdn_busmatrix_pkg

`endif // __CDN_BUSMATRIX_PKG_SV__
