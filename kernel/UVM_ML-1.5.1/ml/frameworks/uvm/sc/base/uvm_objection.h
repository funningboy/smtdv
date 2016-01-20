//----------------------------------------------------------------------
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

#ifndef __UVM_OBJECTION_H__
#define __UVM_OBJECTION_H__

#include "base/uvm_object.h"
#include "base/uvm_component.h"
#include "base/uvm_packer.h"
#include "base/uvm_callback.h"
#include "base/uvm_factory.h"
#include "base/uvm_pool.h"
#include <map>


namespace uvm {

enum OBJECTION_ACTION
{
    RAISED,
    DROPPED,
    ALL_DROPPED
};


//------------------------------------------------------------------------------
// Class: uvm_objection
//  Synchronization object.
//------------------------------------------------------------------------------
class uvm_objection;
typedef uvm_objection *puvm_objection;
typedef uvm_callback_agent<puvm_objection>   uvm_objection_callback_agent;
typedef uvm_callback_agent<puvm_objection> *puvm_objection_callback_agent;

class uvm_objection : public uvm_object
{

public:
    UVM_OBJECT_UTILS(uvm_objection)

    uvm_objection();
    virtual ~uvm_objection();

    void raise_objection (uvm_component* comp = NULL, int count = 1);
    void drop_objection (uvm_component* comp = NULL, int count = 1);
    void set_drain_time (uvm_component* comp, sc_core::sc_time drain);

    virtual void raised (uvm_component* comp, uvm_component* source_comp, int count);
    virtual void dropped (uvm_component* comp, uvm_component* source_comp, int count);
    virtual void all_dropped (uvm_component* comp, uvm_component* source_comp, int count);
    int get_objection_count (uvm_component* comp);
    int get_objection_total (uvm_component* comp = NULL);
    sc_core::sc_time get_drain_time (uvm_component* comp);

    void do_print(std::ostream& os) const {};
    void do_pack(uvm_packer& p) const {};
    void do_unpack(uvm_packer& p) {};
    void do_copy(const uvm_object* rhs) {};
    bool do_compare(const uvm_object* rhs) const {return true;};

    puvm_objection_callback_agent get_callback_agent(OBJECTION_ACTION objection_action);


protected:
    std::map<uvm_component*, int>              m_source_count;
    std::map<uvm_component*, int>              m_total_count;
    std::map<uvm_component*, sc_core::sc_time> m_drain_time;
    std::map<uvm_component*, bool>             m_draining;

    bool m_hier_mode;

    static uvm_component* top;

private:
    uvm_component* m_get_parent(uvm_component* comp);
    void m_propagate (uvm_component* comp, uvm_component* source_comp, int count, bool raise);
    void m_set_hier_mode (uvm_component* comp);
    void m_raise (uvm_component* comp, uvm_component* source_comp, int count = 1);
    void m_drop (uvm_component* comp, uvm_component* source_comp, int count = 1);
    void m_process_drain_time (uvm_component* comp, uvm_component* source_comp, int count);
    void m_wait_drain_time (uvm_component* comp, uvm_component* source_comp, int count);
    void m_wait_raise (uvm_component* comp, uvm_component* source_comp, int count);

    sc_core::sc_event* m_raise_event_p;
    std::map<OBJECTION_ACTION, puvm_objection_callback_agent> _callback_map;

};
UVM_OBJECT_REGISTER(uvm_objection)



//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Class: uvm_test_done_objection
//  Test done synchronization object (singleton).  Calls stop_request when all 
//  components have dropped their objections.
//------------------------------------------------------------------------------
class uvm_test_done_objection : public uvm_objection
{
public:
    UVM_OBJECT_UTILS(uvm_test_done_objection)

    uvm_test_done_objection();
    virtual ~uvm_test_done_objection();

    virtual void qualify(bool is_raise, uvm_component* comp = NULL);
    virtual void all_dropped (uvm_component* comp, uvm_component* source_comp, int count);
    virtual void raise_objection (uvm_component* comp = NULL, int count = 1);
    virtual void drop_objection (uvm_component* comp = NULL, int count = 1);

    static  uvm_test_done_objection* get();

protected:

    static uvm_test_done_objection* m_inst;

};
UVM_OBJECT_REGISTER(uvm_test_done_objection)


} // namespace uvm

#endif
