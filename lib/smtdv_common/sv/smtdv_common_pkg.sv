
`ifndef __SMTDV_COMMON_PKG_SV__
`define __SMTDV_COMMON_PKG_SV__

`timescale 1ns/10ps

package smtdv_common_pkg;

  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;

  `include "smtdv_macros.svh"
  `include "smtdv_lib_typedefs.svh"
  `include "smtdv_about.svh"
  `include "smtdv_lib.sv"
  `include "smtdv_generic_memory_cb.sv"
  `include "smtdv_generic_memory.sv"
  `include "smtdv_generic_fifo_cb.sv"
  `include "smtdv_generic_fifo.sv"
  `include "smtdv_ring_queue.sv"
//  `include "smtdv_cfg_label.sv"
//  `include "smtdv_force_vif_label.sv"
//  `include "smtdv_force_replay_label.sv"
//  `include "smtdv_multi2one_channels.sv"
//  `include "smtdv_one2multi_channels.sv"
  `include "smtdv_reset_model.sv"
  `include "smtdv_reset_monitor.sv"

  // smtdv_lowpower_model.sv
  // smtdv_jtag_model.sv
endpackage : smtdv_common_pkg

`include "smtdv_vif.sv"
`include "smtdv_gen_rst_if.sv"


`endif // __SMTDV_COMMON_PKG_SV__
