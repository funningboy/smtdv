//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
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
// Virtual sequence
sequence ubus_virt_seq using 
         created_driver = ubus_virtual_sequencer;

extend ubus_virt_seq {
   !ubus_sequence : ubus_master_sequence;
}; // extend ubus_vir...

extend ubus_virtual_sequencer {
   ubus_driver_0 : ubus_master_seqr_proxy;
   ubus_driver_1 : ubus_master_seqr_proxy;
   event clock is only @sys.any;
   
   get_sub_drivers(): list of any_sequence_driver is {
      return ({ubus_driver_0;ubus_driver_1});
   };
}; // extend ubus_vir...

   

'>
