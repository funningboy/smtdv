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

/*! \file uvm_schedule.cpp
  \brief Implementation of the UVM-SC schedule.
*/
#define SC_INCLUDE_DYNAMIC_PROCESSES
#include <algorithm>

#include "base/uvm_schedule.h"
#include "base/uvm_globals.h"
#include "base/uvm_ids.h"
#include "base/uvm_component.h"
#include "uvm_imp_spec_macros.h"


namespace uvm {

using std::string;

//------------------------------------------------------------------------------
// Constructor: uvm_schedule
//------------------------------------------------------------------------------
uvm_schedule::uvm_schedule(sc_module_name name) :
    sc_module(name),
    _top_phase(NULL),
    _next_phase(NULL),
    _current_phase(NULL),
    _bcontinue(true),
    _bsim_start(false),
    _name(name)

{
}

//------------------------------------------------------------------------------
// Destructor: uvm_schedule
//------------------------------------------------------------------------------
uvm_schedule::~uvm_schedule()
{
    std::map<std::string, uvm_phase*>::iterator it;

    for (it = _phase_map.begin(); it != _phase_map.end(); it++)
    {
        if (it->second != NULL)
            delete it->second;
    }
    _phase_map.clear();
}
//------------------------------------------------------------------------------
// Method:  get_name
//------------------------------------------------------------------------------
string uvm_schedule::get_name()
{
    return _name;
}


//------------------------------------------------------------------------------
// Function: set_top_phase
//   Set the starting phase for this schedule
//
// Parameters:
//   name - name of top phase
//------------------------------------------------------------------------------
void uvm_schedule::set_top_phase(string name)
{
    std::ostringstream   outmsg;

    _top_phase = _phase_map[name];
    _current_phase = _top_phase;

    if (_top_phase == NULL)
    {
        outmsg << name << endl;
        SC_REPORT_FATAL(UVM_PHASE_UNKNOWN, outmsg.str().c_str());
    }
}

//------------------------------------------------------------------------------
// Function: set_top_phase
//   Set the starting phase for this schedule
//
// Parameters:
//   phase - pointer to phase
//------------------------------------------------------------------------------
bool uvm_schedule::set_top_phase(uvm_phase* phase)
{
    set_top_phase(phase->get_name());
    return true;  // FIXME
}

//------------------------------------------------------------------------------
// Function: get_current_phase
//   Returns pointer to the current phase
//
// Returns:
//   phase - pointer to current phase
//------------------------------------------------------------------------------
uvm_phase* uvm_schedule::get_current_phase()
{
    return _current_phase;
}

//------------------------------------------------------------------------------
// Function: set_current_phase
//   Sets the current phase pointer
//
// Paramters:
//   phase - pointer to phase to set as current phase
//
// Returns:
//   phase - pointer to current phase
//------------------------------------------------------------------------------
uvm_phase* uvm_schedule::set_current_phase(uvm_phase *phase)
{
    _current_phase = phase;
    return _current_phase;
}


//------------------------------------------------------------------------------
// Function: set_current_phase
//   Sets the current phase pointer
//
// Paramters:
//   phase - name of phase to set as the current phase
//
// Returns:
//   phase - pointer to current phase
//------------------------------------------------------------------------------
uvm_phase* uvm_schedule::set_current_phase(string phase)
{
    _current_phase = _phase_map[phase];
    return _current_phase;
}


//------------------------------------------------------------------------------
// Function: add_phase
//   Add a phase to the schedule and returns the phase pointer.
//
// Parameters:
//  name - name of phase to add
//
// Returns:
//   phase - pointer to phase
//------------------------------------------------------------------------------
uvm_phase* uvm_schedule::add_phase(string name, uvm_phase_type type, uvm_phase_order order)
{
    uvm_phase* phase;

    phase = new uvm_phase(name, this, type, order);
    _phase_map[name] = phase;

    return phase;
}

//------------------------------------------------------------------------------
// Function: add_phase
//   Add a phase to the schedule.
//
// Parameters:
//  phase - phase to be added
//
//------------------------------------------------------------------------------
void uvm_schedule::add_phase(uvm_phase* pphase)
{
    _phase_map[pphase->get_name()] = pphase;
}

//------------------------------------------------------------------------------
// Function: add_arc
//   Add an arc
//
// Parameters:
//  from_phase - name of phase arc starts from
//  to_phase   - name of phase arc goes to
//------------------------------------------------------------------------------
void uvm_schedule::add_arc(string from_phase, string to_phase, unsigned int priority)
{
    std::ostringstream   outmsg;
    uvm_phase* pfrom_phase = _phase_map[from_phase];
    uvm_phase* pto_phase   = _phase_map[to_phase];
    
    if (pfrom_phase == NULL)
    {
        outmsg << from_phase << endl;
        SC_REPORT_FATAL(UVM_PHASE_UNKNOWN, outmsg.str().c_str());
    }
    else if (pto_phase == NULL)
    {
        outmsg << to_phase << endl;
        SC_REPORT_FATAL(UVM_PHASE_UNKNOWN, outmsg.str().c_str());
    }
    else
        pfrom_phase->add_next_phase(pto_phase, priority);


}

//------------------------------------------------------------------------------
// Function: add_arc
//   Add an arc
//
// Parameters:
//  from_phase - pointer of phase arc starts from
//  to_phase   - pointer of phase arc goes to
//
// Returns:
//  status - return false if either phase pointer does not exists in the pool
//------------------------------------------------------------------------------
void uvm_schedule::add_arc(uvm_phase* pfrom_phase, uvm_phase* pto_phase, unsigned int priority)
{
    add_arc(pfrom_phase->get_name(), pto_phase->get_name(), priority);
}

//------------------------------------------------------------------------------
// Function: go_to_phase
//   Specify the next phase to go to.
//
// Parameters:
//  name - name of the phase to go to
//
//------------------------------------------------------------------------------
void uvm_schedule::go_to_phase(string name)
{
    std::ostringstream   outmsg;
    uvm_phase* pphase = _phase_map[name];

    if (pphase == NULL)
    {
        outmsg << name << endl;
        SC_REPORT_FATAL(UVM_PHASE_UNKNOWN, outmsg.str().c_str());
    }
    else
    {
        _current_phase->go_to_phase(pphase);
    }

}

//------------------------------------------------------------------------------
// Function: go_to_phase
//   Specify the next phase to go to.
//
// Parameters:
//  phase - pointer to phase to go to.
//------------------------------------------------------------------------------
void uvm_schedule::go_to_phase(uvm_phase* phase)
{
    go_to_phase(phase->get_name());
}


//------------------------------------------------------------------------------
// Function: get_phase
//   Returns a pointer to the name phase
//
// Parameters:
//  name - name of the phase to get
//
// Returns:
//  phase - pointer to named phase
//------------------------------------------------------------------------------
uvm_phase* uvm_schedule::get_phase(string name)
{
    return _phase_map[name];
}


//------------------------------------------------------------------------------
// Function: do_run()
//    Executes all the runtime phases of this schedule
//    This method is typically spawned from the phase controller
//
// Parameters:
//  none
//
// Returns:
//  none
//------------------------------------------------------------------------------
void uvm_schedule::do_run()
{
    if (_current_phase == NULL)
    {
        SC_REPORT_WARNING(UVM_PHASE_NULL,"");
        return;
    }

    while ((_current_phase != NULL) && (_current_phase->get_phase_type() == UVM_RUNTIME_PHASE))
    {
        execute_runtime_phase();
        update_phase_state();
    }
}


//------------------------------------------------------------------------------
// Function: update_phase_state
//   Move phase to the next state 
//
// TODO - This should method be moved inside the phase object
//------------------------------------------------------------------------------

uvm::uvm_phase_state uvm_schedule::update_phase_state()
{
    uvm_phase_state phase_state = _current_phase->get_phase_state();
    uvm_phase_state next_state  = UVM_PHASE_DORMANT;

    switch(phase_state)
    {
    case UVM_PHASE_DORMANT:
        _current_phase->set_phase_state(UVM_PHASE_STARTED);
        next_state = UVM_PHASE_STARTED;
        break;

    case UVM_PHASE_STARTED:
        _current_phase->set_phase_state(UVM_PHASE_EXECUTING);
        next_state = UVM_PHASE_EXECUTING;
        break;

    case UVM_PHASE_EXECUTING:
        _current_phase->set_phase_state(UVM_PHASE_READY_TO_END);
        next_state = UVM_PHASE_READY_TO_END;
        break;

    case UVM_PHASE_READY_TO_END:
        _current_phase->set_phase_state(UVM_PHASE_ENDED);
        next_state = UVM_PHASE_ENDED;
        break;

    case UVM_PHASE_ENDED:
        _current_phase->reset_phase();                      // reset phase in case it is re-entered
        _current_phase = _current_phase->get_next_phase();  // move to next scheduled phase
        next_state = UVM_PHASE_DONE;                        // indicate phase has completed 
        break;

    case UVM_PHASE_DONE:
        // Note:  This case will never be reached by the standalone phase controller - do nothing
        break;

    default:
        SC_REPORT_FATAL(UVM_PHASE_STATE_INVALID,"");
        break;
    };

    return next_state;
}


//------------------------------------------------------------------------------
// Function: execute_nonruntime_phase
//   Main execution for non-runtime phases
//
// TODO - This should method be moved inside the phase object
//------------------------------------------------------------------------------
void uvm_schedule::execute_nonruntime_phase(sc_core::sc_module *pmod)
{
    uvm_phase_state phase_state = _current_phase->get_phase_state();

    switch(phase_state)
    {
    case UVM_PHASE_DORMANT:
        break;

    case UVM_PHASE_STARTED:
        _current_phase->execute_nonruntime_phase(pmod);
        break;

    case UVM_PHASE_EXECUTING:
        _current_phase->execute_nonruntime_phase(pmod);
        break;

    case UVM_PHASE_READY_TO_END:
        // Note:  For pre-/post-run phases, there is nothing to do here
        //        Callbacks are not called for 'READY_TO_END' in pre/post
        break;

    case UVM_PHASE_ENDED:
        _current_phase->execute_nonruntime_phase(pmod);
        break;

    default:
        SC_REPORT_FATAL(UVM_PHASE_STATE_INVALID,"");
        break;
    };
}

//------------------------------------------------------------------------------
// Function: execute_runtime_phase
//   Main execution for runtime phases
//
// TODO - This should method be moved inside the phase object
//------------------------------------------------------------------------------
void uvm_schedule::execute_runtime_phase()
{
    bool bready;
    sc_process_handle barrier_h;
    uvm_phase_state phase_state = _current_phase->get_phase_state();
    sc_time dur(5, SC_NS);

    switch(phase_state)
    {
    case UVM_PHASE_DORMANT:
        break;

    case UVM_PHASE_STARTED:
        bready = _current_phase->is_sync_point_ready(UVM_SYNC_AT_START);
        if (!bready)
            _current_phase->wait_started();
        _current_phase->execute_runtime_phase();
        break;

    case UVM_PHASE_EXECUTING:
        _current_phase->execute_runtime_phase();
        barrier_h = sc_spawn(sc_bind(&uvm_schedule::wait_barrier, this));
        wait(barrier_h.terminated_event());
        bready = _current_phase->is_sync_point_ready(UVM_SYNC_AT_END);
        if (!bready)
            _current_phase->wait_ready_to_end();
        break;

    case UVM_PHASE_READY_TO_END:
        _current_phase->execute_runtime_phase();
        break;

    case UVM_PHASE_ENDED:
        _current_phase->execute_runtime_phase();
        break;

    default:
        break;
    };
}


//------------------------------------------------------------------------------
// Function: wait_barrier
//   Wait for barrier to be cleared
//------------------------------------------------------------------------------
void uvm_schedule::wait_barrier(void)
{
    // TODO - Do we need to wait() to allow all spawned threads to run?
    _current_phase->barrier.wait();
}

//------------------------------------------------------------------------------
// Function: set_max_runtime
//   Set the max_runtime for a phase state
//------------------------------------------------------------------------------
void uvm_schedule::set_max_runtime(sc_core::sc_time max_runtime)
{
    _max_runtime = max_runtime;
}

//------------------------------------------------------------------------------
// Function: set_continue
//   Set to true if the schedule should automatically continue to next state
//------------------------------------------------------------------------------
void uvm_schedule::set_continue(bool bcontinue)
{
    _bcontinue = bcontinue;
}

//------------------------------------------------------------------------------
// Function: start_of_simulation
//   Start of simulation call back from SystemC
//------------------------------------------------------------------------------
void uvm_schedule::start_of_simulation()
{
    _bsim_start = true;
    _sim_start_ev.notify();
}

//------------------------------------------------------------------------------
// Function: register_callback
//   Register component to all phases in schedule
//
// Parameter:
//   pcomp - ptr to component
//------------------------------------------------------------------------------
void uvm_schedule::register_callback(uvm_component* pcomp)
{
    std::map<string, uvm_phase*>::iterator it;

    for (it = _phase_map.begin(); it != _phase_map.end(); it++)
    {
        it->second->register_comp_callback(pcomp);
    }
}

//------------------------------------------------------------------------------
// Function: set_phase
// 
// Usage:  Called from external phase controller only to set the current phase
//
// Parameter: phase name / phase state
// Return:    pPhase if successful, NULL if no phase found or unsuccessful
//------------------------------------------------------------------------------
uvm_phase * uvm_schedule::set_phase(string phase_name, uvm_phase_state state)
{
    uvm_phase *pphase = _phase_map[phase_name]; 

    if (pphase == NULL)
        return NULL;

    _current_phase = pphase;
    return ((_current_phase->do_state(state) == 1) ? _current_phase : NULL);
}

//------------------------------------------------------------------------------
// Function: execute_quasi_static_phase
//   
//
// Parameter:
//------------------------------------------------------------------------------
int uvm_schedule::execute_quasi_static_phase(string phase_name, uvm_phase_state state)
{
    uvm_phase *pphase = _phase_map[phase_name]; 
    static bool bresolve_bindings = false;


    if ( (phase_name.compare("resolve_bindings") == 0) &&
         (state == UVM_PHASE_EXECUTING)  &&
         (bresolve_bindings == false) )
    {
        bresolve_bindings = true;
        QUASI_STATIC_COMPLETE_BINDING();
        return 1;
    }

    if (pphase == NULL)
    {
        return 1; // It's legitimate to receive notification about the unknown phase
    }

    _current_phase = pphase;
    _current_phase->set_phase_state(state);

    if (state == uvm::UVM_PHASE_STARTED)
        return _current_phase->start();
    else if (state == uvm::UVM_PHASE_ENDED)
        return _current_phase->end();
    else    
        return 1;
}

} // namespace




