/*-------------------------------------------------------------------------  
File name   : xbus_env_h.e
Title       : Declaration of top level env unit for UVC
Project     : XBus UVC
Created     : 2008
Description : This file declares the env unit.
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
------------------------------------------------------------------------*/ 

<'

package cdn_xbus;

-- This unit is the top level of the UVC. There should be one instance
-- of this unit for each XBus bus in the DUT.
unit xbus_env_u like uvm_env {

//    event tf_phase_clock is only @synch.unqualified_clock_rise;

    -- This field holds the logical name of this physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;

    -- This field is the instance of the synchronization unit.
    synch : xbus_synchronizer_u is instance;
      keep synch.bus_name == read_only(bus_name);

    -- This field is the instance of the signal map unit. This unit holds all
    -- the ports that connect to common bus signals.
    smp : xbus_signal_map_u is instance;
      keep smp.bus_name == read_only(bus_name);

    -- This field controls all protocol checkers in the UVC. If it is TRUE
    -- then protocol checking is turned on. By default, checking in each
    -- part of the UVC is constrained to match this flag. However, individual
    -- flags are provided at various parts of the UVC that can be seperately
    -- constrained to provide finer grain control.
    has_checks : bool;
    keep soft has_checks == TRUE;

    -- This field holds a list of the logical names of all active masters
    -- contained by the env. The user should constrain this field to create
    -- all the active masters required as part of the configuration file. The
    -- field active_masters is automatically constrained according to the
    -- contents of this field. If left unconstrained, this list will default
    -- to being empty.
    active_master_names : list of xbus_agent_name_t;
    keep soft active_master_names.size() == 0;
        
    -- This field holds a list of the logical names of all passive masters
    -- contained by the env. The user should constrain this field to create
    -- all the passive masters required as part of the configuration file. The
    -- field passive_masters is automatically constrained according to the
    -- contents of this field. If left unconstrained, this list will default
    -- to being empty.
    passive_master_names : list of xbus_agent_name_t;
    keep soft passive_master_names.size() == 0;
        
    -- This field holds a list of the logical names of all active slaves
    -- contained by the env. The user should constrain this field to create
    -- all the active slaves required as part of the configuration file. The
    -- field active_slaves is automatically constrained according to the
    -- contents of this field. If left unconstrained, this list will default
    -- to being empty.
    active_slave_names : list of xbus_agent_name_t;
    keep soft active_slave_names.size() == 0;

    -- This field holds a list of the logical names of all passive slaves
    -- contained by the env. The user should constrain this field to create
    -- all the passive slaves required as part of the configuration file. The
    -- field passive_slaves is automatically constrained according to the
    -- contents of this field. If left unconstrained, this list will default
    -- to being empty.
    passive_slave_names : list of xbus_agent_name_t;
    keep soft passive_slave_names.size() == 0;
    
    -- This field is the instance of the bus monitor.
    bus_monitor : xbus_bus_monitor_u is instance;

    -- This field contains a list of all the active master agents in the env.
    -- The user should not constrain this field, but should instead constrain
    -- the field active_master_names.
    active_masters : list of ACTIVE MASTER xbus_agent_u is instance;
        keep active_masters.size() == read_only(active_master_names.size());
        keep for each (master) in active_masters {
            master.bus_name == read_only(bus_name);
            master.agent_name == read_only(active_master_names[index]);
        };

    -- This field contains a list of all the passive master agents in the env.
    -- The user should not constrain this field, but should instead constrain
    -- the field passive_master_names.
    passive_masters : list of PASSIVE MASTER xbus_agent_u is instance;
        keep passive_masters.size() == read_only(passive_master_names.size());
        keep for each (master) in passive_masters {
            master.bus_name == read_only(bus_name);
            master.agent_name == read_only(passive_master_names[index]);
        };

    -- This field contains a list of all the active slave agents in the env.
    -- The user should not constrain this field, but should instead constrain
    -- the field active_slave_names.
    active_slaves : list of ACTIVE SLAVE xbus_agent_u is instance;
        keep active_slaves.size() == read_only(active_slave_names.size());
        keep for each (slave) in active_slaves {
            slave.bus_name == read_only(bus_name);
            slave.agent_name == read_only(active_slave_names[index]);
        };

    -- This field contains a list of all the passive slave agents in the env.
    -- The user should not constrain this field, but should instead constrain
    -- the field passive_slave_names.
    passive_slaves : list of PASSIVE SLAVE xbus_agent_u is instance;
        keep passive_slaves.size() == read_only(passive_slave_names.size());
        keep for each (slave) in passive_slaves {
            slave.bus_name == read_only(bus_name);
            slave.agent_name == read_only(passive_slave_names[index]);
        };

    -- This field contains a list of all the masters (both active and passive)
    -- in the env.
    masters : list of MASTER xbus_agent_u;
        keep masters == read_only({passive_masters; active_masters});

    -- This field contains a list of all the slaves (both active and passive)
    -- in the env.
    slaves : list of SLAVE xbus_agent_u;
        keep slaves == read_only({passive_slaves; active_slaves});

}; -- unit xbus_env_u

// CONFIGURATION:
// --------------

// the macro defines xbus_env_config_u and xbus_env_config_params_s, 
// and instantiates them in xbus_env_u.
uvm_build_config env xbus_env_u xbus_env_config_u xbus_env_config_params_s;

// parameters to user, for changing configuration during the run
extend xbus_env_config_params_s {
    slave_name : xbus_agent_name_t;
    min_addr   : xbus_addr_t;
    max_addr   : xbus_addr_t;
};



'>
