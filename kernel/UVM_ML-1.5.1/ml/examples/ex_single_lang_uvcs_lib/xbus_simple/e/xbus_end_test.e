/*-------------------------------------------------------------------------  
File name   : xbus_end_test.e
Title       : End of test stuff
Project     : XBus UVC
Created     : 2008
Description : This file handles 'end of test'.
Notes       : End of test handling is done using the objection mechanism.
            : Each proactive MAIN sequence (note that for XBus, only MASTER
            : sequences are proactive) raises an objection to TEST_DONE 
            : in ENV_SETUP phase, and drops the objection in POST_TEST phase
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



extend MAIN xbus_master_sequence {

    -- If this field is TRUE (the default), then an objection to TEST_DONE
    -- is raised for the duration of the MAIN sequence. If this field is FALSE
    -- then the MAIN sequence does not contribute to the determination of
    -- end-of-test.
    prevent_test_done : bool;
        keep soft prevent_test_done == TRUE;

    pre_body() @sys.any is first {
        if prevent_test_done {
            driver.raise_objection(TEST_DONE);
        };
    }; -- pre_body()

    -- This field is used to control the delay between the end of the MAIN
    -- sequence and the dropping of the objection to TEST_DONE - i.e. the
    -- time allowed for the last data to drain through the DUT. This is
    -- measured in clock cycles. 
    drain_time : uint;
        keep soft drain_time == 10;

    -- Drop the objection when the MAIN POST_TEST
    -- sequence ends.
    post_body() @sys.any is also {
        if prevent_test_done {
            wait [drain_time] * cycle @driver.clock;
            driver.drop_objection(TEST_DONE);
        };
    }; -- post_body()
    
}; -- extend MAIN POST_TEST xbus_master_sequence

'>
























    
