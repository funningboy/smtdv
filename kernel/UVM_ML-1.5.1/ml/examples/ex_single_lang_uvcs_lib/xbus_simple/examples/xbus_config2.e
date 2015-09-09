<'

-- Import the XBus eVC
import xbus_simple/e/xbus_top;

import xbus_simple/e/xbus_port_config;

-- Create a logical name for the eVC instance. 
extend xbus_bus_name_t : [XBUS];

-- Instantiate the eVC under sys.
extend sys {
    xbus_evc : XBUS xbus_env_u is instance;
};

-- Create a logical name for each agent in the bus (including both ACTIVE and
-- PASSIVE agents).
extend xbus_agent_name_t : [MASTER_0, MASTER_1,
                            SLAVE_0, SLAVE_1, SLAVE_2];

-- Instantiate the agents under the eVC instance
extend XBUS xbus_env_u {
    keep hdl_path()     == "xbus_evc_demo";
    keep agent() == "NCSV";

    keep passive_master_names == {};
    keep active_master_names    == {MASTER_0;MASTER_1};
    keep passive_slave_names  == {};
    keep active_slave_names     == {SLAVE_0;SLAVE_1;SLAVE_2};
    
    -- This instance of the eVC has a protocol checker
    keep has_checks == TRUE;
};


-- Connect signal map ports to HDL signals for this instance of the eVC.
extend XBUS xbus_synchronizer_u {
    keep sig_clock.hdl_path() == "xbus_clock";
    keep sig_reset.hdl_path() == "xbus_reset";
};
extend XBUS xbus_signal_map_u {
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
extend XBUS MASTER_0 xbus_master_signal_map_u {
    keep sig_request.hdl_path() == "xbus_req_master_0";
    keep sig_grant.hdl_path()   == "xbus_gnt_master_0";
};

extend XBUS MASTER_1 xbus_master_signal_map_u {
    keep sig_request.hdl_path() == "xbus_req_master_1";
    keep sig_grant.hdl_path()   == "xbus_gnt_master_1";
};
-- Configure SLAVE_0
extend XBUS SLAVE_0 xbus_slave_config_u {
    -- This slave responds to address in the range [0x0000..0x7fff] inclusive
    keep params.min_addr == 0x0000;
    keep params.max_addr == 0x5554;
};
extend XBUS SLAVE_1 xbus_slave_config_u {
    -- This slave responds to address in the range [0x0000..0x7fff] inclusive
    keep params.min_addr == 0x5555;
    keep params.max_addr == 0xaaaa;
};
extend XBUS SLAVE_2 xbus_slave_config_u {
    -- This slave responds to address in the range [0x0000..0x7fff] inclusive
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

'>
