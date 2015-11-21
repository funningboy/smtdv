
`ifndef __CDN_BUSMATRIX_TEST_LIST_SV__
`define __CDN_BUSMATRIX_TEST_LIST_SV__

  import smtdv_sqlite3_pkg::*;

`include "cdn_base_test.sv"
// one 2 one
`include "cdn_cpu_s0_2_dma_m0_test.sv"
// one 2 all
`include "cdn_cpu_s0_2_all_test.sv"

`endif // __CDN_BUSMATRIX_TEST_LIST_SV__

