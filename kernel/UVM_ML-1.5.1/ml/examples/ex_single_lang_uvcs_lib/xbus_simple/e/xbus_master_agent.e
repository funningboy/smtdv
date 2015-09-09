/*------------------------------------------------------------------------- 
File name   : xbus_master_agent.e
Title       : XBus Master Agent
Project     : UVM XBus UVC
Developers  :  
Created     : 2008
Description : 
Notes       : 
--------------------------------------------------------------------------- 
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
-------------------------------------------------------------------------*/ 
 
<'
package cdn_xbus;

-- The following code adds fields to the MASTER agent that define the
-- arbitration signals.
extend MASTER xbus_agent_u {
    -- This is the instance of the master signal map.
    msmp : xbus_master_signal_map_u is instance;
        keep msmp.bus_name == read_only(bus_name);
        keep msmp.master_name == read_only(agent_name);    
    connect_pointers() is also {
        msmp.master=me;
    };
}; -- extend MASTER xbus_agent_u



extend ACTIVE MASTER xbus_agent_u {
    // testflow main methods are expected to be found in the top portion of the
    // unit to better recognize the functional behavior of the unit
//    tf_reset() @tf_phase_clock is also {
//        reset_dut();
//    };
    
    reset_dut() @synch.unqualified_clock_rise is {
        synch.sig_reset$ = 1;
        wait[5];
        synch.sig_reset$ = 0;
        message(LOW, "reset end");
    };
    
    -- This is the sequence driver for an ACTIVE MASTER agent.
    driver: xbus_master_driver_u is instance;
        keep driver.bus_name == read_only(bus_name);
        keep driver.master_name == read_only(agent_name);

    -- This is the BFM for an ACTIVE MASTER agent.
    bfm : MASTER xbus_bfm_u is instance;

    connect_pointers() is also {
        driver.synch = synch;
        bfm.synch = synch;
        bfm.smp = smp;
        bfm.msmp = msmp;
        bfm.driver = driver;
    };
}; -- extend ACTIVE MASTER xbus_agent_u

'>
