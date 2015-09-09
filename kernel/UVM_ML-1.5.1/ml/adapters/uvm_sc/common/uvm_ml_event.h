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
//----------------------------------------------------------------------

#ifndef UVM_ML_EVENT_H
#define UVM_ML_EVENT_H

#include <map>
#include <string>
#include "base/uvm_pool.h"
#include "base/uvm_event.h"
#include "base/uvm_object.h"
#include "bp_provided.h"

using namespace uvm;

class uvm_ml_event_pool;

class uvm_ml_event : public uvm_event {

  friend class uvm_ml_event_pool;
  friend class uvm_pool<uvm_ml_event>;

public:

  static void initialize(bp_api_struct *bp_provided_api);

  virtual void notify(uvm_object* obj); 
  virtual void notify_without_bp_notification(uvm_object* obj);

  virtual void reset();
  virtual void reset_without_bp_notification();

  // Note:  sc_events() do not have hierarchy, so get_full_name() 
  //        does not make sense here - comment out for now...
  //virtual const std::string &get_full_name() const;

  static void notify_event_by_name(const char *                   scope_name,
                                   const char *                   event_name,
                                   uvm_ml_event_notify_action     action,
                                   unsigned int                   stream_size,
                                   uvm_ml_stream_t                stream,
                                   uvm_ml_time_unit               time_unit,
                                   double                         time_value);

 
  void notify_ml_event(uvm_ml_event_notify_action     action,
                       uvm_object *                   obj = NULL);

protected:
  uvm_ml_event(const std::string &name="");
  void set_pool(uvm_ml_event_pool * pool);

private:

  uvm_ml_event_pool * _pool;

  static bp_api_struct * _bp_provided_api;

};

class uvm_ml_event_pool : public uvm_event_pool {

public:

  class uvm_object_creator_uvm_pool : public uvm_object_creator
  {
  public:
      uvm_object* create(const string& name)
      {
          uvm_object* _uvmsc_obj = new uvm_ml_event_pool(name);
          _uvmsc_obj->set_name(name);
          return _uvmsc_obj;
      }
  };

  uvm_ml_event_pool(const string &name) :
        uvm_event_pool(name)
  {
  }

  virtual string get_type_name() const { return "uvm_ml_event_pool"; }

public:
  static void initialize();

  virtual uvm_event* get (const string& name);
  virtual bool remove (const string &name);
  virtual bool remove_without_bp_notification (const string &name);

};

#endif
