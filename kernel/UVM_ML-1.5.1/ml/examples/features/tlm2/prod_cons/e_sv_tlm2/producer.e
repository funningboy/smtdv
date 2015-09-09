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
    nb_socket  : tlm_initiator_socket of tlm_generic_payload is instance;
    b_socket   : tlm_initiator_socket of tlm_generic_payload is instance;

    gp1   : tlm_generic_payload;
    gp2   : tlm_generic_payload;
    status: tlm_sync_enum;
    addr  : uint;

    connect_ports() is also {
       nb_socket.connect(external);
       b_socket.connect(external);
    };

    run() is also {
        start drive();
    };
    
    drive()@sys.any is {
       var ind: uint = 1;
       
       out("\n*** Starting non-blocking TLM2 transactions from e to SV");
       gp1 = create_trans(addr, TLM_WRITE_COMMAND);
       message(LOW,append("Calling nb_transport_fw with data size ",gp1.m_length));
       var phase : tlm_phase_enum = BEGIN_REQ;
       var t: time = 0;
       status = nb_socket$.nb_transport_fw(gp1, phase, t);
       check that status == TLM_COMPLETED;
       wait delay (10 ns);
        
       gp2 = create_trans(addr, TLM_READ_COMMAND);
       message(LOW,append("Calling nb_transport_fw with data size ",gp2.m_length));
       status = nb_socket$.nb_transport_fw(gp2, phase, t);
       message(LOW,append("Received data ",hex(gp2.m_data)));
       check that status == TLM_COMPLETED;
       check that gp1.m_data == gp2.m_data;
       wait delay (10 ns);
       
       out("\n*** Starting blocking TLM2 transactions from e to SV");
       gp1 = create_trans(addr, TLM_WRITE_COMMAND);
       message(LOW,append("Calling b_transport with data size ",gp1.m_length));
       t = 10 ns;
       b_socket$.b_transport(gp1, t);
       
       gp2 = create_trans(addr, TLM_READ_COMMAND);
       message(LOW,append("Calling b_transport with data size ",gp2.m_length));
       b_socket$.b_transport(gp2, t);
       message(LOW,append("Received data ", hex(gp2.m_data)));
       check that gp1.m_data == gp2.m_data;
              
    };
    
    // Create generic payload with random data of length 4
    create_trans(addr:uint, cmd: tlm_command) : tlm_generic_payload is {       
        result = new;
        
        result.m_address = addr;
        result.m_command = cmd;
        if(cmd == TLM_READ_COMMAND) {
           for i from 0 to 3 do {
              result.m_data.add(0);
           }; 
        } else {
           gen result.m_data keeping {.size() == 4};
        };
        result.m_length = result.m_data.size();
        result.m_response_status = TLM_INCOMPLETE_RESPONSE;
        result.m_byte_enable_length = 0;
    };

    nb_transport_bw(trans: tlm_generic_payload, phase: *tlm_phase_enum, t: *time): tlm_sync_enum is {
        message(LOW,"Received nb_transport_bw ", trans.m_response_status);
        return TLM_COMPLETED;
    };
};
'>