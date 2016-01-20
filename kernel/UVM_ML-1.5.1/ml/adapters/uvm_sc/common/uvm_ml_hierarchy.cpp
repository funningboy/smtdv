#include "uvm_ml_adapter_imp_spec_headers.h"
#include "uvm_ml_adapter_imp_spec_macros.h"
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

/*! \file uvm_ml_hierarchy.cpp
  \brief Implementation of ML hierarchy.
*/
#include <algorithm>
#include "uvm_ml_adapter.h"
#include "uvm_ml_hierarchy.h"
#include "common/uvm_ml_config_rsrc.h"
#include "bp_provided.h"

using namespace std;
using namespace uvm;

UVM_ML_EXTERN_SC_ENABLE_NAME_CHECKING

namespace uvm_ml {

class parent_component_proxy;

/*! \class uvm_ml_proxy_helper
  \brief helper class for creating the proxy hierarchy.

  
*/

class uvm_ml_proxy_helper: public uvm_ml_special_component 
{
public:
  uvm_ml_proxy_helper(const sc_module_name & name);
  uvm_ml_proxy_helper(const sc_module_name & name, const string & remaining_path);
  virtual ~uvm_ml_proxy_helper() {};

  parent_component_proxy * get_proxy() { return m_proxy; }

  virtual bool is_true_component() { return false; }

  UVM_COMPONENT_UTILS(uvm_ml_proxy_helper)
private:
  parent_component_proxy * m_proxy;
};

/*! \struct child_subtree_registry_class
  \brief Maintain the attributes of the child sub-tree.

  
*/
struct child_subtree_registry_class {
  uvm_component *          child_junction_node;
  vector <uvm_component *> descendants;
};

/*! \class parent_component_proxy
  \brief Parent proxy.

  
*/
class parent_component_proxy: public uvm_ml_special_component {
private:

  int                   m_proxy_id;
  int                   m_parent_framework_id;
  static                map<int /* parent junction node id */, parent_component_proxy *> parent_proxies;

  static parent_component_proxy * create_proxy_with_helpers(sc_module *    parent_helper,
                                                            const string & path);
public:
  parent_component_proxy(const sc_module_name & nm);

  virtual ~parent_component_proxy() {};

  UVM_COMPONENT_UTILS(parent_component_proxy)

  static parent_component_proxy * Create(const string & parent_full_name,
                                         int            parent_framework_id,
                                         int            parent_junction_node_id);

  int  Id() { return m_proxy_id; }
  void SetId(int id) { m_proxy_id = id; }

  int  ParentFrameworkId() { return m_parent_framework_id; }
  void SetParentFrameworkId(int id) { m_parent_framework_id = id; }

  int  AddNode(const string & child_type_name, 
               const string & child_instance_name);

