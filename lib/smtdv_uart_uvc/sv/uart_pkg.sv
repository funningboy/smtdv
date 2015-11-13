
`ifndef __UART_PKG_SV__
`define __UART_PKG_SV__

package uart_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  import smtdv_sqlite3_pkg::*;

  import smtdv_stl_pkg::*;

  `include "uart_typedefs.svh"
  `include "uart_item.sv"
  `include "uart_base_cfg.sv"

  `include "uart_monitor_threads.sv"
  `include "uart_monitor.sv"

  `include "uart_tx_cfg.sv"
  `include "uart_tx_driver_threads.sv"
  `include "uart_tx_driver.sv"
  `include "uart_tx_sequencer.sv"
  `include "../seq/uart_tx_seqs_lib.sv"
  `include "uart_tx_agent.sv"

  `include "uart_rx_cfg.sv"
  `include "uart_rx_driver_threads.sv"
  `include "uart_rx_driver.sv"
  `include "uart_rx_sequencer.sv"
  `include "../seq/uart_rx_seqs_lib.sv"
  `include "uart_rx_agent.sv"

  `include "uart_backdoor.sv"
  `include "uart_scordboard.sv"
  `include "uart_scordboard_threads.sv"
  `include "uart_env.sv"
endpackage

`include "uart_if.sv"

`endif // __UART_PKG_SV__
