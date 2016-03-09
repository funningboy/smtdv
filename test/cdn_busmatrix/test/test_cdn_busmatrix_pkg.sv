`ifndef __CDN_BUSMATRIX_TEST_PKG_SV__
`define __CDN_BUSMATRIX_TEST_PKG_SV__

`timescale 1ns/10ps

package test_cdn_busmatrix_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_util_pkg::*;
  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  `include "cdn_busmatrix_defines.svh"
  `include "cdn_busmatrix_macros.svh"

  import ahb_pkg::*;
  import ahb_seq_pkg::*;
  import ahb_vseq_pkg::*;

  import cdn_busmatrix_pkg::*;
  import cdn_busmatrix_vseq_pkg::*;

  `include "cdn_busmatrix_test_list.sv"

endpackage : test_cdn_busmatrix_pkg

`endif // end of __CDN_BUSMATRIX_TEST_PKG_SV__
