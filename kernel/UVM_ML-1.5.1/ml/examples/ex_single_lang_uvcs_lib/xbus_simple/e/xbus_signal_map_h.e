/*-------------------------------------------------------------------------   
File name   : xbus_signal_map_h.e
Title       : Declaration of signal maps
Project     : XBus UVC
Created     : 2008
Description : This file declares the signal maps required for the UVC.
Notes       : 
--------------------------------------------------------------------------- 
*/

<'
package cdn_xbus;

-- This unit holds the clock and reset signals.
unit xbus_synchronizer_u like uvm_signal_map {

    -- This field holds the bus logical name
    bus_name : xbus_bus_name_t;

   -- This port connects the UVC to the CLOCK signal.
    sig_clock : in simple_port of bit is instance;
    
    -- This port connects the UVC to the RESET signal.
    sig_reset : simple_port of bit is instance;

    -- If this field is TRUE then the checks in the synchroniser are enabled.
    -- This field is normally controlled by the main field of the same
    -- name in the env, but the user can override this.
    has_checks : bool;

    -- This event is the clock change event, the base of the rise/fall clocks.
    -- Note that this is the only event in the UVC that is sampled @sim.
    event unqualified_clock_change is change(sig_clock$) @sim;

    -- This event is the clock rise event prior to qualification with reset.
    event unqualified_clock_rise is true(sig_clock$==1) @unqualified_clock_change;
   
    -- This event is the rising edge of the bus clock, qualified by reset.
    event clock_rise is true(not reset_asserted) @unqualified_clock_rise;
    //event clock_rise is @unqualified_clock_rise using exclusive_start @reset_end, stop @reset_start;
       
   -- This event gets emitted each time the reset signal changes state.
    event reset_change is change(sig_reset$) @unqualified_clock_change; 

    -- This event gets emitted when reset is asserted.
    event reset_start is
        true((not reset_asserted) and sig_reset$ == 1) @reset_change;
    
    -- This event gets emitted when reset is de-asserted.
    event reset_end is 
        true(reset_asserted and sig_reset$ ==0) @reset_change;
    
    -- This field is used to keep track of the current reset state. By
    -- default reset is assumed to be asserted at the start of the test.
    -- The user should not normally need to constrain this field.
    reset_asserted : bool;
        keep soft reset_asserted == TRUE;
    
    -- This code ensures that reset_asserted tracks the reset signal.
    on reset_start { reset_asserted = TRUE; };
    on reset_end   { reset_asserted = FALSE;};

}; -- unit xbus_synchronizer_u
'>

<'
-- This unit is the signal map for the common bus signals - i.e. those not
-- replicated per master.
unit xbus_signal_map_u like uvm_signal_map {

    -- This field holds the logical name of this physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;
    
    -- The following ports represent all the common bus signals
    -- This port connects the UVC to the START signal.
    sig_start : inout simple_port of bit is instance;
    
    -- This port connects the UVC to the ADDR signal.
    sig_addr : inout simple_port of xbus_addr_t is instance;
    
    -- This port connects the UVC to the SIZE signal.
    sig_size : inout simple_port of uint(bits:2) is instance;
    
    -- This port connects the UVC to the READ signal.
    sig_read : inout simple_port of bit is instance;
    
    -- This port connects the UVC to the WRITE signal.
    sig_write : inout simple_port of bit is instance;
    
    -- This port connects the UVC to the BIP signal.
    sig_bip : inout simple_port of bit is instance;
    
    -- This port connects the UVC to the WAIT signal.
    sig_wait : inout simple_port of bit is instance;
    
    -- This port connects the UVC to the ERROR signal.
    sig_error : inout simple_port of bit is instance;
    
    -- This port connects the UVC to the DATA signal.
    sig_data : inout simple_port of byte is instance;

    -- This method takes the size of a transfer in bytes and drives the
    -- SIZE signals appropriately.
    package drive_size(size_in_bytes : uint) is {
        case size_in_bytes {
            1 : { sig_size$ = 0b00; };
            2 : { sig_size$ = 0b01; };
            4 : { sig_size$ = 0b10; };
            8 : { sig_size$ = 0b11; };
        };
    }; -- drive_size()

    -- This method takes the read/write status of a transfer in
    -- enumerated form and drives the bus READ and WRITE signals
    -- appropriately.
    package drive_read_write(rw : xbus_read_write_t) is {
        case rw {
            NOP   : { sig_read$ = 0; sig_write$ = 0; };
            READ  : { sig_read$ = 1; sig_write$ = 0; };
            WRITE : { sig_read$ = 0; sig_write$ = 1; };
        };
    }; -- drive_read_write()

    -- This method samples the SIZE signals and returns the number
    -- of bytes for the transfer.
    package get_size() : uint is {
        case sig_size$ {
            2'b00 : { result = 1; };
            2'b01 : { result = 2; };
            2'b10 : { result = 4; };
            2'b11 : { result = 8; };
        };
    }; -- get_size()

    -- This method samples the READ and WRITE signals and returns
    -- the appropriate enumerated value. Note that it is assumed that this
    -- method will only be called when the use of these signals is legal 
    -- (i.e. either a READ, WRITE or a NOP is in progress). Protocol checking
    -- is done elsewhere.
    package get_read_write() : xbus_read_write_t is {
        case {
            ((sig_read$ == 1) and (sig_write$ ==0)) : { result = READ; };
            ((sig_read$ == 0) and (sig_write$ ==1)) : { result = WRITE; };
            ((sig_read$ == 0) and (sig_write$ ==0)) : { result = NOP; };
            default : { 
                message(FULL, "Both READ and WRITE signals were asserted simultaneously");
               result = NOP; 
            };
        };
    }; -- get_read_write()

}; -- unit xbus_signal_map_u

'>
 
<'

-- This unit is the signal map for the signals specific to a particular master.
unit xbus_master_signal_map_u like uvm_signal_map {

    -- This field holds the logical name of this physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;
   
-- This field holds the name of master which this signal map belongs to.
    -- This field is automatically constrained by the UVC and should not be
    -- constrained by the user.
    master_name : xbus_agent_name_t;
    
    -- This port connects the UVC to the GRANT signal for this master.
    sig_grant : in simple_port of bit is instance;

    -- This port connects the UVC to the REQUEST signal for this master.
    sig_request : inout simple_port of bit is instance;
    

}; -- unit xbus_master_signal_map_u

'>
    -- This event is the clock fall event prior to qualification with reset.
    event unqualified_clock_fall;

    on unqualified_clock_change {
       if (sig_clock$ == 0) then {
          emit unqualified_clock_fall;
       } else {
          emit unqualified_clock_rise;
       };
    }; -- on unqualified_clock_change
