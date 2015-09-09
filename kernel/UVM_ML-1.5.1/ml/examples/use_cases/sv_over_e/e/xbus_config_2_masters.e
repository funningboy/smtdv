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

-- Import the XBus UVC
import xbus_simple/e/xbus_top;

import xbus_simple/e/xbus_port_config;

-- Create a logical name for the eVC instance. 
extend xbus_bus_name_t : [MY_XBUS];

-- Create a logical name for each agent in the bus (including both ACTIVE and
-- PASSIVE agents).
extend xbus_agent_name_t : [MASTER_0, MASTER_1,
                            SLAVE_0, SLAVE_1, SLAVE_2];

struct xbus_topology_config {
   %active_master_names : list of string;
   %passive_master_names: list of string;
   %active_slave_names  : list of string;
   %passive_slave_names : list of string;
};

-- Instantiate the agents under the eVC instance
extend MY_XBUS xbus_env_u {
    comp_agent: string;
    keep uvm_config_get(comp_agent);
    keep agent() == comp_agent;

    comp_hdl_path: string;
    keep uvm_config_get(comp_hdl_path); // "~/xbus_evc_demo"
    keep me.hdl_path()==comp_hdl_path;
   
    cfg_agents: xbus_topology_config;
    keep uvm_config_get(cfg_agents); // getting configuration set by the SV top
    keep passive_master_names == cfg_agents.passive_master_names.as_a(list of xbus_agent_name_t);
    keep active_master_names  == cfg_agents.active_master_names.as_a(list of xbus_agent_name_t);
    keep passive_slave_names  == cfg_agents.passive_slave_names.as_a(list of xbus_agent_name_t);
    keep active_slave_names   == cfg_agents.active_slave_names.as_a(list of xbus_agent_name_t);
   
    -- This instance of the eVC has a protocol checker
    keep has_checks == TRUE;
};


-- Connect signal map ports to HDL signals for this instance of the eVC.
extend MY_XBUS xbus_synchronizer_u {
    keep sig_clock.hdl_path() == "xbus_clock";
    keep sig_reset.hdl_path() == "xbus_reset";
};
extend xbus_signal_map_u {
    keep sig_start.hdl_path() == "xbus_start";
    keep sig_addr.hdl_path()  == "xbus_addr";
    keep sig_size.hdl_path()  == "xbus_size";
    keep sig_read.hdl_path()  == "xbus_read";
    keep sig_write.hdl_path() == "xbus_write";
    keep sig_bip.hdl_path()   == "xbus_bip";
    keep sig_wait.hdl_path()  == "xbus_wait";
    keep sig_error.hdl_path() == "xbus_error";
    keep sig_data.hdl_path()  == "xbus_data";  
};
extend MY_XBUS MASTER_0 xbus_master_signal_map_u {
    keep sig_request.hdl_path() == "xbus_req_master_0";
    keep sig_grant.hdl_path()   == "xbus_gnt_master_0";
};

extend MY_XBUS MASTER_1 xbus_master_signal_map_u {
    keep sig_request.hdl_path() == "xbus_req_master_1";
    keep sig_grant.hdl_path()   == "xbus_gnt_master_1";
};
-- Configure SLAVE_0
extend MY_XBUS SLAVE_0 xbus_slave_config_u {
    -- This slave responds to address in the range [0x0000..0x5554] inclusive
    keep params.min_addr == 0x0000;
    keep params.max_addr == 0x5554;
};
extend MY_XBUS SLAVE_1 xbus_slave_config_u {
    -- This slave responds to address in the range [0x5555..0xaaaa] inclusive
    keep params.min_addr == 0x5555;
    keep params.max_addr == 0xaaaa;
};
extend MY_XBUS SLAVE_2 xbus_slave_config_u {
    -- This slave responds to address in the range [0xaaab..0xffff] inclusive
    keep params.min_addr == 0xaaab;
    keep params.max_addr == 0xffff;
};


-- Turn on logging for all agents and for whole bus. Use agent and env names
-- for log filenames.
extend xbus_bus_monitor_u {
    keep log_filename == append(bus_name);
};

extend sys {
    setup() is also {
        set_config(print, radix, hex);
    };
    init() is also {
        // Use a performance enhancement feature
        set_config(simulation, enable_ports_unification, TRUE);   
    };
};

extend uvm_ml_config {
    tlm_pass_field(f:rf_field) : bool is also {
        if ( f.get_declaring_struct().get_name() == "xbus_trans_s" ) {
            var n : string = f.get_name();
            if (n == "kind" or n == "size") {return TRUE;};
        };
        if ( f.get_declaring_struct().get_name() == "MASTER'kind xbus_trans_s" ) {
            var n : string = f.get_name();
            if (n == "wait_states" or 
                n == "error_pos_master" or 
                n == "transmit_delay") {return TRUE;};
        };
    };
};

'>
