//----------------------------------------------------------------------
//   Copyright 2009 Cadence Design Systems, Inc.
//   Copyright 2013 Advanced Micro Devices Inc.
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

/*! \file uvm_manager.h
  \brief Central manager of UVM-SC global functions.
*/

#ifndef UVM_PHASE_CONTROLLER_H
#define UVM_PHASE_CONTROLLER_H


#include "sysc/kernel/sc_event.h"
#include "sysc/kernel/sc_join.h"
#include "uvm_schedule.h"

//////////////

namespace uvm {

class uvm_manager;
class uvm_component;
class uvm_schedule;
class uvm_common_schedule;


typedef enum {
    UVM_SC_STOP,
    UVM_NO_SC_STOP
} stop_mode_enum;

typedef enum {
    UVM_STOP_REASON_DURATION_COMPLETE,
    UVM_STOP_REASON_GLOBAL_TIMEOUT,
    UVM_STOP_REASON_PHASE_COMPLETE,
    UVM_STOP_REASON_USER_REQUEST,
    UVM_STOP_REASON_PRERUN_PHASE_FATAL,
    UVM_STOP_REASON_POSTRUN_PHASE_FATAL,
    UVM_STOP_REASON_RUN_PHASE_FATAL,
    UVM_STOP_REASON_MAX_ERRORS
} stop_reason_enum;


//------------------------------------------------------------------------------
//
// CLASS: uvm_phase_controller
//
// Internal implementation class.
// Stand-alone phase controller for UVM-SC
// A singleton instance of this class is created for a given simulation run.
//
//------------------------------------------------------------------------------

/*! \class uvm_phase_controller
  \brief Stand-alone phase controller for UVM-SC

  A singleton instance of this class is created for a given simulation run
*/

class uvm_phase_controller;
typedef uvm_phase_controller *puvm_phase_controller;


class uvm_phase_controller {
public:

    static uvm_phase_controller* get_phase_controller();

    bool add_schedule(uvm_schedule* schedule);
    const std::vector<uvm_schedule*> get_schedules(void);
    uvm_schedule* get_schedule_by_name(std::string name);

    stop_reason_enum start(void);        // active mode only
    // TODO - should this be moved from uvm_schedule?
    //stop_reason execute_phase(pscheule, pphase, pstate, pmod);  // active mode only

    void set_stop_mode(stop_mode_enum mode = UVM_SC_STOP);
    void set_global_timeout(sc_core::sc_time t);
    void set_duration(sc_core::sc_time t);

    // Temporarily allow users to stop run - normally a protected method
    void stop_run(stop_reason_enum reason);

    stop_mode_enum   get_stop_mode(void);
    sc_core::sc_time get_global_timeout(void);
    sc_core::sc_time get_duration(void);


protected:

    uvm_phase_controller();
    ~uvm_phase_controller();

    void do_prerun();
    void do_run();
    void do_postrun();
    

    void wait_for_global_timeout();
    void wait_for_run_phases();

    void print_stop_reason(stop_reason_enum reason);
  
protected:

    static uvm_phase_controller* m_phase_controller;
         
    stop_mode_enum                  m_stop_mode;
    stop_reason_enum                m_stop_reason;  
    sc_core::sc_time                m_global_timeout;
    sc_core::sc_time                m_duration;
    sc_core::sc_join                m_join_run;
    std::vector<uvm_schedule*>      m_schedules;

    uvm_common_schedule * m_pcommon_schedule;
    uvm_common_schedule * m_puvm_schedule;

};

inline
uvm_phase_controller* get_uvm_phase_controller() {
    return uvm_phase_controller::get_phase_controller();
}

} // namespace uvm

#endif
