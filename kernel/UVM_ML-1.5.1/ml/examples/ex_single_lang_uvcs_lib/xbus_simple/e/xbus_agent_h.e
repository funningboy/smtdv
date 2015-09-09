/*-------------------------------------------------------------------------  
File name   : xbus_agent_h.e
Title       : Agent unit declaration
Project     : XBus UVC
Created     : 2008
Description : This file declares the agent unit.
Notes       : 
-------------------------------------------------------------------------*/ 

<'

package cdn_xbus;
     
-- This unit is the base type for all agents (masters, slaves and arbiters)
-- that are connected to the bus.
unit xbus_agent_u like uvm_agent {    
    -- This field is the logical name of the bus the agent is connected to.
    -- This field is automatically constrained by the UVC and should not be
    -- constrained by the user.
    bus_name : xbus_bus_name_t;

    -- This field is the logical name of the agent. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    agent_name : xbus_agent_name_t;
    
    -- This field controls what sort of agent this is (MASTER, SLAVE or
    -- ARBITER). This field is automatically constrained by the UVC and should
    -- not be constrained by the user.
    const kind : xbus_agent_kind_t;

    -- This field is a pointer to the synchronizer.
    !synch : xbus_synchronizer_u;
    
    -- This field is a pointer to the bus signal map.
    !smp : xbus_signal_map_u;

    -- The short_name() method should return the name of this agent instance.
    short_name(): string is {
        result = append(agent_name);
    }; -- short_name()    
    
    // used for coverage collection
    package !transfer : MONITOR xbus_trans_s;
    mon_trans_ended_i : in interface_port of tlm_analysis of MONITOR xbus_trans_s is instance;
    keep bind (mon_trans_ended_i,empty);
    write(trans:MONITOR xbus_trans_s) is empty;
}; -- unit xbus_agent_u

extend xbus_master_signal_map_u {
    -- This field is a pointer to the MASTER agent that uses this signal map.
    !master : MASTER xbus_agent_u;
}; -- extend xbus_master_signal_map_u
'>

  Configuration 

<'
// the macro instantiates unit xserial_agent_config_u and struct 
// xserial_agent_config_params, in xserial_agent_u.
// In this example, xserial_agent_config_u xserial_agent_config_params have
// been defined earlier (in xbus_types_h.e)

uvm_build_config agent a SLAVE xbus_agent_u xbus_slave_config_u xbus_slave_params;


extend xbus_slave_config_u {
    !slave : SLAVE xbus_agent_u;
};

extend SLAVE xbus_agent_u {
    keep config.bus_name == read_only(bus_name);
    keep config.slave_name == read_only(agent_name);
    connect_pointers() is also {
        config.slave = me;
    };
};

extend xbus_slave_config_u {
    -- This method takes an address and returns TRUE if that address is within
    -- the range that this slave responds to (as defined by min_addr and
    -- max_addr).
    in_range(addr : xbus_addr_t) : bool is {
        result = (addr >= params.min_addr) and (addr <= params.max_addr);
    }; -- in_range()    
};
'>

