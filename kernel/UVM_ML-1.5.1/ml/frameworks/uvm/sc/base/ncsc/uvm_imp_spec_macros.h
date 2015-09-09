//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
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
/*! \file ncsc/uvm_imp_spec_macros.h
  \brief OS specific macro definitions.
*/
#ifndef UVM_ML_MACROS_H
#define UVM_ML_MACROS_H


#include "sysc/cosim/uvm_ml_api.h"

// FIXME
namespace sc_core { 
    class sc_report;
}




#define MARK_THREAD_INVISIBLE(o) o.hide_from_nc()
#define SC_MAX_TIME sc_cosim::max_time_that_wont_overflow_in_nc_resolution()
#define RESET_PROC_EXTERN(proc) \
        if (proc) \
      context->reset_curr_proc_extern()

#define SET_PROC_EXTERN(proc) \
    if (proc) \
      context->set_curr_proc_extern(proc)

#define CHECK_STOP_AT_PHASE_END() false // Patch not implemented yet

// It is a temporary limitation of the patch that the quasi-static phase can be executed only on uvm_component

#define NODE_CONSTRUCTION_DONE(pmod) { uvm_component* comp = DCAST<uvm_component*>(pmod); if (comp) { comp->build_phase(this); } else { uvm_ml_api::quasi_static_end_of_construction(pmod); } }



#define QUASI_STATIC_END_OF_CONSTRUCTION() uvm_ml_api::end_quasi_static_end_of_construction();

#define NODE_CONNECT(pmod) { uvm_component* comp = DCAST<uvm_component*>(pmod); if (comp) { comp->connect_phase(this); } else { uvm_ml_api::quasi_static_connect(pmod); } } 

#define QUASI_STATIC_COMPLETE_BINDING() uvm_ml_api::quasi_static_complete_binding();

#define NODE_END_OF_ELABORATION(pmod) { uvm_component* comp = DCAST<uvm_component*>(pmod); if (comp) { comp->end_of_elaboration_phase(this); } else { uvm_ml_api::quasi_static_end_of_elaboration(pmod); } }

#define QUASI_STATIC_END_OF_ELABORATION() uvm_ml_api::end_quasi_static_end_of_elaboration();

#define NODE_START_OF_SIMULATION(pmod) { uvm_component* comp = DCAST<uvm_component*>(pmod); if (comp) { comp->start_of_simulation_phase(this); } else { uvm_ml_api::quasi_static_start_of_simulation(pmod); } }

#define QUASI_STATIC_START_OF_SIMULATION() uvm_ml_api::end_quasi_static_start_of_simulation();

#define QUASI_STATIC_PREPARE_TO_SIMULATE() uvm_ml_api::quasi_static_prepare_to_simulate();

#define UVM_SC_CO_SIMULATE(duration)
#endif
