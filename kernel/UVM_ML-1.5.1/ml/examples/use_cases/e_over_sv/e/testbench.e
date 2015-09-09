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

<'
import uvm_e/e/uvm_e_top.e;
import ubus_exported; // manual type mapping
import ubus_master_seq;
import ubus_virtual_sequencer;

// Proxy component for the UBUS VIP
// contains the sequencer proxy and the foreign UBUS child component 
unit ubus_env like uvm_env {
   env_sequencer_0 : ubus_master_seqr_proxy is instance;
   env_sequencer_1 : ubus_master_seqr_proxy is instance;
   
   // Foreign (SV) child
   uvc_env: child_component_proxy is instance;
   keep uvc_env.type_name== "SV:ml_ubus_env";
   
   connect_ports() is also {
      env_sequencer_0.connect_proxy(append(e_path(),
       ".uvc_env.masters[0].sequencer.seqr_tlm_if"));
      env_sequencer_1.connect_proxy(append(e_path(),
       ".uvc_env.masters[1].sequencer.seqr_tlm_if"));
   };
}; // unit ubus_env


// Top level environment contains the virtual sequencer
unit testbench like uvm_env {
   ubus_seqr : ubus_virtual_sequencer is instance;
     keep ubus_seqr.ubus_driver_0 == ubus_env.env_sequencer_0;
     keep ubus_seqr.ubus_driver_1 == ubus_env.env_sequencer_1;
   ubus_env is instance;
     keep agent() == "SV";
}; // unit testbench


extend sys {
   testbench is instance;
};

'>
