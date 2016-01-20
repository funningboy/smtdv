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

/*! \file ncsc/uvm_ml_adapter_imp_spec.cpp
  \brief OS specific variant of adapter code.
*/

#include <dlfcn.h>



namespace uvm_ml {
	int uvm_ml_tlm_transmitter_base::counter = 0;
    void uvm_ml_run_test(const std::vector<std::string>& tops, const char * test) {
    }

    static void dpi_task_disabled() { 
        //uvm_ml_ncsc_dpi_task_disabled();
    }

} // namespace uvm_ml

int uvm_ml_tlm_rec::startup() {
    try { 
        ::sc_core::uvm_ml_api::quasi_static_startup();  
    } UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION,0,0,0);
    uvm_ml_utils::m_quasi_static_elaboration_started = true;
    return 1;
}


#define UVM_ML_CATCH_SC_KERNEL_EXCEPTION_2(n, s1, s2) \
catch( const sc_report& x ) \
{ \
  std::cout << x.what() << std::endl; \
} \
catch( const ::std::exception& x ) \
{ \
  std::cout << x.what() << std::endl; \
} \
catch( const char* s ) \
{ \
  ::std::cout << "\n" << s << ::std::endl; \
} \
catch( ... ) \
{ \
  ::std::cout << "\n" << "UNKNOWN EXCEPTION OCCURED" << ::std::endl; \
}



void uvm_ml_tlm_rec::sim_bootstrap() {
  try {
      ::sc_core::uvm_ml_api::quasi_static_sim_bootstrap();
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_2(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0)
}



namespace uvm_ml {
    bool in_elaboration() { 
        void *handle = dlopen(0, RTLD_NOW);
        if (handle == NULL) { 
            return false; //?
        }

        void *function_ptr = dlsym(handle,"udmInit");
        dlclose(handle);
        
        return (function_ptr == NULL); // ncelab doesn't contain udmInit
    }


    void uvm_ml_bootstrap(void* /* scSessionArgumentsT* */ /*sessionArguments*/) {
        if (in_elaboration()) return;

        framework_id = uvm_ml_utils::initialize_adapter();
        
    }



bool uvm_ml_utils::reset_detected() {
    return false;
}

const string & uvm_ml_utils::get_systemc_separator() {
    static string s = string(".");
    return s;
}

} // namespace uvm_ml





void uvm_ml_tlm_transrec_base::object(sc_object* b) {
  sc_module* m;
  m_obj = b;
  uvm_ml_utils::add_transrec_to_map(m_obj, this);
  if (is_transmitter()) {
    m = b->get_top_parent_module();
    if (m) uvm_ml_utils::register_static_top(m->name());
  }
}

void uvm_ml_tlm_receiver_base::bind_export(sc_export_base* b) { 
  sc_module* top;
  object(b);
  m_iface = b->get_interface();
  top = b->get_top_parent_module();
  uvm_ml_utils::register_static_top(top->name());
}


extern "C" void ml_uvm_bootstrap(void* /* scSessionArgumentsT* */ sessionArguments) {
  uvm_ml::uvm_ml_bootstrap(sessionArguments);
}
