//----------------------------------------------------------------------
//   Copyright 2014 Advanced Micro Devices Inc.
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

#include "uvm_ml_barrier.h"
#include "common/uvm_ml_packer.h"
#include "uvm_imp_spec_macros.h"
#include "uvm_ml_sync.h"

using namespace uvm_ml;

bp_api_struct* uvm_ml_barrier::_bp_provided_api = NULL;

uvm_ml_barrier::uvm_ml_barrier(const string &name) : uvm_barrier(name), _pool(NULL) {
}

void uvm_ml_barrier::set_pool(uvm_ml_barrier_pool * pool) {
  _pool = pool;
}

void uvm_ml_barrier::initialize(bp_api_struct *bp_provided_api) {
  _bp_provided_api = bp_provided_api;
}

// Note:  sc_barrier() do not have hierarchy, so get_full_name() 
//        does not make sense here - comment out for now...
//const std::string &uvm_ml_barrier::get_full_name() const {
//  return get_name();
//}

void uvm_ml_barrier::wait_without_bp_notification() {
  uvm_barrier::wait();
}

void uvm_ml_barrier::wait() {
//  notify_ml_barrier(UVM_ML_BARRIER_SET_THRESHOLD, get_num_barriers() + 1);
  wait_without_bp_notification();
}

void uvm_ml_barrier::raise_barrier_without_bp_notification(int count) {
  uvm_barrier::raise_barrier(count);
}

void uvm_ml_barrier::raise_barrier(int count) {
  notify_ml_barrier(UVM_ML_BARRIER_SET_THRESHOLD, get_num_barriers() + count);
  raise_barrier_without_bp_notification();
}

void uvm_ml_barrier::drop_barrier_without_bp_notification(int count) {
  uvm_barrier::drop_barrier(count);
}

void uvm_ml_barrier::drop_barrier(int count) {
  notify_ml_barrier(UVM_ML_BARRIER_SET_THRESHOLD, get_num_barriers() - count);
  drop_barrier_without_bp_notification();
}

void uvm_ml_barrier::notify_barrier_by_name(const char *                   scope_name,
                                            const char *                   barrier_name,
                                            uvm_ml_barrier_notify_action   action,
                                            int                            count,
                                            uvm_ml_time_unit               time_unit,
                                            double                         time_value){

  ENTER_CO_SIMULATION_CONTEXT();

  uvm_ml_barrier_pool * pool = dynamic_cast<uvm_ml_barrier_pool*>(uvm_ml_barrier_pool::get_pool(scope_name));
  assert(pool);
  uvm_ml_barrier * b = NULL;
  int on = 0;
  int nn = 0;

  if (pool->exists(barrier_name)) {
    if (action == UVM_ML_BARRIER_DELETE) {
      pool->remove_without_bp_notification(barrier_name); 
      EXIT_CO_SIMULATION_CONTEXT();
      return;
    }
  }
  
  b = dynamic_cast<uvm_ml_barrier*>(pool->get(barrier_name));
  assert(b);

  switch(action) {
    case UVM_ML_BARRIER_NEW : break;
    case UVM_ML_BARRIER_SET_AUTO_RESET: break;
    case UVM_ML_BARRIER_SET_THRESHOLD:
      on = b->get_num_barriers();
      nn = count;
      //assert(nn >= 0);
      if (nn > on)
         b->raise_barrier_without_bp_notification(nn - on);
      else {
         if (nn >= 0 && nn < on)
           b->drop_barrier_without_bp_notification(on - nn);
      }
      break;
    case UVM_ML_BARRIER_RESET :
      //b->drop_barrier_without_bp_notification(b->get_num_barriers());
      break;
    default : break;
  }
  EXIT_CO_SIMULATION_CONTEXT();
}


void uvm_ml_barrier::notify_ml_barrier(uvm_ml_barrier_notify_action     action,
                                       int count) {
  sc_core::sc_time current_time  = sc_core::sc_time_stamp(); 
  double           time_sec      = current_time.to_seconds();
  unsigned         framework_id  = uvm_ml_utils::FrameworkId();

  assert(_bp_provided_api);
  assert(_pool);
  (*_bp_provided_api->notify_barrier_ptr)(framework_id, _pool->get_full_name().c_str(), get_name().c_str(), action, count, (uvm_ml_time_unit) sc_core::SC_SEC, time_sec); 
}


// Note:  Initialize is only allowed to be run once
void uvm_ml_barrier_pool::initialize()
{
    if(uvm::uvm_factory::is_uvm_object_registered("uvm_ml_barrier_pool") == false)
    {
        // Factory override uvm_barrier_pool with uvm_ml_barrier_pool
        uvm::uvm_factory::register_uvm_object_creator("uvm_ml_barrier_pool",new uvm_ml_barrier_pool::uvm_object_creator_uvm_pool());
    }
}

uvm_barrier* uvm_ml_barrier_pool::get (const string& name) {
  uvm_ml_barrier* item;
  std::map< string, uvm_barrier* >::iterator it;
  it = _pool_map.find(name);
  if (it == _pool_map.end())
  {
    item = new uvm_ml_barrier(name);
    item->set_pool(this);
    _pool_map[name] = item;
  }
  return _pool_map[name];
}

bool uvm_ml_barrier_pool::remove (const string &name) {
  if (exists(name)) {
    uvm_ml_barrier* b = dynamic_cast<uvm_ml_barrier*>(get(name));
    assert(b);
    b->notify_ml_barrier(UVM_ML_BARRIER_DELETE);
  }
  return remove_without_bp_notification(name);
}

bool uvm_ml_barrier_pool::remove_without_bp_notification (const string &name) {
  std::map<string, uvm_barrier*>::iterator it;
  it = _pool_map.find(name);
  if (it == _pool_map.end())
  {
    return false;
  }
  else
  {
    _pool_map.erase(name);
    return true;
  }
}

