//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
 import uvm_ml::*;

`include "ubus_pkg.sv"
import ubus_pkg::*;

`include "examples/dut_dummy.v"
`include "ubus_if.sv"
`include "ml_ubus_env.sv"

// Top module with dummy UBUS inside
module topmodule;
   ubus_if vif(); // SystemVerilog Interface
   
   dut_dummy dut(
		 vif.sig_request[0],
		 vif.sig_grant[0],
		 vif.sig_request[1],
		 vif.sig_grant[1],
		 vif.sig_clock,
		 vif.sig_reset,
		 vif.sig_addr,
		 vif.sig_size,
		 vif.sig_read,
		 vif.sig_write,
		 vif.sig_start,
		 vif.sig_bip,
		 vif.sig_data,
		 vif.sig_wait,
		 vif.sig_error
		 );
   
   // Set UBUS interface
   function int set_vif();
      uvm_config_db#(virtual ubus_if)::set(uvm_root::get(), "*", "vif", vif);
   endfunction
   initial begin
      static int set_vif_v = set_vif();
   end
   
   initial begin
      vif.sig_reset <= 1'b1;
      vif.sig_clock <= 1'b1;
      #51ns vif.sig_reset = 1'b0;
   end
   
   //Generate Clock
   always
     #5ns vif.sig_clock = ~vif.sig_clock;
   
`ifdef USE_UVM_ML_RUN_TEST
   initial begin
      string tops[1];
      tops[0] = "";
      uvm_ml_run_test(tops, "e:e/test.e");
   end
`endif
endmodule
