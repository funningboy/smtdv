
`ifndef __XBUS_PKG_SV__
`define __XBUS_PKG_SV__

package xbus_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_sqlite3_pkg::*;
  `include "smtdv_sqlite3_pkg.sv"

  import smtdv_stl_pkg::*;
  `include "smtdv_stl_pkg.sv"

  `include "xbus_typedefs.svh"
  `include "xbus_item.sv"

  `include "xbus_monitor_threads.sv"
  `include "xbus_monitor.sv"

  `include "xbus_master_cfg.sv"
  `include "xbus_master_driver_threads.sv"
  `include "xbus_master_driver.sv"
  `include "xbus_master_sequencer.sv"
  `include "seq/xbus_master_seqs_lib.sv"
  `include "xbus_master_agent.sv"

  `include "xbus_slave_cfg.sv"
  `include "xbus_slave_driver_threads.sv"
  `include "xbus_slave_driver.sv"
  `include "xbus_slave_sequencer.sv"
  `include "seq/xbus_slave_seqs_lib.sv"
  `include "xbus_slave_agent.sv"

endpackage

`include "xbus_if.sv"
`include "xbus_if_harness.sv"

`endif
