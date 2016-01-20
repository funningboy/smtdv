
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

import uvm_pkg::*;
`include "uvm_macros.svh"
 import uvm_ml::*;
`include "sv/env.sv"
//`include "sv/seq_lib.sv"
//`include "sv/xbus_virtual_sequencer.sv"

  class xbus_topology_config extends uvm_object;
    string active_master_names[];
    string passive_master_names[];
    string active_slave_names[];
    string passive_slave_names[];

    `uvm_object_utils_begin(xbus_topology_config)
      `uvm_field_array_string(active_master_names, UVM_ALL_ON)
      `uvm_field_array_string(passive_master_names, UVM_ALL_ON)
      `uvm_field_array_string(active_slave_names, UVM_ALL_ON)
      `uvm_field_array_string(passive_slave_names, UVM_ALL_ON)
    `uvm_object_utils_end

   function new(string name = "xbus_topology_config");
     super.new(name);
   endfunction
  endclass

  // The test component
  class svtop extends uvm_test;
    testbench tb;

    function new (string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(), $sformatf("svtop::new %s", get_full_name()), UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
      xbus_topology_config cfg_agents = new;
      super.build_phase(phase);
      
      cfg_agents.active_master_names = new[2];
      cfg_agents.active_master_names[0] = "MASTER_0";
      cfg_agents.active_master_names[1] = "MASTER_1";
      cfg_agents.passive_master_names = new[0];      
      cfg_agents.active_slave_names = new[3];
      cfg_agents.active_slave_names[0] = "SLAVE_0";
      cfg_agents.active_slave_names[1] = "SLAVE_1";
      cfg_agents.active_slave_names[2] = "SLAVE_2";
      cfg_agents.passive_slave_names = new[0];
      
      `uvm_info(get_type_name(), $sformatf("svtop::build %s", get_full_name()), UVM_LOW);

       // Setting HDL path and agent to the e uvc for the stub creation phase
      uvm_config_string::set(this,"*xbus_uvc","comp_hdl_path", "~/xbus_evc_demo");
      uvm_config_string::set(this,"*xbus_uvc","comp_agent", "SV");
        // Setting Configuration for the e xbux uvc
      uvm_config_object::set(this,"*xbus_uvc","cfg_agents", cfg_agents);

      // configure main sequence
       uvm_config_wrapper::set(this,
			       "tb.xbus_virt_seqr.run_phase",
			       "default_sequence",
			       xbus_virt_seq::type_id::get());
       
      // create local SV env
      tb = testbench::type_id::create("tb", this);
    endfunction

    `uvm_component_utils(svtop)

  endclass

module topmodule;
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[1];   
   tops[0] = "";   
   uvm_ml_run_test(tops, "SV:svtop");
end
`endif
endmodule
