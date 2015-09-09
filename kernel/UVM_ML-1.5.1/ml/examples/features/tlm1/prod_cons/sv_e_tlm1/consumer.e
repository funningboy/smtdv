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
unit consumer {
    b_put_in_port : in interface_port of tlm_put of packet 
      using prefix=sv_ is instance;
      keep bind(b_put_in_port,external);
    nb_put_in_port: in interface_port of tlm_put of packet 
      using prefix=sv_ is instance;
      keep bind(nb_put_in_port,external);
    save: list of int;
   
   connect_ports() is also {
   };
   
    sv_put(p : packet)@sys.any is {
       message(LOW,"Received put ", p);      
       wait delay(5 ns);
    };
    
    sv_try_put(p: packet) : bool is {
       message(LOW,"Received try_put ", p);      
    };
    
    sv_can_put() : bool is {
       message(LOW,"Received can_put ");      
    };
    
    sv_ok_to_put() : tlm_event is {
       message(LOW,"Received ok_to_put ");      
    };
   
}; // unit consumer
'>