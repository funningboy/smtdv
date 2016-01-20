//----------------------------------------------------------------------
//   Copyright 2009 Cadence Design Systems, Inc.
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

/*! \file uvm_manager.h
  \brief Central manager of UVM-SC global functions.
*/

#ifndef UVM_MANAGER_H
#define UVM_MANAGER_H


#include "sysc/kernel/sc_event.h"
#include "sysc/kernel/sc_join.h"

//////////////

namespace uvm {

class uvm_component;

//------------------------------------------------------------------------------
//
// CLASS: uvm_manager
//
// Internal implementation class.
// Stores global settings, and implements most of the global functions.
// A singleton instance of this class is created for a given simulation run.
//
//------------------------------------------------------------------------------

/*! \class uvm_manager
  \brief Stores global settings, and implements most of the global functions.

  A singleton instance of this class is created for a given simulation run
*/
class uvm_manager {
public:

  friend class uvm_component;

  static uvm_manager* get_manager();

  uvm_component* find_component(const char* name);
  uvm_component* find_module(const char* name);
  std::vector<uvm_component*> find_all(const char* name = ".*");
  std::vector<uvm_component*> find_all_module(const char* name);

  unsigned int get_num_tops();
  void set_top(const std::vector<sc_core::sc_module *>& tops);
  void set_top(sc_core::sc_module* comp);
  std::vector<sc_core::sc_module*> get_tops();
  std::vector<uvm_component*>      get_uvm_component_tops();

protected:

  uvm_manager();
  ~uvm_manager();

  void do_kill_all();
  void do_kill(sc_core::sc_module* mod);
  
protected:

  static uvm_manager* m_mgr;
         
  std::vector<sc_core::sc_module*> m_tops;
};

inline
uvm_manager* get_uvm_manager() {
  return uvm_manager::get_manager();
}

} // namespace uvm

#endif
