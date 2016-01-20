/*-------------------------------------------------------------------------  
File name   : xbus_bfm.e
Title       : BFM unit declaration and implemenentation
Project     : XBus UVC
Created     : 2008
Description : This file is the declaration and implementation of the BFM unit.
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



-- This unit is the generic BFM and is used as the base type for all
-- BFMs (for masters, slaves and arbiters).
unit xbus_bfm_u like uvm_bfm {

    -- This field specifies whether this is a MASTER, SLAVE or ARBITER BFM?
    const kind : xbus_agent_kind_t;

    -- This field is a pointer to the bus monitor. Note that this field is set
    -- procedurally using connect_pointers().
    !bus_monitor : xbus_bus_monitor_u;

    -- This field is a pointer to the synchronizer.
    !synch : xbus_synchronizer_u;
    
    -- This field is a pointer to the bus signal map.
    !smp : xbus_signal_map_u;

}; -- unit xbus_bfm_u



extend MASTER xbus_bfm_u {

    -- This field is a pointer to the sequence driver in the master agent.
    !driver: xbus_master_driver_u;
//    event tf_phase_clock is only @synch.unqualified_clock_rise;

}; -- extend MASTER xbus_bfm_u



extend SLAVE xbus_bfm_u {

    -- This field is a pointer to the sequence driver in the slave agent.
    !driver: xbus_slave_driver_u;
//    event tf_phase_clock is only @synch.unqualified_clock_rise;

}; -- extend SLAVE xbus_bfm_u

'>


