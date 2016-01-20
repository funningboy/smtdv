//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   Copyright 2014 Adavanced Micro Devices, Inc.
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

using namespace uvm;

class my_object : public uvm_object {
public:
  UVM_OBJECT_UTILS(my_object);
  int data;
  my_object() : data(0) {}
  virtual void do_print(std::ostream&) const {;}
  virtual void do_pack(uvm::uvm_packer& p) const {
    uvm_object::do_pack(p);
    p << data;
  }
  virtual void do_unpack(uvm::uvm_packer& p) {
    uvm_object::do_unpack(p);
    p >> data;
  }
  virtual void do_copy(const uvm::uvm_object*) {;}
  virtual bool do_compare(const uvm::uvm_object*) const { return true;}

};

UVM_OBJECT_REGISTER(my_object);

class top : public sc_module {
public :

  uvm_event * e_named_pool_d;
  uvm_event * e_named_pool;
  uvm_event * e_global_pool_d;
  uvm_event * e_global_pool;

  SC_HAS_PROCESS(top);

  // constructor
  top(sc_module_name name_);

  void end_of_simulation();

  void thread_process();

  void event_named_pool_d_trigger();
  void event_named_pool_trigger();
  void event_global_pool_d_trigger();
  void event_global_pool_trigger();

};

