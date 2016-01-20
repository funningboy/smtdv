//----------------------------------------------------------------------
//   Copyright 2012 Advanced Micro Devices Inc.
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

#ifndef __UVM_EVENT_H__
#define __UVM_EVENT_H__

#include <string>
#include <vector>
#include <map>
#include <sysc/kernel/sc_event.h>
#include <sysc/kernel/sc_time.h>
#include <sysc/kernel/sc_wait.h>
#include "base/uvm_callback.h"
#include "base/uvm_object.h"
#include "base/uvm_pool.h"


namespace uvm {

typedef void (*PFEVSYNC) (std::string name, uvm_object* data);

class   uvm_event;
typedef uvm_event *                          uvm_event_ptr;
typedef std::map<std::string,uvm_event_ptr>  uvm_event_ptr_map;

typedef uvm_event *                          puvm_event;
typedef uvm_callback_agent<puvm_event>       uvm_event_callback_agent;
typedef uvm_callback_agent<puvm_event>      *puvm_event_callback_agent;


//------------------------------------------------------------------------------
// Class: uvm_event
//   Derived class of sc_event, adding data capabilities.
//------------------------------------------------------------------------------
class  uvm_event : public uvm_callback_agent<puvm_event>, public sc_core::sc_event
{
    friend std::ostream & operator<< ( std::ostream &, const uvm_event & ); 
    friend  void Wait ( const uvm_event & ); 
    friend  bool Wait ( const sc_core::sc_time & , const uvm_event & ); 

public:
    uvm_event(const std::string& name); 

protected:  

    //------------------------------------------------------------------------------
    // Destructor : uvm_event
    //------------------------------------------------------------------------------
    virtual ~uvm_event() { }; 

public:
    //------------------------------------------------------------------------------
    // Function : get_name
    //  Returns name of uvm_event
    //------------------------------------------------------------------------------
    virtual const std::string & get_name() const { return m_name; };

    virtual void notify(uvm_object* obj);

    //------------------------------------------------------------------------------
    // Function: wait
    //   Wait on uvm_event
    //------------------------------------------------------------------------------
    void wait() { ::sc_core::wait(*this); };


    void wait_on();
    void wait_off();
    sc_core::sc_time get_trigger_time();
    bool is_on();
    bool is_off();
    virtual void reset();

    //------------------------------------------------------------------------------
    // Function: get_data
    //   Returns notified data.
    //------------------------------------------------------------------------------
    uvm_object* get_data() {return m_uvm_object;};
    static PFEVSYNC pfEventSync;

protected:
    std::string         m_name;
    bool                m_notified;
    sc_core::sc_time    m_time;
    sc_core::sc_event   m_reset_event;
    uvm_object*         m_uvm_object;

    virtual void handle_callback();
    virtual void wait_notification();

}; 

typedef class uvm_pool<uvm_event> uvm_event_pool;

} // namespace uvm

#endif //__UVM_EVENT_H__

