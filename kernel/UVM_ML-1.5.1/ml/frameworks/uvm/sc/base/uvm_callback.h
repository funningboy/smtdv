//----------------------------------------------------------------------
//   Copyright 2014 Advanced Micro Devices Inc.
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

/*! \file uvm_callback.h
  \brief Header file for uvm_callback.


    Generic callback agent for both functions/methods
    Allows subject to specify/enforce argument type required by
    observer callback function/method.  The variable would be 
    passed to the observer from the subject.


    Limitations:
    1. Currently supports one argument only for callback functions/methods
    2. Does not support 'void' as the argument (requires template specialization)
    3. Does not examine the return type from the function (callback)

*/

#ifndef __UVM_CALLBACK_H__
#define __UVM_CALLBACK_H__

#include <list>
#include <vector>
#include <algorithm>

namespace uvm {


//-------------------------
// Delete Struct:
//-------------------------
// Delete function object.
struct delete_object {
    template<typename Pointer>
    void operator()(Pointer pointer) {
      delete pointer;
    }
};


//----------------
// Agent Class
//----------------

template<typename Arg>
class uvm_callback_agent {

    struct abstract_function;               // abstract class representing observer function/method
    template<typename Fn> class callback;   // callback class containing function object (concrete)

  public:
    typedef typename std::list<abstract_function*>::iterator iterator;   // iterator typedef (convenience)
    typedef iterator callback_id;

    //-----------------
    // Member methods
    // ----------------
    uvm_callback_agent() {}
    ~uvm_callback_agent() {
        std::for_each(_callback.begin(),
                      _callback.end(),
                      delete_object());
    }

    // Attach a function
    template<typename Fn> callback_id attach(Fn fn) {
        return _callback.insert(_callback.end(), new callback<Fn>(fn));
        //_iterators.push_back(_callback.insert(_callback.end(), new callback<Fn>(fn)) );
        //return _iterators.size()-1;
    }

    // Attach a class member
    template<class Pointer, typename Member> callback_id attach(Pointer p, Member m) {
        return attach(std::bind1st(std::mem_fun(m),p));
    }

    // Detach a function/method
    void detach(callback_id id) {
        delete(*id);
        _callback.erase(id);
        //if (_callback.empty())      return;     // empty callback list
        //if(id >= _iterators.size()) return;     // exceeds size of list
        //if(*_iterators[id] == NULL) return;     // callback already removed
        //delete(*_iterators[id]);
        //_callback.erase(_iterators[id]);
        //*_iterators[id] = NULL;
    }

    // Notify Observers of callback - iterate over all attached functions/methods
    void notify(Arg arg) const {
        typedef abstract_function Base;
        std::for_each(_callback.begin(),
                      _callback.end(),
                      std::bind2nd(std::mem_fun(&Base::operator()),arg));
    }

  private:
    std::list<abstract_function*> _callback;        // list of callback functions/methods attached
    //std::vector<iterator> _iterators;
};


//-------------------------
// Function helper classes
//-------------------------

// Abstract Function.
template<typename Arg>
struct uvm_callback_agent<Arg>::abstract_function {
    virtual ~abstract_function() {}
    virtual void operator()(Arg) = 0;
};

// callback class template.
template<typename Arg>
template<typename Fn>
class uvm_callback_agent<Arg>::callback : public abstract_function {

  public:
    explicit callback(Fn fn) : function(fn) {}

    virtual void operator()(Arg arg) {
      function(arg);
    }

  private:
    Fn function;
};

}
#endif
