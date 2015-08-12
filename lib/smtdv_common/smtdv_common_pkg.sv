
`ifndef __SMTDV_PKG_SV__
`define __SMTDV_PKG_SV__

package smtdv_common_pkg;

  import  uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "smtdv_macros.svh"
  `include "smtdv_lib_typedefs.svh"
  `include "smtdv_lib.sv"
  `include "smtdv_generic_memory.sv"
  `include "smtdv_reset_model.sv"
  `include "smtdv_reset_monitor.sv"
  // smtdv_lowpower_model.sv
endpackage

`include "smtdv_gen_rst_if.sv"
`endif
