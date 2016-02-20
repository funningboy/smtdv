`ifndef __APB_PKG_SV__
`define __APB_PKG_SV__

package apb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_sqlite3_pkg::*;
  import smtdv_stl_pkg::*;

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  // top level override
  `include "apb_typedefs.svh"
  `include "apb_sequence_item.sv"

  `include "apb_monitor_threads.sv"
  `include "apb_monitor.sv"

  `include "apb_master_cfg.sv"
  `include "apb_master_driver_threads.sv"
  `include "apb_master_driver.sv"
  `include "apb_master_sequencer.sv"
  `include "apb_master_agent.sv"

  `include "apb_slave_cfg.sv"
  `include "apb_slave_driver_threads.sv"
  `include "apb_slave_driver.sv"
  `include "apb_slave_sequencer.sv"
  `include "apb_slave_agent.sv"

  `include "apb_scoreboard.sv"
  `include "apb_reg_adapter.sv"

endpackage : apb_pkg

`include "apb_if.sv"

`endif // __APB_PKG_SV__
