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

/*! \file uvm_common_phase.cpp
  \brief Implementation of UVM-ML phasing.
*/
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include <algorithm>
#include "base/uvm_common_phase.h"
#include "base/uvm_component.h"
#include "base/uvm_schedule.h"
#include "base/uvm_globals.h"
#include "base/uvm_ids.h"
#include "uvm_imp_spec_macros.h"

namespace uvm {

using std::string;

//------------------------------------------------------------------------------
// Constructor: uvm_common_phase
//------------------------------------------------------------------------------
uvm_common_phase::uvm_common_phase(string name, uvm_schedule *p_schedule, uvm_phase_type type, uvm_phase_order phase_order) :
    uvm_phase(name, p_schedule, type, phase_order)
{

}

//------------------------------------------------------------------------------
// Destructor: uvm_common_phase
//------------------------------------------------------------------------------
uvm_common_phase::~uvm_common_phase()
{
}


//------------------------------------------------------------------------------
// Function: process_state_executing_runtime
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_common_phase::process_state_executing_runtime(uvm_component *pcomp)
{
    std::ostringstream outmsg;
    sc_process_handle process_handle;

    // TODO: what should we do about process handle??
    //       should we even spawn it?  or let phase_execute spawn it?

    if (_name.compare("run") == 0) 
    {
        process_handle = sc_spawn(sc_bind(&uvm_component::run_phase, pcomp, this));
        pcomp->set_run_handle(process_handle);
    }
    else if (_name.compare("reset") == 0) 
    {
        process_handle = sc_spawn(sc_bind(&uvm_component::reset_phase, pcomp, this));
        pcomp->set_reset_handle(process_handle);
    }
    else if (_name.compare("configure") == 0) 
    {
        process_handle = sc_spawn(sc_bind(&uvm_component::configure_phase, pcomp, this));
        pcomp->set_configure_handle(process_handle);
    }
    else if (_name.compare("main") == 0) 
    {
        process_handle = sc_spawn(sc_bind(&uvm_component::main_phase, pcomp, this));
        pcomp->set_main_handle(process_handle);
    }
    else if (_name.compare("shutdown") == 0) 
    {
        process_handle = sc_spawn(sc_bind(&uvm_component::shutdown_phase, pcomp, this));
        pcomp->set_shutdown_handle(process_handle);
    }
    else
    {
        outmsg << _name << endl;
        SC_REPORT_FATAL(UVM_PHASE_UNKNOWN, outmsg.str().c_str());
        exit(1);        // TODO - is 'exit()' needed here after a FATAL?
    }
}

//------------------------------------------------------------------------------
// Function: process_state_executing_nonruntime
//
// Parameters:
//------------------------------------------------------------------------------
void uvm_common_phase::process_state_executing_nonruntime(sc_core::sc_module *pmod)
{
    std::ostringstream outmsg;

    if (get_phase_type() != UVM_POSTRUN_PHASE) { // postrun phases are not generalized yet
        int result = do_execute(pmod);

        if (result && (CHECK_STOP_AT_PHASE_END() == true)) {
            SC_REPORT_INFO(UVM_PHASE_CTRL_STOP_USER, "");
#ifdef UVM_ML_PORTABLE
            // TODO - should be be incorporated into the phase controller instead?
            sc_get_curr_simcontext()->stop();
#endif
	    //  result = 0;
        }
    }
    else {
        uvm_component* pcomp = DCAST<uvm_component*>(pmod); 
        if (pcomp != NULL) {
            if (_name.compare("final") == 0)
                pcomp->final_phase(this);
            else if (_name.compare("extract") == 0)
                pcomp->extract_phase(this);
            else if (_name.compare("check") == 0)
                pcomp->check_phase(this);
            else if (_name.compare("report") == 0)
                pcomp->report_phase(this);
            else
            {
                outmsg << _name << endl;
                SC_REPORT_FATAL(UVM_PHASE_UNKNOWN, outmsg.str().c_str());
                exit(1);        // TODO - is 'exit()' needed here after a FATAL?
            }
        }
    }
}

//------------------------------------------------------------------------------
// Phase specific functionality
//------------------------------------------------------------------------------

int uvm_build_phase::do_execute(sc_core::sc_module * pmod)
{
    int result = 1;
    try
    {
        NODE_CONSTRUCTION_DONE(pmod) // Calls construction_done() callback
                                     // For non-uvm_component sc_module - 
                                     // that directly calls before_end_of_elaboration()
                                     // For uvm_component it calls build() which, 
                                     // if not overriden, invokes before_end_of_elaboration()
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}

int uvm_build_phase::end()
{
    int result = 1;
    try
    {
#ifndef SIMCONTEXT_EXTENSIONS_OUT
        QUASI_STATIC_END_OF_CONSTRUCTION()
#endif
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}

int uvm_connect_phase::do_execute(sc_core::sc_module * pmod)
{
    int result = 1;
    try
    {
        NODE_CONNECT(pmod)
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}

int uvm_end_of_elaboration_phase::do_execute(sc_core::sc_module * pmod)
{
    int result = 1;
    try
    {
        NODE_END_OF_ELABORATION(pmod)
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}

int uvm_end_of_elaboration_phase::end()
{
    int result = 1;
    try
    {
        QUASI_STATIC_END_OF_ELABORATION()
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}

int uvm_start_of_simulation_phase::do_execute(sc_core::sc_module * pmod)
{
    int result = 1;
    try
    {
        NODE_START_OF_SIMULATION(pmod)
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}

int uvm_start_of_simulation_phase::end()
{
    int result = 1;
    try
    {
#ifndef SIMCONTEXT_EXTENSIONS_OUT
        QUASI_STATIC_START_OF_SIMULATION()
#endif
    }
    catch (int)
    {
        result = 0;
    }
    return result;
}


} // namespace




