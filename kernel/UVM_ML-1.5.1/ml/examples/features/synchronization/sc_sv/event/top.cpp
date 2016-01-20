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

static const int FINAL_DATA_VALUE = 86;
static int expected = 0;
static bool pass_event = true;

static int expected_named_pool = 0;
static int named_pool_auto_inc = 0;
static void cb_named_pool_d(uvm_event *e) {
  expected_named_pool = expected_named_pool + named_pool_auto_inc; 
  my_object * d = (my_object *)e->get_data();
  std::cout << "[SC " 
            << sc_time_stamp()
            << "] trigger event "
            << e->get_name() << " : " << d->data
            << " : expected : " << expected_named_pool << std::endl;
  if(d->data == expected_named_pool)
      pass_event &= true;
  else
  {
      std::cout << "[SC "
                << sc_time_stamp()
                << "] ERROR - event data("
                << d->data
                << ") does not match expected("
                << expected_named_pool << ")" << std::endl;
      pass_event &= false;
  }
}

static int expected_global_pool = 0;
static int global_pool_auto_inc = 0;
static void cb_global_pool_d(uvm_event *e) {
  expected_global_pool = expected_global_pool + global_pool_auto_inc;
  my_object * d = (my_object *)e->get_data();
  std::cout << "[SC "
            << sc_time_stamp()
            << "] trigger event "
            << e->get_name() << " : " << d->data
            << " : expected : " << expected_global_pool << std::endl;
  if(d->data == expected_global_pool)
      pass_event &= true;
  else
  {
      std::cout << "[SC "
                << sc_time_stamp()
                << "] ERROR - event data("
                << d->data
                << ") does not match expected("
                << expected_global_pool << ")" << std::endl;
      pass_event &= false;
  }
}

static int counter_named_pool = 0;
static void cb_named_pool(uvm_event *e) {
  counter_named_pool ++;
  std::cout << "[SC "
            << sc_time_stamp()
            << "] trigger event "
            << e->get_name() << " : " << counter_named_pool << std::endl;
}

static int counter_global_pool = 0;
static void cb_global_pool(uvm_event *e) {
  counter_global_pool ++;
  std::cout << "[SC "
            << sc_time_stamp()
            << "] trigger event "
            << e->get_name() << " : " << counter_global_pool << std::endl;
}

static void check_counter(int a, int b){
  if(a == b)
      pass_event &= true;
  else
  {
      std::cout << "[SC "
                << sc_time_stamp()
                << "] ERROR - event counter("
                << a
                << ") does not match expected("
                << b << ")" << std::endl;
      pass_event &= false;
  }
}

top::top(sc_module_name name_) : sc_module(name_) {

  cout << "SC :construction of " << this->name() << endl;

  uvm_event_pool * epool = uvm_event_pool::get_pool("uvm_test_top.env.mate");
  e_named_pool_d  = epool->get("event_from_named_pool_d");
  e_named_pool    = epool->get("event_from_named_pool");
  e_global_pool_d = uvm_event_pool::get_global_pool()->get("event_from_global_pool_d");
  e_global_pool   = uvm_event_pool::get_global_pool()->get("event_from_global_pool");
  e_named_pool_d ->attach(cb_named_pool_d);
  e_named_pool   ->attach(cb_named_pool);
  e_global_pool_d->attach(cb_global_pool_d);
  e_global_pool  ->attach(cb_global_pool);
  // run the main thread
  SC_THREAD(thread_process);
}

void top::event_named_pool_d_trigger() {
  my_object *d = new my_object();
  expected_named_pool = expected_named_pool + 3;
  d->data = expected_named_pool;
  e_named_pool_d->notify(d);
}

void top::event_named_pool_trigger() {
  e_named_pool->notify(NULL);
}

void top::event_global_pool_d_trigger() {
  my_object *d = new my_object();
  expected_global_pool = expected_global_pool + 3;
  d->data = expected_global_pool;
  e_global_pool_d->notify(d);
}

