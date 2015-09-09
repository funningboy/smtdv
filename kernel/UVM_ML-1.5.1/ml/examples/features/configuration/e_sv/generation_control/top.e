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

type trans_size : [SHORT_TRANSACTION = 0, LONG_TRANSACTION = 1];
//import packet.e;

unit testbench {
   // Foreign (SV) child
   uvc_top: child_component_proxy is instance;
      keep uvc_top.type_name == "SV:ml_env";
   size: trans_size;
   keep size == SHORT_TRANSACTION;
   keep uvm_config_set("*", "transfer_kind", size.as_a(int));

   run() is also {
      start drive();
   };
   
   drive()@sys.any is {
      wait delay (10 ns);       
   }; // drive()@sys.any...
   
}; // unit testbench

extend sys {
   testbench is instance;
};

'>
