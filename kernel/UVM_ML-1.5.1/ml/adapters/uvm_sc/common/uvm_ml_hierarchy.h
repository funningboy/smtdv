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

/*! \file uvm_ml_hierarchy.h
  \brief Header file for ML hierarchy.
*/
#ifndef UVM_ML_HIERARCHY_H
#define UVM_ML_HIERARCHY_H

#include "systemc.h"
#ifdef NC_SYSTEMC
#include "sysc/utils/sc_iostream.h"
#else
#include "sysc/kernel/sc_simcontext.h"
#endif
#include <typeinfo>
#include <stdio.h>
#include <map>

#include "uvm_ml_adapter_imp_spec_macros.h"
#include "uvm_ml_adapter_imp_spec_headers.h"
#include "uvm.h"

using namespace std;
using namespace uvm;

namespace uvm_ml {

class uvm_ml_special_component: public uvm_component
{
public:
  uvm_ml_special_component(const sc_module_name & name): uvm_component(name) {}
  virtual ~uvm_ml_special_component() {}
};

class child_component_proxy: public uvm_ml_special_component {
private:
  string       m_component_type_name;
  string       m_instance_name;
  string       m_parent_name;
  string       m_target_frmw_ind;
  int          m_child_junction_node_id;
  int          m_parent_id;
public:
  child_component_proxy(sc_module_name nm);
  child_component_proxy(sc_module_name nm, 
                        const string & target_framework_indicator, 
                        const string & component_type_name, 
                        const string & instance_name,
                        const string & parent_name);

  virtual ~child_component_proxy() {};

  bool request_create_child_junction_node(const string & target_framework_indicator, 
                                          const string & component_type_name, 
                                          const string & instance_name,
                                          const string & parent_name);

  void transmit_phase(uvm_phase *phase, unsigned int action);

  virtual void build_phase(uvm_phase *phase = NULL);
  virtual void connect_phase(uvm_phase *phase = NULL);
  virtual void end_of_elaboration_phase(uvm_phase *phase = NULL);
  virtual void start_of_simulation_phase(uvm_phase *phase = NULL);

  virtual void extract_phase(uvm_phase *phase);
  virtual void check_phase(uvm_phase *phase);
  virtual void report_phase(uvm_phase *phase);
  virtual void final_phase(uvm_phase *phase);

  virtual void phase_started(uvm_phase *phase);
  virtual void phase_ready_to_end(uvm_phase *phase);
  virtual void phase_ended(uvm_phase *phase);

  UVM_COMPONENT_UTILS(child_component_proxy)
};

}
#endif
