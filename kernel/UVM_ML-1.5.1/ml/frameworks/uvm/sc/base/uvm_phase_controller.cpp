//----------------------------------------------------------------------
//   Copyright 2009 Cadence Design Systems, Inc.
//   Copyright 2013 Advance Micro Devices, Inc
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

/*! \file uvm_phase_controller.cpp
  \brief Central phase controller for UVM-SC standalone mode 
*/

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include <systemc.h>

#include <algorithm>
#
#include "base/uvm_globals.h"
#include "base/uvm_ids.h"
#include "base/uvm_phase_controller.h"
#include "base/uvm_common_schedule.h"
#include "uvm_imp_spec_macros.h"
//#include "base/uvm_component.h"
//#include "uvm_imp_spec_macros.h"

using namespace sc_core;

namespace uvm {

//------------------------------------------------------------------------------
//
// uvm_phase_controller
//
// Internal implementation class.
//
//------------------------------------------------------------------------------

uvm_phase_controller* uvm_phase_controller::m_phase_controller = 0;

uvm_phase_controller* uvm_phase_controller::get_phase_controller() 
{
    if (m_phase_controller == 0) {
        m_phase_controller = new uvm_phase_controller();
    }
    return m_phase_controller;
}

uvm_phase_controller::uvm_phase_controller() 
{
    sc_time max_time; // the time at which sc_start() returns
    sc_time smallest_time = sc_get_time_resolution();


    m_stop_mode  = UVM_SC_STOP;
    m_stop_reason= UVM_STOP_REASON_DURATION_COMPLETE;


    max_time = SC_MAX_TIME;

    // TODO - Do we need to reduce the time here?  Post run is run after sc_stop anyway...
    // Original comment:
    // make the UVM timeouts be slightly less than when sc_start() returns
    // such that UVM is able to end the run phase
    m_global_timeout = max_time - smallest_time;
    m_duration = SC_MAX_TIME; 


    // Setup default common & uvm schedules (always present)
    m_pcommon_schedule = get_uvm_common_schedule();
    m_schedules.push_back(m_pcommon_schedule);

    m_puvm_schedule    = get_uvm_schedule();
    m_schedules.push_back(m_puvm_schedule);

}
 
uvm_phase_controller::~uvm_phase_controller() {
}


bool uvm_phase_controller::add_schedule(uvm_schedule* user_schedule) 
{
    // Note:  User schedule - only the 'do_run' method will be called
    //                      - hence only runtime phases will be executed

    std::string name = user_schedule->get_name();

    // Check that schedule name does not conflict with existing schedules (first come, first serve)
    for (unsigned int i = 0; i < m_schedules.size(); i++)
    {
        if (m_schedules[i]->get_name().compare(name) == 0)
            return false; 
    }

    // Valid user schedule - add to schedule vector
    m_schedules.push_back(user_schedule);
    return true;
}

const std::vector<uvm_schedule*> uvm_phase_controller::get_schedules(void) {
    return m_schedules;
}

uvm_schedule* uvm_phase_controller::get_schedule_by_name(std::string name) 
{
    for (unsigned int i = 0; i < m_schedules.size(); i++)
    {
        if (m_schedules[i]->get_name().compare(name) == 0)
            return m_schedules[i];
    }
    return NULL;
}


//-------------------------------
// Main Phase controller methods
//-------------------------------

stop_reason_enum uvm_phase_controller::start(void) 
{
    // Execute PRE_RUN common schedule - serially
    do_prerun();

    // Schedule RUN schedules
    do_run();

    // Start the simulation - execute spawned runtime schedules threads
    // sc_simcontext * context = sc_get_curr_simcontext();
    // context->co_simulate(m_duration);
    try
    {
        QUASI_STATIC_PREPARE_TO_SIMULATE();
        UVM_SC_CO_SIMULATE(m_duration);
    }
    catch(int)
    {
        m_stop_reason = UVM_STOP_REASON_RUN_PHASE_FATAL;
    }

    print_stop_reason(m_stop_reason);


    // Execute POST_RUN common schedule - serially
    do_postrun();

    return m_stop_reason;

}

void uvm_phase_controller::do_prerun(void) {

    std::string          phase_name;
    std::ostringstream   outmsg;
    uvm_phase_state state;
    uvm_phase *     pcurrent_phase = m_pcommon_schedule->get_current_phase();

    // Note:  Get all tops as pure sc_modules, in case they have uvm_comp children
    std::vector<sc_core::sc_module *> all_tops = uvm_get_tops();
    //int result;


    if (pcurrent_phase == NULL)
    {
        SC_REPORT_FATAL(UVM_PHASE_CTRL_PHASE_UNSPECIFIED,"");
        exit(1);
    }
    if(pcurrent_phase->get_phase_type() != UVM_PRERUN_PHASE) 
    {
        outmsg << pcurrent_phase->get_name() << endl;
        SC_REPORT_FATAL(UVM_PHASE_CTRL_PHASE_TYPE,outmsg.str().c_str());
        exit(1);
    }

    //  Loop over pre-run phases
    while((pcurrent_phase != NULL) &&(pcurrent_phase->get_phase_type() == UVM_PRERUN_PHASE))
    {
        phase_name = pcurrent_phase->get_name();
        state = pcurrent_phase->get_phase_state();

        // Loop over states per phase
        while(state != UVM_PHASE_DONE)
        {
            // For SystemC phases, call once per phase/state
            // TODO - check 'result' for errors (1=OK, 0=error)
            //result = m_pcommon_schedule->execute_quasi_static_phase(phase_name, state); 
            m_pcommon_schedule->execute_quasi_static_phase(phase_name, state); 

            for (unsigned int i = 0; i < all_tops.size(); i++)
            {
               m_pcommon_schedule->execute_nonruntime_phase(all_tops[i]);  // setting the phase state
               // TODO:  Any results to check here?
            }
            state = m_pcommon_schedule->update_phase_state();
        }
        pcurrent_phase = m_pcommon_schedule->get_current_phase();
    }

    // TODO - check for fatal errors here (try/catch?)
    //        Note:  Needs to work in ML as well...
}

void uvm_phase_controller::do_run(void) 
{

    sc_process_handle run_handle;
    sc_spawn_options o;
    
    MARK_THREAD_INVISIBLE(o);

    // spawn thread that will wait for m_global_timeout to expire
    sc_spawn(sc_bind(&uvm_phase_controller::wait_for_global_timeout, this),
            "uvm_wait_for_global_timeout",
            &o
    );

    // spawn UVM runtime schedules
    for (unsigned int i = 0; i < m_schedules.size(); i++)
    {
        run_handle = sc_spawn(sc_bind(&uvm_schedule::do_run, m_schedules[i]));
        m_join_run.add_process(run_handle);
    }

    // spawn thread that will wait for active runtime schedules to complete
    sc_spawn(sc_bind(&uvm_phase_controller::wait_for_run_phases, this),
            "uvm_wait_for_run_phases",
            &o
    );

    // TODO - spawn check for runtime fatal errors here (try/catch?)
    //        Note:  Needs to work in ML as well...
}


void uvm_phase_controller::do_postrun(void) 
{
    std::string     phase_name;
    std::ostringstream   outmsg;
    uvm_phase_state state;
    puvm_phase      pcurrent_phase = m_pcommon_schedule->get_current_phase();

    // Note:  Get all tops including pure sc_modules, in case they have uvm_comp children
    std::vector<sc_core::sc_module *> all_tops = uvm_get_tops();


    // Set common schedule to first postrun phase (ie. 'extract')
    // Note:  set to the first postrun phase after 'run' phase;
    //        accounts for cases where run phase terminates early due to timeout or errors 
    pcurrent_phase = m_pcommon_schedule->get_phase("extract");      // first postrun phase after run

    if (pcurrent_phase == NULL)
    {
        SC_REPORT_INFO(UVM_PHASE_CTRL_POST_RUN_NONE,"");
        return;     // No post-run schedules to execute
    }
    if(pcurrent_phase->get_phase_type() != UVM_POSTRUN_PHASE) 
    {
        outmsg << pcurrent_phase->get_name() << endl;
        SC_REPORT_FATAL(UVM_PHASE_CTRL_PHASE_TYPE,outmsg.str().c_str());
        exit(1);
    }
    m_pcommon_schedule->set_current_phase(pcurrent_phase);


    //  Loop over post-run phases
    while((pcurrent_phase != NULL) &&(pcurrent_phase->get_phase_type() == UVM_POSTRUN_PHASE))
    {
        phase_name = pcurrent_phase->get_name();
        state = pcurrent_phase->get_phase_state();

        while(state != UVM_PHASE_DONE)
        {
            for (unsigned int i = 0; i < all_tops.size(); i++)
            {
               m_pcommon_schedule->execute_nonruntime_phase(all_tops[i]);  // setting the phase state
               // TODO:  Any results to check here?
            }
            state = m_pcommon_schedule->update_phase_state();
        }
        pcurrent_phase = m_pcommon_schedule->get_current_phase();
    }

    // TODO - check for fatal errors here (try/catch?)
    //        Note:  Needs to work in ML as well...
}


//------------------------
// Setter/Getter Methods
//------------------------

void uvm_phase_controller::set_stop_mode(stop_mode_enum mode) {
    m_stop_mode = mode;
}

void uvm_phase_controller::set_global_timeout(sc_time t) {
    m_global_timeout = t;
}

void uvm_phase_controller::set_duration(sc_time t) {
    m_duration = t;
}

stop_mode_enum uvm_phase_controller::get_stop_mode() {
    return m_stop_mode;
}

sc_time uvm_phase_controller::get_global_timeout() {
    return m_global_timeout;
}

sc_time uvm_phase_controller::get_duration() {
    return m_duration;
}

//------------------------
// Spawned Methods
//------------------------

void uvm_phase_controller::wait_for_global_timeout() {
  
    // Since this thread may be spawned slightly later, get accurate timeout based on spawn time
    sc_time tdur = m_global_timeout - sc_time_stamp();

    wait(tdur);

    // global timeout has expired => run phase has ended
    SC_REPORT_WARNING(UVM_PHASE_CTRL_GLOBAL_TIMEOUT,"");
    stop_run(UVM_STOP_REASON_GLOBAL_TIMEOUT);
}

void uvm_phase_controller::wait_for_run_phases() 
{
    // wait for all spawned runtime schedules to complete their run phases
    if (m_join_run.process_count() > 0) {
        m_join_run.wait();
    }

    // all stop tasks have returned => end run phase
    stop_run(UVM_STOP_REASON_PHASE_COMPLETE);
}

void uvm_phase_controller::stop_run(stop_reason_enum reason) 
{
    static bool invoked = false; 

    if (!invoked) {
        invoked = true;
    } else {
        // stop_run() has already been called;
        // this can happen if uvm_stop_request has been called 
        // but the stop processes do not all return; then global_timeout and
        // stop_timeout will expire at same time, and both will call 
        // stop_run() 
        return;
    }

    m_stop_reason = reason;
    if (m_stop_mode == UVM_SC_STOP) {
        sc_stop();
    }
}

//------------------------
// Helper Methods
//------------------------

void uvm_phase_controller::print_stop_reason(stop_reason_enum reason)
{
    switch(m_stop_reason)
    {
        case UVM_STOP_REASON_DURATION_COMPLETE:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_DURATION,"");
            break;
        case UVM_STOP_REASON_GLOBAL_TIMEOUT:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_GLOBAL_TIMEOUT,"");
            break;
        case UVM_STOP_REASON_PHASE_COMPLETE:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_PHASE_COMPLETE,"");
            break;
        case UVM_STOP_REASON_USER_REQUEST:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_USER_REQUEST,"");
            break;
        case UVM_STOP_REASON_PRERUN_PHASE_FATAL:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_PRERUN_PHASE_FATAL,"");
            break;
        case UVM_STOP_REASON_POSTRUN_PHASE_FATAL:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_POSTRUN_PHASE_FATAL,"");
            break;
        case UVM_STOP_REASON_RUN_PHASE_FATAL:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_RUN_PHASE_FATAL,"");
            break;
        case UVM_STOP_REASON_MAX_ERRORS:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_MAX_ERRORS,"");
            break;
        default:
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_UNKNOWN,"");
            break;
    };

    return;
}


//////////

} // namespace uvm

