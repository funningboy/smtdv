
`ifndef __SMTDV_COMMON_PKG_SV__
`define __SMTDV_COMMON_PKG_SV__

`timescale 1ns/10ps

package smtdv_common_pkg;

  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;
  import smtdv_util_pkg::*;

  `include "smtdv_macros.svh"
  `include "smtdv_lib_typedefs.svh"
  `include "smtdv_about.svh"
  `include "smtdv_lib.sv"
  `include "graph/smtdv_lib_graph.sv"
  `include "model/smtdv_lib_model.sv"

//  `include "smtdv_cfg_label.sv"
//  `include "smtdv_force_vif_label.sv"
//  `include "smtdv_force_replay_label.sv"
endpackage : smtdv_common_pkg

`include "smtdv_vif.sv"
`include "smtdv_gen_rst_if.sv"

`endif // __SMTDV_COMMON_PKG_SV__
