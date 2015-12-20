`ifndef __SMTDV_TEST_LIST_SV__
`define __SMTDV_TEST_LIST_SV__

`timescale 1ns/10ps

package test_smtdv_common_pkg;

  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

`include "../seq/smtdv_master_test_seq.sv"
`include "../seq/smtdv_slave_test_seq.sv"
`include "smtdv_base_unittest.sv"
`include "smtdv_base_test.sv"

endpackage

`endif // end of __SMTDV_TEST_LIST_SV__
