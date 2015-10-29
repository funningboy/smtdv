
`ifndef __CDN_BUSMATRIX_PKG_SV__
`define __CDN_BUSMATRIX_PKG_SV__

package cdn_busmatrix_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_sqlite3_pkg::*;

  import smtdv_stl_pkg::*;

  import ahb_pkg::*;
  //import apb_pkg::*;
  //import ocp_pkg::*;

  `include "cdn_typedefs.svh"

  `include "cdn_dma_m0.sv"
  `include "cdn_cpu_m1.sv"
  `include "cdn_macb0_m2.sv"
  `include "cdn_macb1_m3.sv"
  `include "cdn_macb2_m4.sv"
  `include "cdn_macb3_m5.sv"

  `include "cdn_cpu_s0.sv"
  `include "cdn_sram_s1.sv"
  `include "cdn_rom_s2.sv"
  `include "cdn_ahb2apb0_s3.sv"
  `include "cdn_smc_s4.sv"
  `include "cdn_dma_s5.sv"
  `include "cdn_ahb2apb1_s6.sv"
  // s7???
  `include "cdn_ahb2ocp_s8.sv"

  //`include "cdn_busmatrix_env.sv"
endpackage

`endif // __CDN_BUSMATRIX_PKG_SV__
