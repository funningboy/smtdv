/*------------------------------------------------------------------------- 
File name   : xbus_master_bfm.e
Title       : Master BFM
Project     : XBus UVC
Created     : 2008
Description : This file adds master functionality to the generic BFM.
Notes       : This is a proactive sequence driver
--------------------------------------------------------------------------- 
Copyright (c) 2008 Cadence Design Systems,Inc.
All rights reserved worldwide
-------------------------------------------------------------------------*/ 

<'

package cdn_xbus;



extend MASTER xbus_bfm_u {
    
    // testflow induced reset does not rerun the driver but might stop 
    // the bfm before it emitted item_done event to the driver. Since this 
    // causes an error, the following flag is needed to manually emit 
    // item_done in these cases.
    // Note: this is old code. Now item done that was not set
    //       is handled automatically by the Testflow domain manager
   //!item_done_not_set: bool;

    // testflow main methods are expected to be found in the top portion 
    // of the unit to better recognize the functional behavior of the unit
    
    // Run the main master BFM in MAIN_TEST phase.
//    tf_main_test() @tf_phase_clock is also {
    run() is also {
        message(LOW, "Master BFM started");
        msmp.sig_request$ = 0;
        start drive_transfers();
    }; -- tf_main_test()
        
    -- This is a pointer to the specific signals of the master
    !msmp : xbus_master_signal_map_u;

    -- This TCM drives the Arbitration Phase of a transfer.
    private arbitrate_for_bus() @synch.clock_rise is {
        msmp.sig_request$ = 1;
        wait true (msmp.sig_grant$ == 1);
        msmp.sig_request$ = 0;
    }; -- arbitrate_for_bus()
    
    -- This TCM drives the Address Phase of a transfer.
    private drive_address_phase(t : MASTER xbus_trans_s) @synch.clock_rise is {
        -- Drive the address phase signals
        smp.sig_addr$ = t.addr;
        smp.drive_size(t.size);
        smp.drive_read_write(t.read_write);
        wait cycle;
        -- now stop driving the address phase signals
        smp.sig_addr.put_mvl_string("32'bz");   
        smp.sig_size.put_mvl_string("2'bz");   
        smp.sig_read.put_mvl_string("1'bz");   
        smp.sig_write.put_mvl_string("1'bz");   
    }; -- drive_address_phase()
    
    -- This TCM handles one byte of the Data Phase of a read transfer. It 
    -- returns TRUE if an error occured on this byte.
    private read_byte(t : MASTER xbus_trans_s, i : uint) : 
                                     bool @synch.clock_rise is {
        wait cycle;
        sync @bus_monitor.data_valid;
        t.data[i] = smp.sig_data$;
        result = (smp.sig_error$ == 1);
    }; -- read_byte();

    -- This TCM handles one byte of the Data Phase of a write transfer. It
    -- returns TRUE if an error occured on this byte.
    private write_byte(t : MASTER xbus_trans_s, i : uint) : 
                                      bool @synch.clock_rise is {
        smp.sig_data$ = t.data[i];
        wait @bus_monitor.data_valid;
        result = (smp.sig_error$ == 1);
    }; -- write_byte();

    -- This TCM drives the Data Phase of a transfer.
    private drive_data_phase(t : MASTER xbus_trans_s) @synch.clock_rise is {
        var err : bool;
        for i from 0 to t.size-1 {
            if i == (t.size-1) {
                smp.sig_bip$ = 0;
            } else {
                smp.sig_bip$ = 1;            
            };
            case t.read_write {
                READ  : { err = read_byte(t, i); };
                WRITE : { err = write_byte(t, i); };
                default : { wait;}; 
            };
            if err {
                check err_sig_unexpected that 
                  (not t.check_error) or (t.error_pos_master == i)
                    else dut_error("ERR_UNEXPECTED_ERROR\n", 
                                   "Error signal was unexpectedly asserted");
                break
            } else {
                check no_err_sig 
                      that (not t.check_error) or (t.error_pos_master != i)
                    else dut_error("ERR_EXPECTED_ERROR_MISSING\n", 
                                   "Error signal assertion was expected ",
                                   "but did not occur");
            };
        };
        smp.sig_bip.put_mvl_string("1'bz");   
        smp.sig_data.put_mvl_string("8'bz");   
    }; -- drive_data_phase()
    
    -- This TCM drives all phases of a transfer.
    private drive_transfer(t : MASTER xbus_trans_s) @synch.clock_rise is {
        msg_started(MEDIUM, "Driving transfer", t);
        message(FULL, "Waiting for transmit delay of ", dec(t.transmit_delay), 
                      " cycles");
        wait [t.transmit_delay] * cycle;
        message(MEDIUM, "Transfer started: ", t);
        arbitrate_for_bus();
        message(HIGH, "Arbitration succeeded: ", t);
        drive_address_phase(t);
        message(HIGH, "Address Phase completed: ", t);
        drive_data_phase(t);
        message(HIGH, "Data Phase completed: ", t);
        msg_ended(MEDIUM, "Driving transfer", t);
    }; -- drive_transfer()

    -- This TCM continuously gets transfers from the driver and passes them
    -- to the BFM.
    private drive_transfers() @synch.clock_rise is {
        while TRUE {            
            var next_trans := driver.get_next_item();
            drive_transfer(next_trans);
            emit driver.item_done;
        }; 
    }; -- drive_transfers()    
}; -- extend MASTER xbus_bfm_u {

'>
