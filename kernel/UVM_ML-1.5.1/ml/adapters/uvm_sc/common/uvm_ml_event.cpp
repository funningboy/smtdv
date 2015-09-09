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

#include "uvm_ml_event.h"
#include "common/uvm_ml_packer.h"
#include "uvm_imp_spec_macros.h"
#include "uvm_ml_sync.h"

using namespace uvm_ml;

bp_api_struct* uvm_ml_event::_bp_provided_api = NULL;

uvm_ml_event::uvm_ml_event(const string &name) : uvm_event(name), _pool(NULL) {
}

void uvm_ml_event::set_pool(uvm_ml_event_pool * pool) {
  _pool = pool;
}

void uvm_ml_event::initialize(bp_api_struct *bp_provided_api) {
  _bp_provided_api = bp_provided_api;
}

// Note:  sc_events() do not have hierarchy, so get_full_name() 
//        does not make sense here - comment out for now...
//const std::string &uvm_ml_event::get_full_name() const {
//  return get_name();
//}

void uvm_ml_event::notify_without_bp_notification(uvm_object* obj) {
  uvm_event::notify(obj);
}

void uvm_ml_event::notify(uvm_object* obj) {
  notify_without_bp_notification(obj);
  notify_ml_event(UVM_ML_EVENT_TRIGGER, obj);
}

void uvm_ml_event::reset_without_bp_notification() {
  uvm_event::reset();
}

void uvm_ml_event::reset() {
  reset_without_bp_notification();
  notify_ml_event(UVM_ML_EVENT_RESET);
}

void uvm_ml_event::notify_event_by_name(const char *                   scope_name,
                                        const char *                   event_name,
                                        uvm_ml_event_notify_action     action,
                                        unsigned int                   stream_size,
                                        uvm_ml_stream_t                stream,
                                        uvm_ml_time_unit               time_unit,
                                        double                         time_value){
  ENTER_CO_SIMULATION_CONTEXT();

  uvm_object *       obj_val;
  uvm_ml_packer_int  packer;
  uvm_ml_packed_obj& packed_obj = uvm_ml_utils::get_static_mlupo();

  uvm_ml_event_pool * pool = dynamic_cast<uvm_ml_event_pool*>(uvm_ml_event_pool::get_pool(scope_name));
  assert(pool);
  uvm_ml_event * e = NULL;

  if (pool->exists(event_name)) {
    if (action == UVM_ML_EVENT_DELETE) {
      pool->remove_without_bp_notification(event_name); 
      EXIT_CO_SIMULATION_CONTEXT();
      return;
    }
  }
  
  uvm_ml_utils::fill_mlupo(packed_obj, stream_size, stream);
  packer.set_from_uvm_ml_packed_obj(&packed_obj);

  // FIXME:  Need to check that the data type is supported
  //         prior to packing else this will result in an error
  packer >> obj_val;
  
  e = dynamic_cast<uvm_ml_event*>(pool->get(event_name));
  assert(e);
  
  switch(action) {
    case UVM_ML_EVENT_NEW : break;
    case UVM_ML_EVENT_TRIGGER :
      e->notify_without_bp_notification(obj_val);
      break;
    case UVM_ML_EVENT_RESET :
      e->reset_without_bp_notification();
      break;
    default : break;
  }

  EXIT_CO_SIMULATION_CONTEXT();
}


void uvm_ml_event::notify_ml_event(uvm_ml_event_notify_action     action,
                                   uvm_object *                   obj) {
  uvm_ml_packed_obj & packed_obj = uvm_ml_utils::get_static_mlupo();
  sc_core::sc_time current_time  = sc_core::sc_time_stamp(); 
  double           time_sec      = current_time.to_seconds();
  unsigned         framework_id  = uvm_ml_utils::FrameworkId();
  int              size          = 0;

  uvm_ml_packer_pack(obj, &packed_obj);
  size = (packed_obj.size-1)/32 + 1; 
  assert(_bp_provided_api);
  assert(_pool);
  (*_bp_provided_api->notify_event_ptr)(framework_id, _pool->get_full_name().c_str(), get_name().c_str(), action, size, packed_obj.val, (uvm_ml_time_unit) sc_core::SC_SEC, time_sec); 
}

// Note:  Initialize is only allowed to be run once
void uvm_ml_event_pool::initialize()
{
    // Factory override uvm_event_pool with uvm_ml_event_pool
    if(uvm::uvm_factory::is_uvm_object_registered("uvm_ml_event_pool") == false)
    {
        uvm::uvm_factory::register_uvm_object_creator("uvm_ml_event_pool",new uvm_ml_event_pool::uvm_object_creator_uvm_pool());
    }
}

uvm_event* uvm_ml_event_pool::get (const string& name) {
  uvm_ml_event* item;
  std::map< string, uvm_event* >::iterator it;
  it = _pool_map.find(name);
  if (it == _pool_map.end())
  {
    item = new uvm_ml_event(name);
    item->set_pool(this);
    _pool_map[name] = item;
  }
  return _pool_map[name];
}

bool uvm_ml_event_pool::remove (const string &name) {
  if (exists(name)) {
    uvm_ml_event* e = dynamic_cast<uvm_ml_event*>(get(name));
    assert(e);
    e->notify_ml_event(UVM_ML_EVENT_DELETE);
  }
  return remove_without_bp_notification(name);
}

bool uvm_ml_event_pool::remove_without_bp_notification (const string &name) {
  std::map<string, uvm_event*>::iterator it;
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
