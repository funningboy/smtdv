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
    sv_put_port   : out interface_port of tlm_blocking_put of packet is instance;
       keep bind(sv_put_port,external);
    sv_nb_put_port: out interface_port of tlm_nonblocking_put of packet is instance;
       keep bind(sv_nb_put_port,external);

    run() is also {
        start drive();
    };
    
    drive()@sys.any is {
       var ind: uint = 1;
       
       wait delay(10 ns);
       out("\n*** Starting non-blocking TLM1 transactions from e to SV");
       for i from 1 to 3 {
          var p : packet;
          gen p keeping {.data == 17+i};
          message(LOW, "Sending  packet = ", p);
          var res := sv_nb_put_port$.try_put(p);
          wait delay(10 ns);
       };
             
       out("\n*** Starting blocking TLM1 transactions from e to SV");
       for i from 4 to 6 {
          var p : packet;
          gen p keeping {.data == 17+i};
          message(LOW, "Sending  packet = ", p);
          sv_put_port$.put(p);
          wait delay(9 ns);
       };
       
    };
    
};
'>