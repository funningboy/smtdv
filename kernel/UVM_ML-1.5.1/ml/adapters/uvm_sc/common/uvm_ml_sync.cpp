#include "uvm_ml_sync.h"
#include "systemc.h"
#include "uvm_imp_spec_macros.h"
#include "uvm_ml_adapter.h"

using namespace uvm_ml;

bp_api_struct * uvm_ml_sync::_bp_provided_api = NULL;
std::set<double> uvm_ml_sync::_timeset;

void uvm_ml_sync::pre_sync (uvm_ml_time_unit    time_unit,
                            double              time_value)
{


  if (sc_is_running()) {

    if (((unsigned) time_unit) <= ((unsigned) (sc_time_unit) SC_SEC)) {
        sc_time delta = sc_time(time_value, (sc_time_unit)time_unit) - sc_time_stamp();
        if(delta.to_double() != 0)
            UVM_SC_CO_SIMULATE(delta);
        else
            UVM_SC_CO_SIMULATE(SC_ZERO_TIME);
    }
    else
        UVM_SC_CO_SIMULATE(SC_ZERO_TIME);
  }
}

void uvm_ml_sync::post_sync ()
{
  if (sc_is_running()) {
    CO_SIMULATION_EXECUTE_DELTA();
#if (defined(SC_VERSION_MAJOR) && (SC_VERSION_MAJOR >= 2)) && (defined(SC_VERSION_MINOR) && SC_VERSION_MINOR >= 3)
    while (sc_pending_activity_at_future_time()) {
       sc_time pend = sc_time_to_pending_activity();
       if(pend == SC_ZERO_TIME)
       {
	 CO_SIMULATION_EXECUTE_DELTA();
       } else {
         sc_time next = pend + sc_time_stamp();
         unsigned framework_id  = uvm_ml_utils::FrameworkId();

         std::set<double>::iterator it;
         it = _timeset.find(next.to_double());
         if(it == _timeset.end())
         {
            // new time wakeup request:  insert into timeset and register callback
            _timeset.insert(it, next.to_double());
            (*_bp_provided_api->register_time_cb_ptr)(framework_id, TIME_UNIT_SEC, next.to_seconds(), NULL);
         }
	 break;
       }
    } 
#endif
  }
}


void uvm_ml_sync::sync (uvm_ml_time_unit    time_unit,
                        double              time_value,
                        void *              cb_data)
{
    // Pre sync
    ENTER_CO_SIMULATION_CONTEXT();

    sc_time current_time = sc_time_stamp();

    // Remove time from 'set' based on current timestamp of notification
    std::set<double>::iterator it;
    it = _timeset.find(current_time.to_double());
    if(it != _timeset.end())
        _timeset.erase(it);

    // Post sync
    EXIT_CO_SIMULATION_CONTEXT();
}

void uvm_ml_sync::initialize(bp_api_struct *bp_provided_api) {
  _bp_provided_api = bp_provided_api;
}

//---------------------------------------------
// Private methods
//---------------------------------------------