  static parent_component_proxy * FindProxyById(int parent_junction_node_id);

/*! \class FullNameComparer
  \brief Compare full name of parent proxy.

  
*/
  class FullNameComparer
  {
  private:
      string x;
  public:
      FullNameComparer(const string & s){ x = s; }
      ~FullNameComparer() {};
      string X() { return x; }
      bool operator ()(parent_component_proxy *arg) { return arg->name() == X(); }
  };
  virtual bool is_traversable() { return false; }
  
};

map<int /* parent junction node id */, parent_component_proxy *> parent_component_proxy::parent_proxies;

extern bp_api_struct * bpProvidedAPI;

#define BP(f) (*bpProvidedAPI->f##_ptr)

int uvm_ml_utils::implement_create_child_junction_node(const string & component_type_name,
                                                       const string & instance_name,
                                                       const string & parent_full_name,
                                                       int            parent_framework_id,
                                                       int            parent_junction_node_id) {

    // The parent proxy with the given parent_full_name might already exist if the parent junction node
    // instantiates multiple SystemC child components. Hence. first thing, check if it exists:
    parent_component_proxy * proxy = parent_component_proxy::FindProxyById(parent_junction_node_id);
    if (proxy == NULL)
        proxy = parent_component_proxy::Create(parent_full_name, parent_framework_id, parent_junction_node_id);
    return proxy->AddNode(component_type_name, instance_name);
}


// /////////////////////////////////
//
// Class: parent_component_proxy
//
// /////////////////////////////////

parent_component_proxy::parent_component_proxy(const sc_module_name & nm): uvm_ml_special_component(nm),
                                                                           m_proxy_id(0), m_parent_framework_id(0) {
}

parent_component_proxy * parent_component_proxy::Create(const string & parent_full_name, // Static method
                                                        int            parent_framework_id,
                                                        int            parent_junction_node_id) {

    parent_component_proxy * ret = NULL;

    size_t first_dot = parent_full_name.find(".");

    if(first_dot == string::npos || (UVM_ML_DOTTED_NAME_SUPPORTED() == true)) {
        string parent_name;
         
        sc_object * obj = sc_core::sc_get_curr_simcontext()->hierarchy_curr();
        if (obj != NULL) {
	    // Can happen if that's a SC "sandwich"
	    parent_name = parent_full_name.substr(strlen(obj->name()) + 1); // remove also dot
        }
        else
	    parent_name = parent_full_name;

        UVM_ML_ENABLE_DOTTED_NAME()
        ret =  new parent_component_proxy(sc_module_name(parent_name.c_str()));
        UVM_ML_RESTORE_ENABLE_DOTTED_NAME()
    }
    else {
        // Need to build auxiliary dummy hierarchy in order to work around the fact 
        // that the instance name cannot be dotted
        ret = create_proxy_with_helpers(NULL, parent_full_name);
    }
    if (ret != NULL) {
        ret->SetParentFrameworkId(parent_framework_id);
        ret->SetId(parent_junction_node_id);
        parent_proxies[parent_junction_node_id] = ret;
    }
    return ret;
}

int parent_component_proxy::AddNode(const string & child_type_name, 
                                    const string & child_instance_name) {
    int node_id = -1;

    simcontext()->hierarchy_push( this );
    uvm_component * comp = uvm_factory::create_component(child_type_name, name(), child_instance_name);
    simcontext()->hierarchy_pop();
    if (comp) {
      node_id = uvm_ml_utils::add_quasi_static_tree_node(comp);
    }
    return node_id;
}

parent_component_proxy * parent_component_proxy::FindProxyById(int parent_junction_node_id)
{
    return parent_proxies[parent_junction_node_id];
}

UVM_COMPONENT_REGISTER(parent_component_proxy)

/////////////////////////////

uvm_ml_proxy_helper::uvm_ml_proxy_helper(const sc_module_name & name): uvm_ml_special_component(name),m_proxy(0) {
}

uvm_ml_proxy_helper::uvm_ml_proxy_helper(const sc_module_name & nm, const string & remaining_path): uvm_ml_special_component(nm) {
  size_t dot_pos = remaining_path.find(".");

  if (dot_pos == string::npos) {
    m_proxy = new parent_component_proxy(sc_module_name(remaining_path.c_str()));
    // Save it because the helper may be later deleted
  } else {
    string next_instance_name = remaining_path.substr(0, dot_pos);
    string next_remaining_path = remaining_path.substr(dot_pos + 1);
    uvm_ml_proxy_helper * child_helper = 
      new uvm_ml_proxy_helper(sc_module_name(next_instance_name.c_str()), next_remaining_path);
    m_proxy = child_helper->get_proxy();
  }
}

UVM_COMPONENT_REGISTER( uvm_ml_proxy_helper)

// Find an existing hierarchical tree for the new parent proxy
// To substitute missing hierarchical instances (belonging to foreign languages) - create dummy helper components
// The latter is done in a recursive manner

parent_component_proxy * parent_component_proxy::create_proxy_with_helpers(sc_module *    parent_helper,
                                                                           const string & path)
{
  parent_component_proxy * proxy = NULL;

  size_t remaining_path_pos = path.find(".");

  if (remaining_path_pos == string::npos) {
      if (parent_helper)
          sc_core::sc_get_curr_simcontext()->hierarchy_push(parent_helper);
      proxy = new parent_component_proxy(sc_module_name(path.c_str()));
      if (parent_helper)
          sc_core::sc_get_curr_simcontext()->hierarchy_pop();
  } else {
      // The helpers and the proxy must be instantiated recursively in order to build the correct full path
      string instance_name = path.substr(0,remaining_path_pos);
      string full_name;
      if (parent_helper == NULL)
	  full_name = instance_name;
      else {
	  full_name = string(parent_helper->name()) + "." + instance_name;
      }
      string remaining_path = path.substr(remaining_path_pos+1);

      sc_object * old_object = sc_find_object(full_name.c_str());

      if (old_object == NULL) {
          if (parent_helper)
              sc_core::sc_get_curr_simcontext()->hierarchy_push(parent_helper);
          
          uvm_ml_proxy_helper * helper = new uvm_ml_proxy_helper(sc_module_name(instance_name.c_str()), remaining_path);
          if (parent_helper)
              sc_core::sc_get_curr_simcontext()->hierarchy_pop();
          proxy = helper->get_proxy();
      }
      else {
        sc_module * old_module = dynamic_cast<sc_module *>(old_object);
        assert (old_module != NULL);

        proxy = create_proxy_with_helpers(old_module, remaining_path);
      }
  }
  return proxy;
}

//////////////////////

static vector<child_component_proxy *>child_proxies;

child_component_proxy * uvm_ml_create_component(const string &        target_framework_indicator, 
                                                const string &        component_type_name, 
                                                const string &        instance_name,
                                                const uvm_component * parent)
{
    string parent_name;
  
    parent_name = parent->name();

    // Child component proxy should be created statically when used with the portable adapter (Questa SC)

#ifndef MTI_SYSTEMC
    //    child_component_proxy *p = new child_component_proxy(instance_name.c_str(), target_framework_indicator, component_type_name, instance_name, parent_name);
    child_component_proxy *p = DCAST<child_component_proxy *> (uvm_factory::create_component("child_component_proxy", parent->name(), instance_name));
    if (p && (p->request_create_child_junction_node(target_framework_indicator, component_type_name, instance_name, parent_name) == true))
      child_proxies.push_back(p);
#else
    string proxy_name = parent_name + uvm_ml_utils::get_systemc_separator() + instance_name;

    sc_object * obj = sc_find_object(proxy_name.c_str());
    child_component_proxy *p = DCAST<child_component_proxy *>(obj);
    
    if (p == NULL) {
      char msg[1024];
      sprintf(msg, "\n Child component proxy full name: %s\n", proxy_name.c_str());
      UVM_ML_SC_REPORT_ERROR("UVM-SC portable adapter: Child component proxy was not created statically", msg);
      return NULL;
    }
    if (p->request_create_child_junction_node(target_framework_indicator, component_type_name, instance_name, parent_name) == true)
      child_proxies.push_back(p);
#endif
    return p;
}

// /////////////////////////////////
//
// Class: child_component_proxy
//
// /////////////////////////////////

static map<uvm_component*,unsigned>proxy_parents;

int unsigned get_hierarchical_node_id(uvm_component *comp) {
  static int unsigned next_id = 0;
  map<uvm_component*, unsigned>::iterator it;
  
  it = proxy_parents.find(comp);
  if(it == proxy_parents.end()) {
    proxy_parents.insert(pair<uvm_component*,unsigned>(comp,next_id++));
    return next_id-1;
  } else
    return it->second;

} // get_hierarchical_node_id