void top::event_global_pool_trigger() {
  e_global_pool->notify(NULL);
}


//void top::report_phase(uvm_phase *phase)
// Do final check at 'end_of_simulation' callback
void top::end_of_simulation()
{   
    std::cout << "[SC "<<sc_time_stamp()<<"]  checking results... " << std::endl;

    // check that both the event tests passed
    if (pass_event && expected == FINAL_DATA_VALUE)
        std::cout << "** UVM TEST PASSED **" << std::endl;
    else {
        std::cout << "** UVM TEST FAILED **" << std::endl;
        assert(0);
    }
}



void top::thread_process() {
  cout<<"[SC "<<sc_time_stamp()<<"] staring SC thread process."<<endl;
  int l_counter_named_pool = 0;
  int l_counter_global_pool = 0;  
  // #0
  // wait event from named pool of sv with data
  named_pool_auto_inc = 3;
  for(int i=0; i < 10; i++) {
    expected ++;
    wait(sc_time(10, SC_PS));
  }
  named_pool_auto_inc = 0;
  wait(sc_time(2, SC_PS));
  // #102
  // trigger event from named pool with data
  for(int i=0; i < 10; i++) {
    expected ++;
    event_named_pool_d_trigger();
    wait(sc_time(10, SC_PS));
  }
  // #202
  // wait event from global pool of sv with data
  global_pool_auto_inc = 3;
  for(int i=0; i < 10; i++) {
    expected ++;
    wait(sc_time(10, SC_PS));
  }
  global_pool_auto_inc = 0;
  wait(sc_time(2, SC_PS));
  // #304
  // trigger event from global pool with data
  for(int i=0; i < 10; i++) {
    expected ++;
    event_global_pool_d_trigger();
    wait(sc_time(10, SC_PS));
  }
  // #404
  // wait event from named pool of sv
  for(int i=0; i < 10; i++) {
    expected ++;
    l_counter_named_pool ++;
    wait(sc_time(10, SC_PS));
  }
  // trigger event from named pool
  for(int i=0; i < 10; i++) {
    expected ++;
    l_counter_named_pool ++;
    event_named_pool_trigger();
    wait(sc_time(10, SC_PS));
  }
  // wait event from global pool of sv
  for(int i=0; i < 10; i++) {
    expected ++;
    l_counter_global_pool ++;
    wait(sc_time(10, SC_PS));
  }
  // trigger event from global pool
  for(int i=0; i < 10; i++) {
    expected ++;
    l_counter_global_pool ++;
    event_global_pool_trigger();
    wait(sc_time(10, SC_PS));
  }

  wait(sc_time(1, SC_PS));

  // check triggerd counters;
  expected ++;
  check_counter(counter_named_pool, l_counter_named_pool);
  expected ++;
  check_counter(counter_global_pool, l_counter_global_pool);

  // check reset e_global_pool
  assert(e_global_pool->is_on());
  wait(sc_time(2, SC_PS));

  expected ++;
  if (!e_global_pool->is_off()) {
    std::cout << "[SC "
                << sc_time_stamp()
                << "] ERROR - event "
                << e_global_pool->get_name()
                << " is not reset"
                << std::endl;
    pass_event &= false;
  }

  // reset e_global_pool_d
  expected ++;
  e_global_pool_d->reset();

  wait(sc_time(2, SC_PS));
  // check deleted e_global_pool;
  expected ++;
  if(uvm_event_pool::get_global_pool()->exists("event_from_global_pool")) {
    std::cout << "[SC "
                << sc_time_stamp()
                << "] ERROR - event "
                << e_global_pool->get_name()
                << " is not deleted"
                << std::endl;
    pass_event &= false;
  }
  // remove event_from_global_pool_d
  expected ++;
  uvm_event_pool::get_global_pool()->remove("event_from_global_pool_d");
  wait(sc_time(10, SC_PS));
  cout<<"[SC "<<sc_time_stamp()<<"] End of SC thread process"<<endl;
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



