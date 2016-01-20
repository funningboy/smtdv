/*------------------------------------------------------------------------- 
File name   : xbus_protocol_checker.e
Title       : Protocol checker
Project     : XBus UVC
Created     : 2008
Description : This file implements the optional protocol checker.
Notes       : The protocol checker functionality is contained in the bus
            : and agent monitors units.
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



-- The following checks need to run through any reset preiod and so need
-- to be placed directly in the synchroniser. The bus_monitor gets rerun() on
-- reset and so these checks would not function correctly if placed in the
-- bus_monitor.
extend has_checks xbus_synchronizer_u {

    -- Reset must be asserted for at least 5 clocks at start of test
    -- (Spec section 2.3)
    expect short_reset_at_start is 
           @session.start_of_test => {[5] * not @reset_end}
                                                    @unqualified_clock_rise
        else dut_error("ERR_SHORT_RESET_AT_TEST_START\n",
                       "Reset was asserted for less than 5 ",
                       "clock cycles at start of test");

    -- Reset must be asserted for at least 3 clocks each time it is asserted
    -- (Spec section 2.3)
    expect short_reset_during_test is
           @reset_start => {[2] * not @reset_end} @unqualified_clock_rise
        else dut_error("ERR_SHORT_RESET_DURING_TEST\n",
                       "Reset was asserted for less than 3 clock cycles");
                       
}; -- extend has_checks xbus_synchronizer_u



-- The following checks need to be rerun() if reset is applied during the test.
-- They also need to be clocked with the qualified clocks as they do not apply
-- during reset.
extend has_checks xbus_bus_monitor_u {
    -- Start must not be asserted during Address Phase
    -- (Spec section 3)
    expect no_start_during_address is true(smp.sig_start$ == 0) @normal_address_phase
      else dut_error("ERR_START_DURING_ADDRESS_PHASE\n",
                       "Start was asserted during Address Phase");
    
    -- Start must not be asserted during Data Phase
    -- (Spec section 3)
    expect no_start_during_data is true(smp.sig_start$ == 0) @data_phase
      else dut_error("ERR_START_DURING_DATA_PHASE\n",
                       "Start was asserted during Data Phase");
                       
    -- Only one gnt line may be asserted at a time
    -- (Spec section 3)
    expect multiple_gnt is 
      true(msmps.count(.sig_grant$ == 1) <= 1) @arbitration_phase
        else dut_error("ERR_MULTIPLE_GNTS\n",
                       "Multiple gnt signals were asserted together");
                       
    -- Read and Write must not be asserted together
    expect read_and_write is
      true( (smp.sig_read.get_mvl() != MVL_1) or
            (smp.sig_write.get_mvl() != MVL_1)) @normal_address_phase
        else dut_error("ERR_READ_AND_WRITE\n",
                       "Both read and write signals were asserted together");
  
    
    -- Address must not be X or Z during Address Phase
    -- (Spec section 4)
    expect address_xz is
      true(!smp.sig_addr.has_x() and !smp.sig_addr.has_z()) @normal_address_phase
        else dut_error("ERR_ADDR_XZ\n",
                       "Address went to X or Z during Address Phase");
                       
    -- Size must not be X or Z during Address Phase
    -- (Spec section 4)
    expect size_xz is
      true(!smp.sig_size.has_x() and !smp.sig_size.has_z()) @normal_address_phase
        else dut_error("ERR_SIZE_XZ\n",
                       "Size went to X or Z during Address Phase");
                       
    -- Read must not be X or Z during Address Phase
    -- (Spec section 4)
    expect read_xz is
      true(!smp.sig_read.has_x() and !smp.sig_read.has_z()) @normal_address_phase
        else dut_error("ERR_READ_XZ\n",
                       "Read went to X or Z during Address Phase");
                       
    -- Write must not be X or Z during Address Phase
    -- (Spec section 4)
    expect write_xz is
      true(!smp.sig_write.has_x() and !smp.sig_write.has_z()) @normal_address_phase
        else dut_error("ERR_WRITE_XZ\n",
                       "Write went to X or Z during Address Phase");
                       
    -- Bip must not be X or Z during Data Phase
    -- (Spec section 5)
    expect bip_xz is
      true(!smp.sig_bip.has_x() and !smp.sig_bip.has_z()) @data_phase
        else dut_error("ERR_BIP_XZ\n",
                       "Bip went to X or Z during Data Phase");
                           

        -- Data must be valid when wait is de-asserted during the data 
    -- phase of a read.
    expect read_data_xz is
      true((!smp.sig_data.has_x() and !smp.sig_data.has_z()) or 
           (smp.sig_error$ == 1) or (transfer.read_write != READ)) @data_valid
        else dut_error("ERR_READ_DATA_XZ\n",
                       "Data went to X or Z while wait was low during read");


    -- Data must be valid throughout the data phase of a write.
    expect write_data_xz is
      true(synch.reset_asserted or 
           ((!smp.sig_data.has_x() and !smp.sig_data.has_z()) or 
            (transfer.read_write != WRITE))) @data_phase
        else dut_error("ERR_WRITE_DATA_XZ\n",
                       "Data went to X or Z during Data Phase of write");

    
    -- Wait must not be X or Z during Data Phase
    -- (Spec section 5)
    expect wait_xz is
      true((!smp.sig_wait.has_x() and !smp.sig_wait.has_z()) or 
           synch.reset_asserted) @data_phase
        else dut_error("ERR_WAIT_XZ\n",
                       "Wait went to X or Z during Data Phase");

    -- Error must not be X or Z during Data Phase
    -- (Spec section 5)
    expect error_xz is
      true((!smp.sig_error.has_x() and !smp.sig_error.has_z()) or 
           synch.reset_asserted) @data_phase
        else dut_error("ERR_ERROR_XZ\n",
                       "Error went to X or Z during Data Phase");
 
}; -- extend has_checks xbus_bus_monitor_u



'>
