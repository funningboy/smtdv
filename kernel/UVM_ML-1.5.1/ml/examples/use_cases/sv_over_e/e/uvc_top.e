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

<'
package cdn_xbus;

-- import the eVC configuration file (which in turn imports the XBus eVC)
import xbus_config_2_masters;
import xbus_simple/e/xbus_basic_seq_lib;
import ml_sequencer;

////////////////////////////////////////////////

// example of bus monitor reporting bus transfers 
extend xbus_bus_monitor_u {
   
    //outport : out interface_port of tlm_analysis of (xbus_trans_s) is instance;
    //keep bind(outport,external);
   
    on transfer_end {
        message(LOW, "bus_monitor saw transfer sent from ",
                transfer.master_name, 
                " of length ", transfer.data.size(), 
                transfer.error_pos_mon == 0 ? "" : " and Error raised");
       print transfer;
       print transfer.data;

       //outport$.write(transfer);
    };
   
};

// macro to generate stub for e unit which is created under SV code
// uvm_ml_stub_unit uvm_test_top.tb.xbus_uvc using type="xbus_env_u", 
//   agent="SV", 
//   hdl_path="~/xbus_evc_demo";

'>

