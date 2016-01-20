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
#include "packet.h"

template <typename T>
class producer : public uvm_component 
		 //, public tlm::tlm_bw_transport_if<tlm::tlm_base_protocol_types>
{
public:
  sc_port<tlm_blocking_put_if<T> > put_port;
  sc_port<tlm_nonblocking_put_if<T> > put_nb_port;

  producer(sc_module_name nm) : uvm_component(nm)
                              , put_port("put_port")
                              , put_nb_port("put_nb_port")
    { 
    }
  UVM_COMPONENT_UTILS(producer)

  void build() {
    cout << "SC producer::build" << endl;
  }

  // main thread initiating TLM1 and TLM2 transactions
  void run() {
    T * t;
    bool ret;

    wait(10, SC_NS);
  
    t = new T;
    cout << "\n\n*** Starting Non-blocking TLM1 transactions from SC to SV" << endl;
    for(int i = 0; i < 3; i++) {
      wait(5, SC_NS);
      cout << "[" << sc_time_stamp() << "] SC producer::can_put " << endl;
      ret = put_nb_port->nb_can_put();
      cout << "[" << sc_time_stamp() << "] SC producer::can_put returned " << ret << endl;
      wait(5, SC_NS);
      t->data = 17+i;
      cout << "[" << sc_time_stamp() << "] SC producer::sending packet " << *t << endl;
      ret = put_nb_port->nb_put(*t);
      cout << "[" << sc_time_stamp() << "] SC producer::sent packet " << *t << endl;
      wait(5, SC_NS);
    }

    cout << "\n\n*** Starting Blocking TLM1 transactions from SC to SV" << endl;
    for (int j = 0; j < 3; j++) {
      t->data = 20+j;
      cout << "[" << sc_time_stamp() << "] SC producer::sending T " << *t << endl;
      put_port->put(*t);
      cout << "[" << sc_time_stamp() << "] SC producer::sent T " << *t << endl;
      wait(4, SC_NS);
    }
  }
};

