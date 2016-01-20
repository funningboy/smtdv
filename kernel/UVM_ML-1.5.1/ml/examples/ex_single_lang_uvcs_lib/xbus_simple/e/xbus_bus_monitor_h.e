/*-------------------------------------------------------------------------  
File name   : xbus_bus_monitor_h.e
Title       : Bus monitor declaration
Project     : XBus UVC
Created     : 2008
Description : This file declares the bus monitor unit.
Notes       : The bus collector collects all activity on the bus and collects
            : information on each transfer that occurs.
            : It passes the collected info, after basic processing, to the
            : monitor.
            : The monitor performs higher level process, coverage and checks
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
'>


===================================
           Monitor
===================================

<'
extend message_tag: [XBUS_FILE];

-- This unit is the Bus Monitor. The Bus Monitor gets the information from 
-- the collector, performs coverage and checks, and export information to
-- other components via ports.
unit xbus_bus_monitor_u like uvm_monitor {
    
//    collector : xbus_bus_collector_u is instance;
//      keep collector.has_checks == value(has_checks);
    
    // Belong to the XBUS_TF TestFlow domain
//    event tf_phase_clock is only @synch.unqualified_clock_rise;
    
    -- This field holds the logical name of the bus containing this bus
    -- monitor. This field is automatically constrained by the UVC and should
    -- not be constrained by the user.
    bus_name : xbus_bus_name_t;
    
    -- This field is a pointer to the synchronizer.
    const !synch : xbus_synchronizer_u;
    
    -- This field is a pointer to the bus signal map.
    !smp : xbus_signal_map_u;

    -- This is a list of pointers to the master signal maps.
    !msmps : list of xbus_master_signal_map_u;

    -- This is a list of pointers to the slave configuration units.
    !slave_configs : list of xbus_slave_config_u;
    
    -- If this field is TRUE then the bus monitor performs protocol checking.
    -- This field is normally controlled by the main field of the same
    -- name in the env, but the user can override this for the bus monitor.
    has_checks : bool;

    -- If this field is not "" then the bus monitor writes a log file of that
    -- name (with a ".elog" extension). By default, the filename is "xbus.elog".
    log_filename : string;
        keep soft log_filename == "xbus";
    
    -- This field is used to count the total number of transfers monitored
    -- during the test.
    !num_transfers : uint;

    -- This method port is the scoreboard hook for the bus monitor. This
    -- method port will be called at the completion of each transfer on the
    -- bus. Note that the scoreboard hook is bound to empty so that no error
    -- is issued if the hook is not in use.
    transfer_ended_o : out interface_port of tlm_analysis of MONITOR xbus_trans_s is instance;
    keep bind (transfer_ended_o, empty);

    -- This event is the rising edge of the START signal.
    event start_rise;

    -- This event is emitted at the rising edge of clock at the end of each
    -- Arbitration Phase.
    event arbitration_phase;
    
    -- This event is emitted at the rising edge of clock at the end of each
    -- Address Phase.
    event address_phase;
    
    -- This event is emitted at the rising edge of clock at the end of each
    -- NOP Address Phase.
    event nop_cycle;
    
    -- This event is emitted at the rising edge of clock at the end of each
    -- non-NOP Address Phase
    event normal_address_phase;
    
    -- This event is emitted at the rising edge of clock at the end of the
    -- first cycle of Data Phase.
    event data_start;
    

    -- This event is emitted at the rising edge of clock at the end of the
    -- last cycle of the Data Phase. This event signifies that a transfer
    -- (not a NOP) has completed. At this stage the transfer field contains
    -- a record of the transfer that occurred.
    event data_end;
    
    -- This event is emitted at the rising edge of clock at the end of each
    -- cycle of Data Phase.
    event data_phase;
    
    -- This event is emitted each time a wait state is inserted on the bus.
    event wait_state;
    
    -- This event is emitted each time a byte of data is valid on the bus.
    event data_valid;
    
}; -- unit xbus_bus_monitor_u

-- This code adds fields and methods to the transfer struct for use by the
-- monitor to collect and log extra information.
extend MONITOR xbus_trans_s {

    -- This field is used by the monitor to collect the actual number of waits
    -- states for each byte of the transfer.
    !waits : list of uint;
    
    -- This field is used by the monitor to log the position of any error. A
    -- 0 value means no error occurred.
    !error_pos_mon : uint;

}; -- extend MONITOR xbus_trans_s
'>




















