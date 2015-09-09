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

#define SC_INCLUDE_DYNAMIC_PROCESSES
#include "base/uvm_objection.h"
#include "base/uvm_globals.h"
#include <string>

using std::string;


namespace uvm {

uvm_test_done_objection* uvm_test_done_objection::m_inst = NULL;
uvm_component* uvm_objection::top = NULL;

//------------------------------------------------------------------------------
// Constructor: uvm_objection
//------------------------------------------------------------------------------
uvm_objection::uvm_objection() :
    uvm_object(),
    m_hier_mode(true)
{
    puvm_objection_callback_agent p_callback_agent;

    top = uvm_get_top();
    m_raise_event_p = new sc_event();

    p_callback_agent = new uvm_objection_callback_agent();
    _callback_map[RAISED] = p_callback_agent;

    p_callback_agent = new uvm_objection_callback_agent();
    _callback_map[DROPPED] = p_callback_agent;

    p_callback_agent = new uvm_objection_callback_agent();
    _callback_map[ALL_DROPPED] = p_callback_agent;


}

//------------------------------------------------------------------------------
// Destructor: uvm_objection
//------------------------------------------------------------------------------
uvm_objection::~uvm_objection()
{
    _callback_map.clear();    
}

//------------------------------------------------------------------------------
// Function: m_get_parent
//   Internal method for getting the parent of the given ~object~.
//------------------------------------------------------------------------------
uvm_component* uvm_objection::m_get_parent(uvm_component* comp)
{
    if (comp != NULL)
      comp = comp->get_parent();
    else
      comp = top;

    return comp;
}


//------------------------------------------------------------------------------
// Function: m_propagate
//   Propagate the objection to the objects parent. If the object is a
//   component, the parent is just the hierarchical parent.
//
// Parameter:
//   comp : the uvm_component on which the objection is being raised or lowered
//   source_comp : the root object on which the } user raised/lowered the 
//                 objection (as opposed to an anscestor of the } user object)
//   count : the number of objections associated with the action.
//   raise : indicator of whether the objection is being raised or lowered. A
//           1 indicates the objection is being raised.
//------------------------------------------------------------------------------
void uvm_objection::m_propagate (uvm_component* comp, uvm_component* source_comp, int count, bool raise)
{
    if (comp != NULL && comp != top)
    {
        comp = m_get_parent(comp);
        if(raise)
            m_raise(comp, source_comp, count);
        else
            m_drop(comp, source_comp, count);
    }
}


//------------------------------------------------------------------------------
// Function: m_set_hier_mode
//   Hierarchical mode only needs to be set for intermediate components, not
//   for uvm_root or a leaf component.
//------------------------------------------------------------------------------
void uvm_objection::m_set_hier_mode (uvm_component* comp)
{
    if ((m_hier_mode == true) || (comp == top))
        return;                             // Don't set if already set or the object is uvm_top.

    if (comp != NULL)
    {
        if(comp->get_num_children() == 0)   // Don't set if object is a leaf.
            return;
    }
    else
    {
        return;                             // Don't set if object is a non-component.
    }

    // restore counts on non-source nodes
    m_total_count.clear();
    std::map<uvm_component*, int>::const_iterator source_count_it;

    for (source_count_it = m_source_count.begin(); source_count_it != m_source_count.end(); ++source_count_it)
    {
        uvm_component* theobj = source_count_it->first;
        int         count  = m_source_count[comp];
        do 
        {
            if (m_total_count.count(theobj) != 0)
                m_total_count[theobj] += count;
            else
                m_total_count[theobj] = count;
            theobj = m_get_parent(theobj);

        } while (theobj != NULL);
    }

        m_hier_mode = true;
}

//------------------------------------------------------------------------------
// Function: raise_objection
//   Raises the number of objections for the source ~object~ by ~count~, which
//   defaults to 1.  The ~object~ is usually the ~this~ handle of the caller.
//   If ~object~ is not specified or NULL, the top-level component,
//   is chosen.
//   Rasing an objection causes the following.
//   - The source and total objection counts for ~object~ are increased by
//     ~count~.
//   - The objection's <raised> virtual method is called, which calls the
//     <uvm_component::raised> method for all of the components up the 
//     hierarchy.
//------------------------------------------------------------------------------
void uvm_objection::raise_objection (uvm_component* comp, int count)
{
    m_raise (comp, comp, count);
    if (count > 0)
        m_raise_event_p->notify();

    // Execute raised call back
    puvm_objection_callback_agent p_callback_agent;
    p_callback_agent = _callback_map[RAISED];
    p_callback_agent->notify(this);
}


//------------------------------------------------------------------------------
// Function: m_raise
//  Internal raise function
//------------------------------------------------------------------------------
void uvm_objection::m_raise (uvm_component* comp, uvm_component* source_comp, int count)
{
    if (comp == NULL)
        comp = top;

    if (m_total_count.count(comp) != 0)
        m_total_count[comp] += count;
    else 
        m_total_count[comp] = count;

    if (source_comp == comp) 
    {
        if (m_source_count.count(comp) != 0)
            m_source_count[comp] += count;
        else
            m_source_count[comp] = count;

        source_comp = comp;
    }

    raised(comp, source_comp, count);

    // If this object is still draining from a previous drop, then
    // raise the count and return. Any propagation will be handled
    // by the drain process.
    if (m_draining.count(comp) != 0)
        return;

    if (!m_hier_mode && comp != top)
        m_raise(top,source_comp,count);
    else if (comp != top)
        m_propagate(comp, source_comp, count, 1);

}
  

//------------------------------------------------------------------------------
// Function: drop_objection
//   Drops the number of objections for the source ~object~ by ~count~, which
//   defaults to 1.  The ~object~ is usually the ~this~ handle of the caller.
//   If ~object~ is not specified or NULL, the implicit top-level component,
//   ~uvm_top~, is chosen.
//
//   Dropping an objection causes the following.
//   - The source and total objection counts for ~object~ are decreased by
//     ~count~. It is an error to drop the objection count for ~object~ below
//     zero.
//   - The objection's <dropped> virtual method is called, which calls the
//     <uvm_component::dropped> method for all of the components up the 
//     hierarchy.
//   - If the total objection count has not reached zero for ~object~, then
//     the drop is propagated up the object hierarchy as with
//     <raise_objection>. Then, each object in the hierarchy will have updated
//     their ~source~ counts--objections that they originated--and ~total~
//     counts--the total number of objections by them and all their
//     desc}ants.
//
//   If the total objection count reaches zero, propagation up the hierarchy
//   is deferred until a configurable drain-time has passed and the 
//   <uvm_component::all_dropped> callback for the current hierarchy level
//   has returned. The following process occurs for each instance up
//   the hierarchy from the source caller:
//
//   A process is forked in a non-blocking fashion, allowing the ~drop~
//   call to return. The forked process then does the following:
//
//   - If a drain time was set for the given ~object~, the process waits for
//     that amount of time.
//
//   - The objection's <all_dropped> virtual method is called, which calls the
//     <uvm_component::all_dropped> method (if ~object~ is a component).
//
//   - The process then waits for the ~all_dropped~ callback to complete.
//
//   - After the drain time has elapsed and all_dropped callback has
//     completed, propagation of the dropped objection to the parent proceeds
//     as described in <raise_objection>, except as described below.
//
//   If a new objection for this ~object~ or any of its desc}ents is raised
//   during the drain time or during execution of the all_dropped callback at
//   any point, the hierarchical chain described above is terminated and the
//   dropped callback does not go up the hierarchy. The raised objection will
//   propagate up the hierarchy, but the number of raised propagated up is
//   reduced by the number of drops that were p}ing waiting for the 
//   all_dropped/drain time completion. Thus, if exactly one objection
//   caused the count to go to zero, and during the drain exactly one new
//   objection comes in, no raises or drops are propagted up the hierarchy,
//
//   As an optimization, if the ~object~ has no set drain-time and no
//   registered callbacks, the forked process can be skipped and propagation
//   proceeds immediately to the parent as described. 
//------------------------------------------------------------------------------
void uvm_objection::drop_objection (uvm_component* comp, int count)
{
    m_drop (comp, comp, count);

    // Execute dropped call back
    puvm_objection_callback_agent p_callback_agent;
    p_callback_agent = _callback_map[DROPPED];
    p_callback_agent->notify(this);
}


//------------------------------------------------------------------------------
// Function: m_drop
//  Internal drop function.
//------------------------------------------------------------------------------
void uvm_objection::m_drop (uvm_component* comp, uvm_component* source_comp, int count)
{
    if (comp == NULL)
        comp = top;

    if (!m_total_count.count(comp) || (count > m_total_count[comp])) 
    {
        cerr << "Object " <<  comp->name() << " attempted to drop objection count below zero." << endl;
        exit(1);;
    }

    if ((comp == source_comp) && 
        (!m_source_count.count(comp) || (count > m_source_count[comp]))) 
    {
        cerr << "Object " <<  comp->name() << " attempted to drop objection count below zero." << endl;
        exit(1);;
    }

    m_total_count[comp] -= count;

    if (source_comp == comp) 
    {
        m_source_count[comp] -= count;
        source_comp = comp;
    }


    dropped(comp, source_comp, count);

    // if count != 0, no reason to fork
    if (m_total_count[comp] != 0) 
    {
        if (!m_hier_mode && comp != top)
            m_drop(top,source_comp,count);
        else if (comp != top)
            m_propagate(comp, source_comp, count, 0);

    }
    else 
    {
        m_draining[comp] = 1;
        sc_spawn(sc_bind(&uvm_objection::m_process_drain_time, this, comp, source_comp, count));
    }

}   // m_drop

void uvm_objection::m_process_drain_time (uvm_component* comp, uvm_component* source_comp, int count)
{
    int  diff_count;
    bool reraise;
    sc_process_handle wait_drain_time_h;

    wait_drain_time_h = sc_spawn(sc_bind(&uvm_objection::m_wait_drain_time, this, comp, source_comp, count));
    wait(wait_drain_time_h.terminated_event() | *m_raise_event_p);

    if (m_total_count[comp] == 0)
        all_dropped(comp,source_comp,count);


    m_draining.erase(comp);

    diff_count = m_total_count[comp] - count;

    // no propagation if the re-raise cancels the drop
    if (diff_count != 0) 
    {
        reraise = diff_count > 0 ? 1 : 0;

        if (diff_count < 0)
            diff_count = -diff_count;

        if (!m_hier_mode && comp != top) 
        {
            if (reraise)
                m_raise(top,source_comp,diff_count);
            else
                m_drop(top,source_comp,diff_count);
        }
        else
        {
            if (comp != top) 
            {
                m_propagate(comp, source_comp, diff_count, reraise);
            }
        }
    }
}


//------------------------------------------------------------------------------
// Function: m_wait_drain_time
//  Internal function to wait for drain time.
//------------------------------------------------------------------------------
void uvm_objection::m_wait_drain_time (uvm_component* comp, uvm_component* source_comp, int count)
{
    if (m_drain_time.count(comp))
        wait(m_drain_time[comp]);
}


//------------------------------------------------------------------------------
// Function: set_drain_time
//   Sets the drain time on the given ~object~ to ~drain~.
//
//   The drain time is the amount of time to wait once all objections have
//   been dropped before calling the all_dropped callback and propagating
//   the objection to the parent. 
//
//   If a new objection for this ~object~ or any of its desc}ents is raised
//   during the drain time or during execution of the all_dropped callbacks,
//   the drain_time/all_dropped execution is terminated. 
//------------------------------------------------------------------------------
void uvm_objection::set_drain_time (uvm_component* comp, sc_core::sc_time drain)
{
    m_drain_time[comp] = drain;
    m_set_hier_mode(comp);
}
  

//------------------------------------------------------------------------------
// Function: raised
//  Objection callback that is called when a <raise_objection> has reached ~comp~.
//  The default implementation calls <uvm_component::raised>.
//------------------------------------------------------------------------------
void uvm_objection::raised (uvm_component* comp, uvm_component* source_comp, int count)
{
    if (comp != NULL)
        comp->raised(this, source_comp, count);
}


//------------------------------------------------------------------------------
// Function: dropped
//   Objection callback that is called when a <drop_objection> has reached ~comp~.
//   The default implementation calls <uvm_component::dropped>.
//------------------------------------------------------------------------------
void uvm_objection::dropped (uvm_component* comp, uvm_component* source_comp, int count)
{
    if (comp != NULL)
        comp->dropped(this, source_comp, count);
}


//------------------------------------------------------------------------------
// Function: all_dropped
//   Objection callback that is called when a <drop_objection> has reached ~comp~,
//   and the total count for ~comp~ goes to zero. This callback is executed
//   after the drain time associated with ~comp~. The default implementation 
//   calls <uvm_component::all_dropped>.
//------------------------------------------------------------------------------
void uvm_objection::all_dropped (uvm_component* comp, uvm_component* source_comp, int count)
{
    if (comp != NULL)
        comp->all_dropped(this, source_comp, count);

    // Execute all dropped call back
    puvm_objection_callback_agent p_callback_agent;
    p_callback_agent = _callback_map[ALL_DROPPED];
    p_callback_agent->notify(this);
}


// Group: Objection Status

//------------------------------------------------------------------------------
// Function: get_objection_count
//   Returns the current number of objections raised by the given ~object~.
//------------------------------------------------------------------------------
int uvm_objection::get_objection_count (uvm_component* comp)
{
    if (!m_source_count.count(comp))
        return 0;
    return m_source_count[comp];
}
  

//------------------------------------------------------------------------------
// Function: get_objection_total
//   Returns the current number of objections raised by the given ~object~ 
//   and all descants.
//------------------------------------------------------------------------------
int uvm_objection::get_objection_total (uvm_component* comp)
{
    int                     objection_total = 0;
    std::vector<sc_object*> child_vec;

    string ch;

    if (comp == NULL)
        comp = top;

    if (!m_total_count.count(comp))
        return 0;

    objection_total = m_total_count[comp];

    if( (!m_hier_mode)  && (comp != NULL))
    {
        uvm_component* child_comp = NULL;
        objection_total = m_source_count[comp];
        child_vec = comp->get_child_objects();

        for (unsigned int i = 0; i < child_vec.size(); i++)
        {
            child_comp = DCAST<uvm_component*>(child_vec[i]);
            if (comp != NULL)
            {
                objection_total += get_objection_total(child_comp);
            }
        }
    }

    return objection_total;
}
  

//------------------------------------------------------------------------------
// Function: get_drain_time
//   Returns the current drain time set for the given ~object~ (default: 0 ns).
//------------------------------------------------------------------------------
sc_core::sc_time uvm_objection::get_drain_time (uvm_component* comp)
{
    if (!m_drain_time.count(comp))
        return SC_ZERO_TIME;

    return m_drain_time[comp];
}


//------------------------------------------------------------------------------
// Constructor: uvm_test_done_objection
//------------------------------------------------------------------------------
uvm_test_done_objection::uvm_test_done_objection() :
    uvm_objection()
{
}

//------------------------------------------------------------------------------
// Destructor: uvm_test_done_objection
//------------------------------------------------------------------------------
uvm_test_done_objection::~uvm_test_done_objection() 
{
}

//------------------------------------------------------------------------------
// Function: qualify
//   Checks that the given ~object~ is derived from either <uvm_component> or
//   <uvm_sequence_base>.
//------------------------------------------------------------------------------
void uvm_test_done_objection::qualify(bool is_raise, uvm_component* comp)
{
    string nm = is_raise ? "raise_objection" : "drop_objection";

    if (comp == NULL)
    {
        cerr << "A non-hierarchical object '" 
             << comp->name() 
             << "' (" 
             <<  comp->get_type_name() 
             << ") was used in a call to uvm_test_done." 
             <<  nm 
             << "(). For this objection, a sequence or component is required."  
             << endl;
        exit(1);
    }
}


//------------------------------------------------------------------------------
// Function: all_dropped
//   This callback is called when the given ~object's~ objection count reaches
//   zero; if the ~object~ is the implicit top-level, <uvm_top> then it means
//   there are no more objections raised for the ~uvm_test_done~ objection.
//   Thus, after calling <uvm_objection::all_dropped>, this method will call
//   <uvm_stop_request> to stop the current task-based phase (e.g. run).
//------------------------------------------------------------------------------
void uvm_test_done_objection::all_dropped (uvm_component* comp, uvm_component* source_comp, int count)
{
    uvm_objection::all_dropped(comp, source_comp, count);

    if (comp == top) 
    {
        if (!uvm_manager::get_manager()->is_in_stop_request()) 
        {
            // Note:  All test objections have been dropped, calling uvm_stop_request() @ << sc_time_stamp() << endl;
            uvm::uvm_stop_request();
        }
        //else 
        //{
        //    Note:  All test objections have been dropped - already in stop request
        //}
    }
}


//------------------------------------------------------------------------------
// Function: raise_objection
//   Calls <uvm_objection::raise_objection> after calling <qualify>. 
//   If the ~object~ is not provided or is ~NULL~, then the implicit top-level
//   component, ~uvm_top~, is chosen.
//------------------------------------------------------------------------------
void uvm_test_done_objection::raise_objection (uvm_component* comp, int count)
{
    if(comp == NULL)
      comp = top;
    else
      qualify(true, comp);

    uvm_objection::raise_objection(comp, count);
}


//------------------------------------------------------------------------------
// Function: drop
//   Calls <uvm_objection::drop_objection> after calling <qualify>. 
//   If the ~object~ is not provided or is ~NULL~, then the implicit top-level
//   component, ~uvm_top~, is chosen.
//------------------------------------------------------------------------------
void uvm_test_done_objection::drop_objection (uvm_component* comp, int count)
{
    if(comp == NULL)
        comp=top;
    else
        qualify(false, comp);

    uvm_objection::drop_objection(comp,count);
}


//------------------------------------------------------------------------------
// Function : get
//   uvm_test_done_objection singleton.
//------------------------------------------------------------------------------
uvm_test_done_objection* uvm_test_done_objection::get()
{
    uvm_object* obj;

    if (m_inst == NULL)
    {
        obj = uvm::uvm_factory::create_object("uvm_test_done_objection", "top->name()", "uvm_test_done");
        m_inst = DCAST<uvm_test_done_objection*>(obj);
    }

    return m_inst;
}


//------------------------------------------------------------------------------
// Function : get_callback_agent()
//   - get a pointer to a particular callback agent
//------------------------------------------------------------------------------
puvm_objection_callback_agent uvm_objection::get_callback_agent(OBJECTION_ACTION objection_action)
{
  return _callback_map[objection_action];
}

} // namespace uvm
