/*------------------------------------------------------------------------- 
File name   : xbus_bus_monitor.e
Title       : Bus monitor implementation
Project     : XBus UVC
Created     : 2008
Description : This file contains the bus monitor unit implementation
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

extend xbus_bus_monitor_u {
    -- The monitored transfer is built up in this field.
     package !transfer : MONITOR xbus_trans_s;

    !current_master_name : xbus_agent_name_t;
    !current_slave_name  : xbus_agent_name_t;

    -- This event is emitted by the monitor at the end of a transfer after
    -- it has finished filling in all the fields of the transfer field
    event transfer_end;
    
    // Configure the messages going to a file
    post_generate() is also {
        message_manager.set_file_messages(log_filename, me, XBUS_FILE, MEDIUM);
        message_manager.set_message_format(me, XBUS_FILE, {log_filename}, none, TRUE);
    };
    
    -- This method writes a header for use at the top of the bus log file.
    private write_log_header() is {
        -- Write date and time, filename etc. along with field headings
        message(XBUS_FILE, LOW, 
                append(log_filename, ".elog - created ", date_time()));
        message(XBUS_FILE, LOW, "");
        message(XBUS_FILE, LOW,
                "    TIME    MASTER      SLAVE       ",
                "ADDRESS SIZE R/W   DATA WAITS STATUS");
        message(XBUS_FILE, LOW,
                "    ****    ******      *****      ",
                "******* **** ***   **** ***** ******");
        message(XBUS_FILE, LOW, "");
    }; -- write_log_header()

    -- This field is used to ensure that the log file header is not rewritten
    -- if reset is reapplied during the test.
    private !log_header_written : bool; 
    
    -- If this is the beginning of the test, write a file log header. The
    -- log_header_written field is used to prevent the log header being
    -- written again if rerun() is called.
    run() is also {
        if not log_header_written {
            write_log_header();
            log_header_written = TRUE;
        };
        message(LOW, "Bus monitor started");
    }; -- run()
    
    -- This method returns the current status of the bus monitor.
    show_status() is {
        message(LOW, "Bus monitor detected ", dec(num_transfers), 
                " transfers");
    }; -- show_status()
    
    -- This method determines which slave is responsible for this address.
    find_slave_of_addr(addr : xbus_addr_t) : xbus_agent_name_t is {
        for each (config) in slave_configs {
            if config.in_range(addr) {
                result = config.slave.agent_name;
                break;
            };
        };
    };
    
    event start_rise is only rise(smp.sig_start$) @synch.clock_rise;
        
    -- This event is emitted at the rising edge of clock at the end of each arbitration Phase.
    event arb_ph1 is {@synch.reset_end; [3]} @synch.clock_rise;
    event arb_ph2 is {@nop_cycle or @data_end; [1]} @synch.clock_rise;
    -- This event is emitted at the rising edge of clock at the end of each arbitration Phase.
    event arbitration_phase is only (@arb_ph1 or @arb_ph2) @synch.clock_rise;
    
    -- This event is emitted at the rising edge of clock at the end of each
    -- Address Phase.
    event address_phase is only {@start_rise; [1]} @synch.clock_rise;
    
    -- This event is emitted at the rising edge of clock at the end of each NOP Address Phase.
    event nop_cycle is only true((smp.sig_read$ == 0) and (smp.sig_write$ ==0)) @address_phase;
    
    event read_normal_address_phase is
      true(smp.sig_read$ == 1 and !smp.sig_read.has_z()) @address_phase;
    event write_normal_address_phase is
      true(smp.sig_write$ == 1 and !smp.sig_write.has_z()) @address_phase;
  
    -- This event is emitted at the rising edge of clock at the end of each
    -- non-NOP Address Phase
    event normal_address_phase is only (@read_normal_address_phase or 
                                        @write_normal_address_phase)  @address_phase;
    
    -- This event is emitted at the rising edge of clock at the end of the
    -- first cycle of Data Phase.
    event data_start is only {@normal_address_phase; [1]} @synch.clock_rise;
    
    -- This event is emitted at the rising edge of clock at the end of the
    -- last cycle of the Data Phase. This event signifies that a transfer
    -- (not a NOP) has completed. At this stage the transfer field contains
    -- a record of the transfer that occurred.
    event data_end is only {@normal_address_phase; [..]; 
                            true((smp.sig_error$ == 1) or 
                                 (smp.sig_bip$ == 0 and smp.sig_wait$ == 0 ))
                           } @synch.clock_rise;
    
    -- This event is emitted at the rising edge of clock at the end of each
    -- cycle of Data Phase.
    event data_phase is only
        ({(@data_start and not @data_end); ~[..] * not @data_end} or 
         @data_end) @synch.clock_rise;
    
    -- This event is emitted each time a wait state is inserted on the bus.
    event wait_state is only true(smp.sig_wait$ == 1) @data_phase;
    
    -- This event is emitted each time a byte of data is valid on the bus.
    event data_valid is only true(smp.sig_wait$ == 0) @data_phase; 
        
    -- Collect information at the end of each arbitration phase.
    on arbitration_phase {
        monitor_arbitration_phase();
    };
    
    private monitor_arbitration_phase() is {
        for each (msmp) in msmps {
            if (msmp.sig_grant$ == 1) {
                current_master_name = msmp.master.agent_name;
                break;
            };
        };
    }; -- monitor_arbitration_phase()
    
    on normal_address_phase {
        monitor_address_phase();
    };
    
    private monitor_address_phase() is {
        -- create a new instance of a MONITOR xbus_tran_s;
        transfer = new MONITOR xbus_trans_s with { 
            it.addr = smp.sig_addr$;
            it.size = smp.get_size();
            it.read_write = smp.get_read_write();
            it.master_name = current_master_name;
        };
        transfer.waits.add(0);
        msg_started(HIGH, "Bus Collecting transfer", transfer);
    }; -- monitor_address_phase()    

        -- Count any wait states that get inserted.
    on wait_state {
        monitor_wait_state();
    };
    private monitor_wait_state() is {
        transfer.waits.push(transfer.waits.pop() +1);
    }; -- monitor_wait_state()

    on data_valid {
        monitor_data_byte();
    };
    -- This method captures a single data byte of the transfer and
    -- adds it to the data field of transfer.
    private monitor_data_byte() is {
        transfer.data.add(smp.sig_data$);
        if (smp.sig_error$ ==1) {
            transfer.error_pos_mon = transfer.data.size();
        } else {
            transfer.error_pos_mon = 0;
        };
        if (transfer.data.size() == transfer.size) or
           (transfer.error_pos_mon > 0) {
            -- determine which slave is responsible for this transfer.
            transfer.slave_name = find_slave_of_addr(transfer.addr);
            // collect coverage
            emit transfer_end;
            // Export to higher leyer component
            msg_ended(HIGH, "Bus Collecting transfer", transfer);
            // send to analysis port for checking
            transfer_ended_o$.write(transfer);
        } else {
            transfer.waits.add(0);
        };
    }; -- monitor_data_byte()
}; -- extend xbus_bus_monitor_u

'>


