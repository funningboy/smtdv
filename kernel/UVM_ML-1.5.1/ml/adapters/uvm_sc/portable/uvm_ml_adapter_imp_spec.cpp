//----------------------------------------------------------------------
//   Copyright 2010 Cadence Design Systems, Inc.
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

/*! \file osci/uvm_ml_adapter_imp_spec.cpp
  \brief OS specific variant of adapter code.
*/
#include "common/uvm_ml_adapter.h"
#include "common/uvm_ml_hierarchy.h"

namespace uvm_ml {
    void uvm_ml_run_test(const std::vector<std::string>& tops,  const char * test) {
        int top_n = tops.size();
        const char ** local_tops = new const char*[top_n];
        const sc_time & duration = sc_time(~sc_dt::UINT64_ZERO, false) - sc_time_stamp(); 

        for (int i = 0; i < top_n; ++i) {
            local_tops[i] = tops[i].c_str();
        }
        BP(run_test)(framework_id, top_n, const_cast<char**>(local_tops), const_cast<char*>(test));
        sc_start(duration);
        delete[] local_tops;
        
    }


extern void report_tlm1_error(uvm_ml_tlm_receiver_base* rec);
static void dpi_task_disabled() {
    return;
}

bool uvm_ml_utils::reset_detected() {
    return false;
}

void handle_sc_kernel_exception_message
(
  uvm_ml_kernel_exception_message message,
  const char* string1,
  const char* string2
) {

  char msg[1024];
  switch (message) {

    case UVM_ML_CREATE_SC_INST:
      sprintf(msg, "\nSystemC module defname is '%s' \nHDL instname is '%s'",
              string1, string2
             );
      SC_REPORT_ERROR(msg,"\n");
      break;

    case UVM_ML_CREATE_SC_INST_2:
      sprintf(msg, "instname is '%s'", string1);
      SC_REPORT_ERROR(msg,"\n");
      break;

    case UVM_ML_QUASI_STATIC_ELABORATION:
      SC_REPORT_ERROR("SC_ID_COSIM_ERR_IN_QUASI_STATIC_ELAB","\n");
      CURRENT_SIMCONTEXT_SET_ERROR();
      break;

    default:
      assert(false);
      break;
  }      
}

} // namespace uvm_ml

int uvm_ml_tlm_rec::startup() {
    uvm_ml_utils::m_quasi_static_elaboration_started = true;
    return 1;
}

void uvm_ml_tlm_rec::sim_bootstrap() {
}


const std::string& uvm_ml_utils::get_systemc_separator() { 
#ifdef MTI_SYSTEMC
    static const std::string separator("/");
#else
    static const std::string separator(".");
#endif
    return separator;
}

void uvm_ml_tlm_transrec_base::object(sc_object* b) {
  sc_module* m = NULL;
  m_obj = b;
  uvm_ml_utils::add_transrec_to_map(m_obj, this);
  if (is_transmitter()) {
    sc_object* obj = b->get_parent();
    while (obj) {
        //      if (typeid(*obj) == typeid(parent_component_proxy)) return; // Parent proxy shall not be registered as a root node
      sc_module* mm = DCAST<sc_module*>(obj);
      if (!mm) break;
      m = mm;
      obj = obj->get_parent();
    }
    if (m) uvm_ml_utils::register_static_top(m->name());
  }
}

void uvm_ml_tlm_receiver_base::bind_export(sc_export_base* b) { 
  sc_module* top;
  object(b);
  m_iface = b->get_interface();
  sc_object* obj = b->get_parent(); 
  while (obj) { 
      //    if (typeid(*obj) == typeid(parent_component_proxy)) return; // Parent proxy shall not be registered as a root node
    sc_module* mm = DCAST<sc_module*>(obj); 
    if (!mm) break;
    top = mm; 
    obj = obj->get_parent();
  } 
  uvm_ml_utils::register_static_top(top->name());
}


namespace uvm_ml {
 int associate_module(const char*  name, uvm_ml_new_module_func f) { 
   if (!new_module_funcs) { 
    new_module_funcs = new sc_strhash<uvm_ml_new_module_func>(); 
   } 
   new_module_funcs->insert((char*)name,f); 
   return 0; 
 }
}
static std::string replaceCharByChar(
  const std::string& s,
  char oldChar,
  char newChar
) {
  std::string ss = s.c_str();
  for (unsigned i = 0; i < s.length(); i++) {
    if (s[i] == oldChar) {
      ss[i] = newChar;
    }
  }
  return ss;
}

const char SC_HIERARCHY_SUBSTITUTION_CHAR = '$';

static std::string purify_name(std::string name) {
  std::string pname = replaceCharByChar(
    name,
    SC_HIERARCHY_CHAR,
    SC_HIERARCHY_SUBSTITUTION_CHAR
  );
  return pname;
}



