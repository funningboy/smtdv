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

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include <algorithm>
#include "base/uvm_event.h"
#include "base/uvm_component.h"
#include "base/uvm_factory.h"
#include <systemc.h>

namespace uvm {

using std::string;
using std::vector;
using std::sort;
using std::ostream;


//------------------------------------------------------------------------------
// Constructor: uvm_event
//------------------------------------------------------------------------------
uvm_event::uvm_event(const string& name) :
    uvm_callback_agent<puvm_event>(),
    sc_core::sc_event(),
    m_name(name),
    m_notified(false),
    m_time(sc_core::SC_ZERO_TIME),
    m_reset_event(),
    m_uvm_object(NULL)
{
    //TODO - don't need to re-spawn - use SC_METHOD instead
    sc_spawn(sc_bind(&uvm_event::wait_notification, this));
}


//------------------------------------------------------------------------------
// Function : notify
//  Trigger event with data
//
// Parameters:
//   obj - object data for this event
//------------------------------------------------------------------------------
void uvm_event::notify (uvm_object* obj)
{
    m_uvm_object = obj;
    ::sc_core::sc_event::notify();
}


void uvm_event::wait_on()
{
    if (m_notified == false)
        wait();
}

void uvm_event::wait_off()
{
    if (m_notified == true)
        ::sc_core::wait(m_reset_event);
}

//------------------------------------------------------------------------------
// Function : get_trigger_time
//  Return the trigger time.
//------------------------------------------------------------------------------
sc_core::sc_time uvm_event::get_trigger_time()
{
    return m_time;
}

bool uvm_event::is_on()
{
    return m_notified;
}

bool uvm_event::is_off()
{
    return (!m_notified);
}

void uvm_event::reset()
{
    m_notified = false;
    m_time     = sc_core::SC_ZERO_TIME;
}

//------------------------------------------------------------------------------
// Function : handle_callback
//  Calls all callback registered to this event.
//------------------------------------------------------------------------------
    //uvm_event_mgr::Instance()->register_event(this);
void uvm_event::handle_callback()
{
    // TODO - is this the correct way to call the 'agent's notify?
    this->uvm_event_callback_agent::notify(this);
}

//TODO - remove spawning thread, convert this to an SC_METHOD fn
//       that is sensititive to this event
void uvm_event::wait_notification()
{
    
    //sc_core::sc_event this_event = *this;

    ::sc_core::wait(*this);
    m_time = sc_core::sc_time_stamp();
    m_notified = true;
    handle_callback();

    //TODO - don't need to re-spawn - use SC_METHOD instead
    sc_spawn(sc_bind(&uvm_event::wait_notification, this));
}

//---------------------------------------------------------------
ostream & operator<< ( ostream & os , const uvm_event & a_disp_ev ) 
{
    return os << " uvm_event : " << a_disp_ev.m_name ; 
}

} // namespace uvm
