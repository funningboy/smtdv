#ifndef __UVM_ML_SYNC__
#define __UVM_ML_SYNC__

#include "bp_provided.h"
#include <set>

namespace uvm_ml {

class uvm_ml_sync {

public:
  static void pre_sync (uvm_ml_time_unit    time_unit,
                        double              time_value);
  static void post_sync ();
  static void sync(uvm_ml_time_unit    time_unit,
                   double              time_value,
                   void *              cb_data = 0);
  static void initialize(bp_api_struct *bp_provided_api);
  

private:
  static bp_api_struct * _bp_provided_api;

  static std::set<double> _timeset;
};

}

#endif
