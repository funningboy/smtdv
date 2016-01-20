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

/*! \file uvm_phase.cpp
  \brief Implementation for UVM-SC phases.
*/
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <algorithm>
#include "base/uvm_phase.h"
#include "base/uvm_component.h"
#include "base/uvm_globals.h"

namespace uvm {

using std::string;
using std::endl;

//------------------------------------------------------------------------------
// Constructor: uvm_phase
//------------------------------------------------------------------------------
uvm_phase::uvm_phase(std::string name, uvm_schedule *p_schedule, uvm_phase_type type, uvm_phase_order phase_order) :
    _name(name),
    _type(type),
    _state(UVM_PHASE_DORMANT),
    _state_callback_notified(false),
    _order(phase_order),
    _pschedule(p_schedule)
{
    puvm_phase_callback_agent p_callback_agent;

    p_callback_agent = new uvm_phase_callback_agent();
    _callback_map[UVM_PHASE_STARTED] = p_callback_agent;

    p_callback_agent = new uvm_phase_callback_agent();
    _callback_map[UVM_PHASE_EXECUTING] = p_callback_agent;

    p_callback_agent = new uvm_phase_callback_agent();
    _callback_map[UVM_PHASE_READY_TO_END] = p_callback_agent;

    p_callback_agent = new uvm_phase_callback_agent();
    _callback_map[UVM_PHASE_ENDED] = p_callback_agent;

}

//------------------------------------------------------------------------------
// Destructor: uvm_phase
//------------------------------------------------------------------------------
uvm_phase::~uvm_phase()
{
    std::map<uvm_phase_state, puvm_phase_callback_agent>::iterator it;

    for (it = _callback_map.begin(); it != _callback_map.end(); it++)
    {
        if (it->second != NULL)
            delete it->second;
    }
    _callback_map.clear();
}


//------------------------------------------------------------------------------
// Function: reset_name
//   Resets the state of the phase to allow it to be re-used again
//   In the case where a 'jump' to it again is issues from somewhere
//   Note:
//        Phase properties are preservered (eg name, type, order, sync points)
//
//
// Returns:
//   none 
//------------------------------------------------------------------------------
void uvm_phase::reset_phase()
{
    _state = UVM_PHASE_DORMANT;         // set phase state to DORMANT for possible re-entry
    _state_callback_notified = false;   // reset state of notified callbacks for phase
    clear_next_phase_req();             // clear any pending jump requests in phase map
}


//------------------------------------------------------------------------------
// Function: get_name
//   Return name of phase
//
// Returns:
//   name - name of phase
//------------------------------------------------------------------------------
string uvm_phase::get_name()
{
    return _name;
}

//------------------------------------------------------------------------------
// Function: get_state_name
//   Return name of current state
//
// Returns:
//   name - name of state 
//------------------------------------------------------------------------------
string uvm_phase::get_state_name()
{
    string name;

    switch(_state)
    {
    case UVM_PHASE_DORMANT:
        name = "uvm_phase_dormant";
        break;
    case UVM_PHASE_STARTED:
        name = "uvm_phase_started";
        break;
    case UVM_PHASE_EXECUTING:
        name = "uvm_phase_executing";
        break;
    case UVM_PHASE_READY_TO_END:
        name = "uvm_phase_ready_to_end";
        break;
    case UVM_PHASE_ENDED:
        name = "uvm_phase_ended";
        break;
    case UVM_PHASE_DONE:
        name = "uvm_phase_done";
        break;
    default:
        name = "undefined";
        break;
    }

    return name;
}



//------------------------------------------------------------------------------
// Function: get_phase_type
//   Return type of the phase
//
// Returns:
//   type - type of phase
//------------------------------------------------------------------------------
uvm_phase_type uvm_phase::get_phase_type()
{
    return _type;
}

//------------------------------------------------------------------------------
// Function: get_phase_order
//   Return order of the phase (bottom up/top down/NA)
//
// Returns:
//   order - order of phase
//------------------------------------------------------------------------------
uvm_phase_order uvm_phase::get_phase_order()
{
    return _order;
}

//------------------------------------------------------------------------------
// Function: get_phase_state
//   Return state of the phase
//
// Returns:
//   state - state of phase
//------------------------------------------------------------------------------
uvm_phase_state uvm_phase::get_phase_state()
{
    return _state;
}

//------------------------------------------------------------------------------
// Function: set_phase_state
//  Sets the phase state
//
// Parameters:
//   state - state of phase
//------------------------------------------------------------------------------
void uvm_phase::set_phase_state(uvm_phase_state state)
{
    _state = state;
    _state_callback_notified = false;       // only notify callbacks once per state

    if ((_type == UVM_RUNTIME_PHASE) && (_state == UVM_PHASE_STARTED))
        started_ev.notify();     // used for syncing
}

//------------------------------------------------------------------------------
// Function: do_state
//  By default - sets the phase state but can be overriden in a specific 
//  phase class to do more things 
//
// Parameters:
//   state - state of phase
//
// Returns:
//   1 - base class method always returns the success value
//------------------------------------------------------------------------------
int uvm_phase::do_state(uvm_phase_state state)
{
    set_phase_state(state);
    return 1;
}

//------------------------------------------------------------------------------
// Function: set_schedule
//  Sets pointer to the schedule the phase is in
//
// Parameters:
//   schedule - pointer to the schedule
//------------------------------------------------------------------------------
void uvm_phase::set_schedule(uvm_schedule* pschedule)
{
    _pschedule = pschedule;
}

//------------------------------------------------------------------------------
// Function: get_schedule
//  Returns pointer to the schedule the phase is in
//
// Returns:
//   schedule - pointer to the schedule
//------------------------------------------------------------------------------
uvm_schedule* uvm_phase::get_schedule()
{
    return _pschedule;
}

//------------------------------------------------------------------------------
// Function: add_next_phase
//  Add phase that this current phase can move to.
//
// Parameters:
//  phase    - pointer to next phase
//  priority - priority for moving to this phase, current phase will move to
//             the phase with the highest priority when all barriers have
//             been lowered.
//------------------------------------------------------------------------------
void uvm_phase::add_next_phase(uvm_phase* phase, unsigned int priority)
{
    _next_phase_map.insert(std::pair<int, uvm_phase*>(priority, phase));
}


//------------------------------------------------------------------------------
// Function: get_next_phase
//  Returns the next phase after current phase
//
// Returns:
//  phase    - pointer to next phase
//------------------------------------------------------------------------------
uvm_phase* uvm_phase::get_next_phase()
{
    std::multimap<unsigned int, uvm_phase*>::reverse_iterator rit;
    if (_next_phase_map.size() > 0)
    {
        if (_next_phase_req_map.size() > 0)
        {
            rit = _next_phase_map.rbegin();
            return rit->second;
        }
        else
        {
            rit = _next_phase_map.rbegin();
            return rit->second;
        }
    }
    else
    {
        return NULL;
    }
}

//------------------------------------------------------------------------------
// Function: go_to_phase
//  Request to go to a particular phase, after this phase is done
//
// Parameters:
//  phase - pointer to phase to go to 
//
// TODO - Jumping may not make sense in pre/post run phases - should we limit it?
//        If so, then jump handler here (or at get_next_phase) should be run/non-runtime aware
//------------------------------------------------------------------------------
void uvm_phase::go_to_phase(uvm_phase* phase)
{
    std::multimap<unsigned int, uvm_phase*>::iterator it;
    bool bfound = false;

    it = _next_phase_map.begin();
    while (it != _next_phase_map.end() && bfound == false)
    {
        if (it->second == phase)
        {
            bfound = true;
            _next_phase_req_map.insert(std::pair<int, uvm_phase*>(it->first, it->second));
        }
        it++;
    }
}

//------------------------------------------------------------------------------
// Function: clear_next_phase_req
//  Clears the next phase request list
//------------------------------------------------------------------------------
void uvm_phase::clear_next_phase_req()
{
    _next_phase_req_map.clear();
}

//------------------------------------------------------------------------------
// Function: execute_runtime_phase
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::execute_runtime_phase()
{
    std::ostringstream outmsg;
    uvm_component* pcomp;
    puvm_phase_callback_agent p_callback_agent;

    if (_type != UVM_RUNTIME_PHASE) 
    {
        outmsg << _name << endl;
        SC_REPORT_WARNING(UVM_PHASE_TYPE_INVALID, outmsg.str().c_str());  // ERROR - attempting to execute a non-runtime phase - skipping
        return;
    }

    for (unsigned int i = 0; i < _comp_callback_vec.size(); i++)
    {
        pcomp = _comp_callback_vec[i];
        if (_state == UVM_PHASE_EXECUTING)
            process_state_executing_runtime(pcomp);
        else
            process_state_non_executing(pcomp);
    }

    //  Call any registered component methods once per 'state'
    if(!_state_callback_notified)
    {
        p_callback_agent = _callback_map[_state];
        p_callback_agent->notify(this);
        _state_callback_notified = true;
    }
}

//------------------------------------------------------------------------------
// Function: execute_nonruntime_phase
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::execute_nonruntime_phase(sc_core::sc_module * pmod)
{
    std::ostringstream outmsg;
    puvm_phase_callback_agent p_callback_agent;

    if (_type == UVM_RUNTIME_PHASE) 
    {
        outmsg << _name << endl;
        SC_REPORT_WARNING(UVM_PHASE_TYPE_INVALID, outmsg.str().c_str());  // ERROR - attempting to execute a runtime phase - skipping
        return;
    }

    sc_get_curr_simcontext()->hierarchy_push(pmod);

    if (_order == UVM_TOP_DOWN)
        execute_topdown_phase(pmod);
    else
        execute_bottomup_phase(pmod);

    sc_get_curr_simcontext()->hierarchy_pop();

    //  Call any registered component methods once per 'state'
    if(!_state_callback_notified)
    {
        p_callback_agent = _callback_map[_state];
        p_callback_agent->notify(this);
        _state_callback_notified = true;
    }
}

//------------------------------------------------------------------------------
// Function: execute_topdown_phase
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::execute_topdown_phase(sc_core::sc_module *pmod)
{
    assert(pmod != NULL);

    std::vector<sc_core::sc_module*> child_vec;

    if (_state == UVM_PHASE_EXECUTING)
    {
        process_state_executing_nonruntime(pmod);
    }
    else
    {
        uvm_component * pcomp = DCAST<uvm_component*>(pmod);
        if (pcomp != NULL)
            process_state_non_executing(pcomp);
    }

    // Find child and recursively call child
    child_vec = uvm_get_children(pmod);
    for (unsigned int i = 0; i < child_vec.size(); i++)
    {
        sc_get_curr_simcontext()->hierarchy_push(child_vec[i]);
        execute_topdown_phase(child_vec[i]);
        sc_get_curr_simcontext()->hierarchy_pop();
    }
}

//------------------------------------------------------------------------------
// Function: execute_bottomup_phase
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::execute_bottomup_phase(sc_core::sc_module *pmod)
{
    assert(pmod != NULL);

    std::vector<sc_core::sc_module*> child_vec;

    // Find child and recursively call child
    child_vec = uvm_get_children(pmod);
    for (unsigned int i = 0; i < child_vec.size(); i++)
    {
        sc_get_curr_simcontext()->hierarchy_push(child_vec[i]);
        execute_bottomup_phase(child_vec[i]);
        sc_get_curr_simcontext()->hierarchy_pop();
    }

    if (_state == UVM_PHASE_EXECUTING)
    {
        process_state_executing_nonruntime(pmod);
    }
    else
    {
        uvm_component * pcomp = DCAST<uvm_component*>(pmod);
        if (pcomp != NULL)
            process_state_non_executing(pcomp);
    }
}

//------------------------------------------------------------------------------
// Function: process_state_executing_runtime
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::process_state_executing_runtime(uvm_component *pcomp)
{
    // Note:  By default, there is nothing to do during the 'execute' state
    //        Rely on derived class to assign 'executing' behaviour


//    assert(pcomp != NULL);
//
//    if (pcomp != NULL)
//      pcomp->phase_execute(this);
}

//------------------------------------------------------------------------------
// Function: process_state_executing_nonruntime
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::process_state_executing_nonruntime(sc_core::sc_module * pmod)
{
    // Note:  By default, there is nothing to do during the 'execute' state
    //        Rely on derived class to assign 'executing' behaviour


//    assert(pmod != NULL);
//
//    uvm_component* pcomp = DCAST<uvm_component*>(pmod); 
//    if (pcomp != NULL)
//      pcomp->phase_execute(this);
}

//------------------------------------------------------------------------------
// Function: process_state_non_executing
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_phase::process_state_non_executing(uvm_component * pcomp)
{
    if (pcomp == NULL) return;

    switch(_state)
    {
    case UVM_PHASE_STARTED:
        pcomp->phase_started(this); 
        break;
    case UVM_PHASE_READY_TO_END:
        pcomp->phase_ready_to_end(this); 
        break;
    case UVM_PHASE_ENDED:
        pcomp->phase_ended(this); 
        break;
    default:
        break;
    }
}

//------------------------------------------------------------------------------
// Function: sync_phase
//  Add synchronization points to this phase
//
// Parameters:
//  phase - phase that this phase will sync to
//  sync_point - which point to sync at (starting phase, or ending phase)
//------------------------------------------------------------------------------
void uvm_phase::sync_phase(uvm_phase* phase, uvm_sync_point sync_point)
{
    if (sync_point == UVM_SYNC_AT_START)
        _sync_at_start_phase_vec.push_back(phase);
    else
        _sync_at_end_phase_vec.push_back(phase);
}

//------------------------------------------------------------------------------
// Function: is_started
//  Is this phase started?  
//
// Returns:
//  Returns true if this phase is ready to start.  If the phase has already
//  started or has ended (sync point has passed), then it's considered ready 
//  ready to start.
//------------------------------------------------------------------------------
bool uvm_phase::is_started()
{
    return (_state != UVM_PHASE_DORMANT);
}

//------------------------------------------------------------------------------
// Function: is_ready_to_end
//  Is this phase ready to end?  
//
// Returns:
//  Returns true if this phase is ready to end.
//  barrrier is down for the phase, it's not in the DORMANT, OR STARTED
//  state
//------------------------------------------------------------------------------
bool uvm_phase::is_ready_to_end()
{
    bool bcorrect_state = _state != UVM_PHASE_DORMANT ||
                          _state != UVM_PHASE_STARTED;

    return ( bcorrect_state &&
             barrier.get_num_barriers() == 0 );
}

//------------------------------------------------------------------------------
// Function: get_callback_agent
//  Returns the pointer to the callback agent of a particular type
//
// Returns:
//  callback_agent* - pointer to the callback agnet
//------------------------------------------------------------------------------
puvm_phase_callback_agent uvm_phase::get_callback_agent(uvm_phase_state state)
{
    return _callback_map[state];
}

//------------------------------------------------------------------------------
// Function: register_comp_callback
//  Register component callback to all states of this phase
//
// Parameters:
//  comp* - pointer to the component
//------------------------------------------------------------------------------
void uvm_phase::register_comp_callback(uvm_component *pcomp)
{
    _comp_callback_vec.push_back(pcomp);
}

//------------------------------------------------------------------------------
// Function: is_sync_point_ready
//  Check to see if phases that this phase is sync to, is ready to proceese
//
// Parameters:
//  sync_point - sync at start or sync at end
//------------------------------------------------------------------------------
bool uvm_phase::is_sync_point_ready(uvm_sync_point sync_point)
{
    unsigned int i;
    uvm_phase* pphase;
    bool bready = true;

    if (sync_point == UVM_SYNC_AT_START)
    {
        for (i = 0; i < _sync_at_start_phase_vec.size(); i++)
        {
            pphase = _sync_at_start_phase_vec[i];
            bready = bready && pphase->is_started();
        }
    }
    else
    {
        for (i = 0; i < _sync_at_end_phase_vec.size(); i++)
        {
            pphase = _sync_at_end_phase_vec[i];
            bready == bready && pphase->is_ready_to_end();
        }
    }

    return bready;
}

//------------------------------------------------------------------------------
// Function: wait_started()
//  Wait until phase is ready to start - all sync phases are ready to start
//------------------------------------------------------------------------------
void uvm_phase::wait_started()
{
    uvm_phase* pphase;

    for (unsigned int i = 0; i < _sync_at_start_phase_vec.size(); i++)
    {
        pphase = _sync_at_start_phase_vec[i];
        if (!pphase->is_started())
            ::sc_core::wait(pphase->started_ev);    
    }
}

//------------------------------------------------------------------------------
// Function: wait_ready_to_end()
//  Wait until phase is ready to end - all sync phases are ready to end
//------------------------------------------------------------------------------
void uvm_phase::wait_ready_to_end()
{
    uvm_phase* pphase;

    for (unsigned int i = 0; i < _sync_at_end_phase_vec.size(); i++)
    {
        pphase = _sync_at_end_phase_vec[i];
        if (!pphase->is_ready_to_end())
            pphase->barrier.wait();    
    }
}

} // namespace




