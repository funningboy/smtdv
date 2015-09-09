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


unit producer like uvm_bfm {
    get_port  : out interface_port of tlm_get of psi_word is instance;
       keep bind(get_port,external);
    put_port  : out interface_port of tlm_nonblocking_put of psi_word is instance;
       keep bind(put_port,external);
    
    run() is also {
        start drive();
    };
    
    !completed_counter : uint;    
    drive()@sys.any is {
       var ind: uint = 0;
       var res: bool;
       wait delay (100);
       var p : psi_word;
       gen p keeping {.combined[0].val == 10;.combined[0].pkt_data[0] == 17};
       get_port$.get(p);
       message(LOW, "Got packet = ", p);
       
       //gen p keeping {.combined[0].val == 10;};
       message(LOW, "Put packet = ", p);
       res = put_port$.try_put(p);
    };
    
    
   
};
'>