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

#include "top.h"
#include <sysc/kernel/sc_spawn.h>
#include <sysc/kernel/sc_boost.h>

static bool pass_delay = true;

struct delay_time_test
{
  typedef void result_type;
  delay_time_test() : counter(0) {}
  void thread(sc_time start_time)
  {
    wait(12, SC_PS);
    if (start_time + sc_time(12, SC_PS) != sc_time_stamp()) {
       std::cout<<"[SC "<<sc_time_stamp()<<"] ERROR delay time mismatch " << start_time + sc_time(12, SC_PS) << " with " << sc_time_stamp() << std::endl;
       pass_delay &= false;
    }
    cout << "[SC "<<sc_time_stamp()<<"] delay_time_thread (start @ " << start_time << ")- success! " << std::endl;
    counter++;
  }
  int counter;
};

static delay_time_test dtt;

static void cb(uvm_event *e) {
  //assert(d->data == expected);
  sc_core::sc_spawn(sc_bind(&delay_time_test::thread, &dtt, sc_time_stamp()));

}

top::top(sc_module_name name_) : sc_module(name_) {

  cout << "SC :construction of " << this->name() << endl;

  uvm_event_pool * epool = uvm_event_pool::get_pool("uvm_test_top.env.mate");
  uvm_event * e = epool->get("test_event");
  cout << "[SC "<<sc_time_stamp()<<"]  event " << e->get_name() << std::endl;
  e->attach(cb);

  // run the main thread
  SC_THREAD(thread_process);
  SC_THREAD(thread_process2);
}


//void top::report_phase(uvm_phase *phase)
// Do final check at 'end_of_simulation' callback
void top::end_of_simulation()
{   
    std::cout << "[SC "<<sc_time_stamp()<<"]  checking results... " << std::endl;

    // check that both the event and barrier tests passed
    if ( pass_delay )
        std::cout << "** UVM TEST PASSED **" << std::endl;
    else
        std::cout << "** UVM TEST FAILED **" << std::endl;
}

void top::thread_process() {
  wait(1, SC_PS);
  if (sc_time_stamp() != sc_time(1, SC_PS)) {
    cout<<"[SC "<<sc_time_stamp()<<"] ERROR delay mismatch " << sc_time_stamp() << " with " << sc_time(1, SC_PS) << std::endl;
    pass_delay &= false;
  }
  _sc_e.notify(2, SC_PS);
  cout<<"[SC "<<sc_time_stamp()<<"] End of SC thread process"<<endl;
}

void top::thread_process2() {
  sc_time c = sc_time_stamp();
  wait(_sc_e);
  if (sc_time_stamp() != c + sc_time(1+2, SC_PS)) {
    cout<<"[SC "<<sc_time_stamp()<<"] ERROR delay mismatch " << sc_time_stamp() << " with " << c + sc_time(1+2, SC_PS) << std::endl;
    pass_delay &= false;
  }
  uvm_event_pool * epool = uvm_event_pool::get_pool("uvm_test_top.env.mate");
  uvm_event * e2 = epool->get("test_event2");
  e2->notify(NULL);
  cout<<"[SC "<<sc_time_stamp()<<"] End of SC thread process2"<<endl;
}


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



