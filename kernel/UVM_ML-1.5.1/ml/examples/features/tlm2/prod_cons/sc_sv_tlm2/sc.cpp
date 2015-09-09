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
#include "uvm_ml.h"
#include "ml_tlm2.h"
#include "producer.h"

using namespace uvm;
using namespace uvm_ml;

// Env containing a producer and a producer
class env : public uvm_component {
public:
  producer prod;

  env(sc_module_name nm) : uvm_component(nm)
			 , prod("prod")
  {
    cout << "SC env::env" << endl;
  }
  
  // Register and connect the sockets
  void before_end_of_elaboration() {
    cout << "SC env::before_end_of_elaboration" << endl;
    std::string full_initiator_b_socket_name = 
      ML_TLM2_REGISTER_INITIATOR(prod, PAYLOAD_TYPE, b_isocket , 32);
    std::string full_initiator_nb_socket_name = 
      ML_TLM2_REGISTER_INITIATOR(prod, PAYLOAD_TYPE, nb_isocket , 32);
    uvm_ml::uvm_ml_connect(full_initiator_b_socket_name, 
			   "svtop.sv_env.consumer.b_target_socket");
    uvm_ml::uvm_ml_connect(full_initiator_nb_socket_name, 
			   "svtop.sv_env.consumer.nb_target_socket");
  }
  UVM_COMPONENT_UTILS(env)
};

// Top level module
class sctop : public sc_module {
public:
  env sc_env;

  sctop(sc_module_name nm) : sc_module(nm) 
			   , sc_env("sc_env")
  {
    cout << "SC sctop::sctop" << endl;
  }
};

#ifdef NC_SYSTEMC
NCSC_MODULE_EXPORT(sctop)
#else
int sc_main(int argc, char** argv) {
#ifdef MTI_SYSTEMC
    sctop a_top("sctop");
    sc_start(-1);
#endif
  return 0;
}
UVM_ML_MODULE_EXPORT(sctop)
#endif

UVM_COMPONENT_REGISTER(producer)
UVM_COMPONENT_REGISTER(env)
