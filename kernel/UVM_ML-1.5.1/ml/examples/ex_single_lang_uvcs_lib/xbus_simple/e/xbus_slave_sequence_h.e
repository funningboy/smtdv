/*------------------------------------------------------------------------- 
File name   : xbus_slave_sequence.e
Title       : Sequence interface for ACTIVE slave agents
Project     : XBus UVC
Created     : 2008
Description : This file provides a sequence interface for the slave.
Notes       : 
-------------------------------------------------------------------------*/ 

<'

package cdn_xbus;

-- This struct represents the response of a slave to a tranfer. It is used
-- as the item for the slave agent's sequence driver.
struct xbus_slave_response_s like any_sequence_item {

    -- This field holds the logical name of the physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;
        keep bus_name == read_only(driver.bus_name);    
   
    -- This field is used to sub-type the slave response struct according to
    -- which slave agent it is for. This field is automatically constrained 
    -- by the UVC and should not be constrained by the user.
    slave_name : xbus_agent_name_t;
        keep slave_name == read_only(driver.slave_name);

    -- This field is used to build up the transfer as it is received. This
    -- field is automatically constrained by the UVC and should not be
    -- constrained by the user.
    %transfer : MONITOR xbus_trans_s;    
        keep transfer == read_only(driver.transfer);
    
    -- This field controls the number of wait states for each byte of the
    -- transfer.
    wait_states : list of uint;
        keep wait_states.size() == read_only(transfer.size);
        keep for each in wait_states {
            soft it in [0..4]; -- by default up to four wait states
        };
    
    -- This field controls the byte position of an error. If no error is
    -- required, then it should be constrained to UNDEF.
    error_pos : int;
        keep error_pos < read_only(transfer.size);
        keep soft error_pos == UNDEF; -- by default, no errors
    
    -- Called by Structured Messages 
    get_attribute_value(name: string): string is {
     
        if transfer != NULL {
            if name == "read_write"  {
                result = append(transfer.read_write);
            };
            
            if name == "addr" {
                result = append(transfer.addr);
            };
        };  
    };
}; -- struct xbus_slave_response_s



-- This struct is the generic sequence for the slave agent sequence
-- interface.
sequence xbus_slave_sequence using
    item = xbus_slave_response_s,
    created_driver = xbus_slave_driver_u;

extend xbus_slave_sequence {

    -- This field holds the logical name of the physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;
        keep bus_name == read_only(driver.bus_name);    
   
    -- This field holds the logical name of the slave. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    slave_name : xbus_agent_name_t;
        keep slave_name == read_only(driver.slave_name);

    -- This is a utility field for basic sequences. This allows the user to
    -- do "do response ...".
    !response: xbus_slave_response_s;

    // Cover the sequence. 
    // Ignore the pre-defined kinds, they do not add info to the coverage
    cover ended is {
        item kind using ignore = (kind == RANDOM or
                                  kind == SIMPLE or
                                  kind == MAIN);
    }; 
}; -- extend xbus_slave_sequence



extend MAIN xbus_slave_sequence {
    -- The slave sequence driver is a reactive sequence driver so, by
    -- default we don't want it to ever run out of sequence items.
    keep soft count == MAX_UINT;

}; -- extend MAIN xbus_slave_sequence



-- Hook up the driver to the slave BFM
extend xbus_slave_driver_u {
    
    !synch : xbus_synchronizer_u;
    
    event clock is only @synch.unqualified_clock_rise;
        
    -- This field holds the logical name of the physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;
   
    -- This field holds the logical name of the slave. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    slave_name : xbus_agent_name_t;
    
    -- This field is where the slave BFM puts the detected transfer the slave
    -- needs to respond to immediately prior to calling try_next_item().
    package !transfer : MONITOR xbus_trans_s;

}; -- extend xbus_slave_driver_u

'>

