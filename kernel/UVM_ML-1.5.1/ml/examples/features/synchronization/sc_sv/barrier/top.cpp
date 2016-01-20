//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   Copyright 2014 Advanced Micro Devices, Inc.
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

#include "top.h"
#include <sysc/kernel/sc_spawn.h>
#include <sysc/kernel/sc_boost.h>

static int expected = 0;

top::top(sc_module_name name_) : sc_module(name_) {

  cout << "SC :construction of " << this->name() << endl;

  // run the main thread
  SC_THREAD(thread_process);
  //SC_THREAD(thread_process2);
}


//void top::report_phase(uvm_phase *phase)
// Do final check at 'end_of_simulation' callback
void top::end_of_simulation()
{   
    std::cout << "[SC "<<sc_time_stamp()<<"]  checking results... " << std::endl;

    // check that both the barrier tests passed
    if (expected == 8)
        std::cout << "** UVM TEST PASSED **" << std::endl;
    else {
        std::cout << "** UVM TEST FAILED **" << std::endl;
        assert(0);
    }
}



void top::thread_process() {
  cout<<"[SC "<<sc_time_stamp()<<"] staring SC thread process."<<endl;
  uvm_barrier_pool * bpool = uvm_barrier_pool::get_pool("uvm_test_top.env.mate");
  uvm_barrier * b = bpool->get("test_barrier");
  uvm_barrier * b_g = uvm_barrier_pool::get_global_pool()->get("test_barrier");
  // raise barrier
  expected ++;
  cout<<"[SC "<<sc_time_stamp()<<"] raise barrier" << endl;
  b->raise_barrier(2);
  wait(2, SC_PS);
  cout<<"[SC "<<sc_time_stamp()<<"] drop barrier" << endl;
  // drop barrier
  expected ++;
  b->drop_barrier(b->get_num_barriers());
  wait(1, SC_PS);
  // wait barrier
  expected ++;
  cout<<"[SC "<<sc_time_stamp()<<"] wait for barrier" << endl;
  b->wait();
  cout<<"[SC "<<sc_time_stamp()<<"] go through barrier" << endl;

  // raise_barrier and wait
  wait(1, SC_PS);
  cout<<"[SC "<<sc_time_stamp()<<"] raise barrier and wait" << endl;
  expected ++;
  b->raise_barrier();
  b->wait();
  cout<<"[SC "<<sc_time_stamp()<<"] go through barrier" << endl;

  wait(2, SC_PS);
  cout<<"[SC "<<sc_time_stamp()<<"] drop barrier" << endl;
  expected ++;
  b->drop_barrier(b->get_num_barriers());

  cout<<"[SC "<<sc_time_stamp()<<"] raise global barrier and wait" << endl;
  expected ++;
  b_g->raise_barrier();
  b_g->wait();

  wait(2, SC_PS);
  cout<<"[SC "<<sc_time_stamp()<<"] check deleted global barrier" << endl;
  if(uvm_barrier_pool::get_global_pool()->exists("test_barrier")) {
     cout<<"[SC "<<sc_time_stamp()<<"] Error: test_barrier is not deleted\n";
  } else {
     expected ++;
  }

  wait(1, SC_PS);
  cout<<"[SC "<<sc_time_stamp()<<"] remove barrier" << endl;
  bpool->remove("test_barrier");

  expected ++;
}

//void top::thread_process2() {
//  cout<<"[SC "<<sc_time_stamp()<<"] staring SC thread process2."<<endl;
//
//  uvm_barrier_pool * bpool = uvm_barrier_pool::get_pool("uvm_test_top.env.mate");
//  uvm_barrier * b = bpool->get("test_barrier");
//  b->raise_barrier();
//  b->wait();
//  // say pass the barrier
//  pass_barrier = true;
//  b->raise_barrier();
//  b->wait();
//  cout<<"[SC "<<sc_time_stamp()<<"] End of SC thread process2"<<endl;
//  b->raise_barrier();
//  //sc_stop();
//  b->wait();
//  // never reach here - else error!
//  pass_barrier = false;
//  cout<<"[SC "<<sc_time_stamp()<<"] ERROR - barrier reached reached code after wait()"<<endl;
//}

#ifndef NC_SYSTEMC
UVM_ML_MODULE_EXPORT(top);
int sc_main(int argc, char** argv) {
#ifdef MTI_SYSTEMC
    top a_top("top");
    sc_start(-1);
#endif
    return 0;
}
#else
NCSC_MODULE_EXPORT(top)
#endif