    child_component_proxy::child_component_proxy(sc_module_name nm): uvm_ml_special_component(nm),m_child_junction_node_id(0),m_parent_id(0) 
{
}

child_component_proxy::child_component_proxy(sc_module_name nm, 
                                             const string & target_framework_indicator, 
                                             const string & component_type_name, 
                                             const string & instance_name,
                                             const string & parent_name): uvm_ml_special_component(nm) 
{
    if (request_create_child_junction_node(target_framework_indicator, component_type_name, instance_name, parent_name) == true) {
        child_proxies.push_back(this);
    }
}

bool child_component_proxy::request_create_child_junction_node(const string & target_framework_indicator, 
                                                               const string & component_type_name, 
                                                               const string & instance_name,
                                                               const string & parent_name)
{
    m_parent_name = parent_name; // It must be assigned ouside of the constructor for the statically created components (portable adapter)
    m_component_type_name = component_type_name;
    m_instance_name = instance_name;
    m_target_frmw_ind = target_framework_indicator;

    uvm_component *p = get_parent();
    m_parent_id = get_hierarchical_node_id(p);
    m_child_junction_node_id = BP(create_child_junction_node)(uvm_ml_utils::FrameworkId(),
				                              m_target_frmw_ind.c_str(), 
				                              m_component_type_name.c_str(),
				                              m_instance_name.c_str(),
				                              m_parent_name.c_str(),
				                              m_parent_id);
    if(m_child_junction_node_id == -1) {
      char msg[1024];
      sprintf(msg,"\ntype name is %s; instance name is %s; framework is %s", m_component_type_name.c_str(), m_instance_name.c_str(), m_target_frmw_ind.c_str());
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: Failed to create child proxy", msg);
      return false;
    }
    return true;
}

void child_component_proxy::transmit_phase(uvm_phase *phase, unsigned int action)
{
    if (phase->get_phase_type() != UVM_RUNTIME_PHASE) {
        char * phase_name  = const_cast<char*>(phase->get_name().c_str());
        char * phase_group = const_cast<char*>(phase->get_schedule()->basename());

        int res = BP(transmit_phase)(uvm_ml_utils::FrameworkId(), m_target_frmw_ind.c_str(), m_child_junction_node_id, phase_group, phase_name, (uvm_ml_phase_action) action);
        if(res == 0) {
            char msg[1024];
            sprintf(msg, "UVM-SC adapter: phase %s failed for foreign child component %s", phase_name, name());
            uvm_ml_utils::report_sc_error(msg, "");
        }
    }
}
					   
void child_component_proxy::phase_started(uvm_phase *phase) 
{ 
    transmit_phase(phase, UVM_ML_PHASE_STARTED);
}

void child_component_proxy::phase_ready_to_end(uvm_phase *phase) 
{
    transmit_phase(phase, UVM_ML_PHASE_READY_TO_END);
}

void child_component_proxy::phase_ended(uvm_phase *phase) 
{
    transmit_phase(phase, UVM_ML_PHASE_ENDED);
}

void child_component_proxy::build_phase(uvm_phase *phase) 
{
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}
void child_component_proxy::connect_phase(uvm_phase *phase) 
{ 
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}

void child_component_proxy::end_of_elaboration_phase(uvm_phase *phase) {
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}
void child_component_proxy::start_of_simulation_phase(uvm_phase *phase) { 
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}

void child_component_proxy::extract_phase(uvm_phase *phase) { 
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}

void child_component_proxy::check_phase(uvm_phase *phase) { 
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}

void child_component_proxy::report_phase(uvm_phase *phase) { 
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}

void child_component_proxy::final_phase(uvm_phase *phase) { 
    transmit_phase(phase, UVM_ML_PHASE_EXECUTING);
}

UVM_COMPONENT_REGISTER(child_component_proxy)

///////////////////////

}
