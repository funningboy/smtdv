//----------------------------------------------------------------------
//   Copyright 2008-2010 Cadence Design Systems, Inc.
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

`include "xbus_trans.sv"
`include "sequencer_proxy.sv"
`include "xbus_virtual_sequencer.sv"

// the env component contains the proxy sequencer
class testbench extends uvm_env;
 //   xbus_proxy_t xbus_uvc_proxy;
    xbus_virtual_sequencer xbus_virt_seqr;
    uvm_component e_xbux_env_proxy;
   
   `uvm_component_utils(testbench)
   
   function new(string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(), $sformatf("testbench::new %s", get_full_name()), 
		UVM_LOW);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "testbench::build", UVM_LOW);
      xbus_virt_seqr = xbus_virtual_sequencer::type_id::create("xbus_virt_seqr", this);
      e_xbux_env_proxy = uvm_ml_create_component("e", "xbus_env_u", "xbus_uvc", this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      xbus_virt_seqr.seqr_proxy_0.connect_proxy(
						{e_xbux_env_proxy.get_full_name(), 
						 ".active_masters[0].ACTIVE'MASTER'driver.tlm_if."}); // for active agent 0
      xbus_virt_seqr.seqr_proxy_1.connect_proxy(
						{e_xbux_env_proxy.get_full_name(), 
						 ".active_masters[1].ACTIVE'MASTER'driver.tlm_if."}); // for active agent 1
   endfunction : connect_phase
   
endclass : testbench
