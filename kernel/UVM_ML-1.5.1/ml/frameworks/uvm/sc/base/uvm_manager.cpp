//----------------------------------------------------------------------
//   Copyright 2009 Cadence Design Systems, Inc.
//   Copyright 2012 Advance Micro Devices, Inc
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

/*! \file uvm_manager.cpp
  \brief Central manager of UVM-SC global functions.
*/

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "systemc.h"
#include <packages/boost/include/regex.hpp>
#include "base/uvm_manager.h"
#include "base/uvm_ids.h"
#include "base/uvm_component.h"
#include "uvm_imp_spec_macros.h"

using namespace sc_core;

namespace uvm {

//------------------------------------------------------------------------------
//
// uvm_manager
//
// Internal implementation class.
//
//------------------------------------------------------------------------------

uvm_manager* uvm_manager::m_mgr = 0;

uvm_manager* uvm_manager::get_manager() {
  if (m_mgr == 0) {
    m_mgr = new uvm_manager();
  }
  return m_mgr;
}

uvm_manager::uvm_manager() {

}
 
uvm_manager::~uvm_manager() {
}


//------------------------------------------------------------------------------
// Function: find_component
//   Regular expression search for UVM components base on instance name.  Returns
//   the first match found.
//
// Parameters;
//  @param name - name to search for
//
// Returns:
//  @param comp - pointer to uvm component found, NULL if no matching.
//------------------------------------------------------------------------------
uvm_component* uvm_manager::find_component(const char* name) {
    bool           bfound = false;
    uvm_component* comp   = NULL;
    sc_simcontext* simc_p = sc_get_curr_simcontext();
    sc_object*     obj    = simc_p->first_object();

    uvmsc_boost::smatch what;
    uvmsc_boost::regex  re(name);

    obj = simc_p->first_object();
    while ((obj != NULL) && (bfound == false))
    {
        comp = DCAST<uvm_component*>(obj);
        if ((comp != NULL) &&
                uvmsc_boost::regex_match((const std::string) obj->name(), what, re))
        {
            bfound = true;
        }
        obj = simc_p->next_object();
    }
    return comp;
}

//------------------------------------------------------------------------------
// Function: find_module
// 
// Regular expression search for UVM components base on type name.  Returns
// the first match.
//------------------------------------------------------------------------------
uvm_component* uvm_manager::find_module(const char* name) {
  bool           bfound = false;
  uvm_component* comp   = NULL;
  sc_simcontext* simc_p = sc_get_curr_simcontext();
  sc_object*     obj    = simc_p->first_object();

  uvmsc_boost::smatch what;
  uvmsc_boost::regex  re(name);
  
  while ((obj != NULL) && (bfound == false))
  {
    comp = DCAST<uvm_component*>(obj);
    if ((comp != NULL) &&
        uvmsc_boost::regex_match(comp->get_type_name(), what, re))
    {
        bfound = true;
    }
    obj = simc_p->next_object();
  }
  return comp;

}

//------------------------------------------------------------------------------
// Function: find_all
// 
// Regular expression search for OVM components base on instance name.  Returns
// a vector of all components that match the search criteria.  Default is to
// return all components.
//------------------------------------------------------------------------------
std::vector<uvm_component*> uvm_manager::find_all(const char* name) {
  std::vector<uvm_component*> comp_vector;
  uvm_component* comp   = NULL;
  sc_simcontext* simc_p = sc_get_curr_simcontext();
  sc_object*     obj    = simc_p->first_object();

  uvmsc_boost::smatch what;
  uvmsc_boost::regex  re(name);
  
  while (obj != NULL)
  {
    comp = DCAST<uvm_component*>(obj);
    if ((comp != NULL) &&
        uvmsc_boost::regex_match((const std::string) obj->name(), what, re))
    {
        comp_vector.push_back(comp);
    }
    obj = simc_p->next_object();
  }
  return comp_vector;

}

//------------------------------------------------------------------------------
// Function: find_all_module
// 
// Regular expression search for OVM components base on type name.  Returns
// a vector of all components that match the search criteria.
//------------------------------------------------------------------------------
std::vector<uvm_component*> uvm_manager::find_all_module(const char* name) {
  std::vector<uvm_component*> comp_vector;
#ifndef MTI_SYSTEMC
  uvm_component* comp   = NULL;
  sc_simcontext* simc_p = sc_get_curr_simcontext();
  sc_object*     obj    = simc_p->first_object();

  uvmsc_boost::smatch what;
  uvmsc_boost::regex  re(name);
  
  while (obj != NULL)
  {
    comp = DCAST<uvm_component*>(obj);
    if ((comp != NULL) &&
        uvmsc_boost::regex_match(comp->get_type_name(), what, re))
    {
        comp_vector.push_back(comp);
    }
    obj = simc_p->next_object();
  }
#endif
  return comp_vector;

}


void uvm_manager::do_kill_all() {

  // find all top-level modules and call kill on each top module hierarchy

  const std::vector<sc_object*>& tops = sc_get_top_level_objects();
  for (unsigned i = 0; i < tops.size(); i++) {
    sc_object* top = tops[i];
    sc_module* top_mod = DCAST<sc_module*>(top);
    if (top_mod) {
      do_kill(top_mod);
    }
  }
}

void uvm_manager::do_kill(sc_module* mod) {

  // call mod::kill() if mod is an uvm_component

  uvm_component* comp = DCAST<uvm_component*>(mod);
  if (comp) {
    comp->kill();
  }

  // recurse over children

  const std::vector<sc_object*>& children = mod->get_child_objects();
  for (unsigned i = 0; i < children.size(); i++) {
    sc_object* child = children[i];
    sc_module* mod_child = DCAST<sc_module*>(child);
    if (mod_child) {
      do_kill(mod_child);
    }
  }
}


void uvm_manager::set_top(const std::vector<sc_core::sc_module *>& tops)
{
    if(m_tops.empty())
    {
        m_tops = tops;
    }
    else
    {
        for (unsigned int i = 0; i < tops.size(); i++)
        {
            m_tops.push_back(tops[i]);
        }
    }   
}

void uvm_manager::set_top(sc_core::sc_module *comp)
{
  m_tops.push_back(comp);
}

std::vector<uvm_component*> uvm_manager::get_uvm_component_tops()
{
  std::vector<uvm_component*> tops;
  uvm_component * pcomp;

  for (unsigned int i = 0; i < m_tops.size(); i++)
  {
    pcomp = DCAST<uvm_component*>(m_tops[i]);
    if (pcomp != NULL)
        tops.push_back(pcomp);
  }

  return tops;
}

std::vector<sc_core::sc_module*> uvm_manager::get_tops()
{
  return m_tops;
}

unsigned int uvm_manager::get_num_tops()
{
  return m_tops.size();
}


//////////

} // namespace uvm

