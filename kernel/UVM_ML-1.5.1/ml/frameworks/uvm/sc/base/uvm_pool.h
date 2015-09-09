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


#ifndef __UVM_POOL_H__
#define __UVM_POOL_H__

#include <map>
#include <string>
#include <iostream>

#include "base/uvm_object.h"
#include "base/uvm_factory.h"

using namespace std;


namespace uvm {

extern bool uvm_regex_match(const char * re, const string & arg);

//------------------------------------------------------------------------------
//
// Class: uvm_pool
//
// Template class for pools.
//
//------------------------------------------------------------------------------
template<class T>
class  uvm_pool : public uvm_object 
{

public:

public:

    typedef class uvm_pool<T> this_type;

    virtual string get_type_name() const { return gen_type_name<this_type>(); }

    map<string, T*> _pool_map2;

    //------------------------------------------------------------------------------
    // Constructor: uvm_pool
    //------------------------------------------------------------------------------
    uvm_pool(string name) :
        uvm_object(name)
    {
    }

    //------------------------------------------------------------------------------
    // Destructor: uvm_pool
    //------------------------------------------------------------------------------
    virtual ~uvm_pool()
    {
        _pool_map.clear();
    }

    //------------------------------------------------------------------------------
    // Function: get
    //   Returns a pointer to the named item if it exists in the pool otherwise NULL.
    //
    // Parameter:
    //  name - name of the item (std::string)
    //------------------------------------------------------------------------------
    virtual T*  get (const string& name)
    {
        T* item;

        typename map< string, T* >::iterator it;
        it = _pool_map.find(name);
        if (it == _pool_map.end())
        {
            item = new T(name);
            _pool_map[name] = item;
        }
        return _pool_map[name];
    }

    //------------------------------------------------------------------------------
    // Function: find
    //   Returns a vector of items that match regular expression passed in.
    //
    // Parameter:
    //  name - search string 
    //------------------------------------------------------------------------------
    vector<T*> find(const char* name)
    {
        typename map<string, T*>::const_iterator it;
        vector<T*> item_vector;

        for (it = _pool_map.begin(); it != _pool_map.end(); it++)
        {
            if (uvm_regex_match(it->first, name))
                item_vector.push_back(it->second);
        }
        return item_vector;
    }
  
    //------------------------------------------------------------------------------
    // Function: remove
    //   Removes object from the pool if it exists, returns false if item doesn't
    //   exist.
    //
    // Parameter:
    //  name - name of the item (std::string)
    //
    // Returns:
    //   status - true if item exist in pool
    //------------------------------------------------------------------------------
    virtual bool remove (const string &name)
    {
        typename map<string, T*>::iterator it;
        it = _pool_map.find(name);
        if (it == _pool_map.end())
        {
            return false;
        }
        else
        {
            _pool_map.erase(name);
            return true;
        }
    }

    //------------------------------------------------------------------------------
    // Function: exist
    //   Removes true if the named item exists in the pool.
    //   exist.
    //
    // Parameter:
    //   name - name of the item (std::string)
    //------------------------------------------------------------------------------
    bool exists (const string &name)
    {
        typename map<string, T*>::iterator it;
        it = _pool_map.find(name);
        if (it == _pool_map.end())
            return false;
        else
            return true;
    }

    //------------------------------------------------------------------------------
    // Function: size
    //   Returns the number of items in the pool
    //
    // Returns:
    //   size - number of items in pool (int)
    //------------------------------------------------------------------------------
    int size(void)
    {
        return _pool_map.size();
    }

    static this_type * get_pool(const string &name, uvm_object *owner=NULL)
    {
        this_type* item;
        typename map<string, this_type*>::iterator it;
        string n = name;
        if (owner != NULL) {
            if (n == "") {
                n = owner->get_full_name();
            } else {
                n = owner->get_full_name() + "." + name;
            }
        }
        it = _pools.find(n);
        if (it == _pools.end())
        {
            item = dynamic_cast<this_type*>(uvm_create_object(gen_type_name<this_type>(), "", n, false));
             // VY It doesn't compile without regex: assert(item);
            _pools[n] = item;
        }
        return _pools[n];
    }
    static this_type * get_pool(uvm_object *owner)
    {
        return get_pool("", owner);
    }

    static this_type * get_global_pool() {
        return get_pool("global_pool");
    }

    virtual void do_print(std::ostream&) const {;}
    virtual void do_pack(uvm::uvm_packer&) const {;}
    virtual void do_unpack(uvm::uvm_packer&) {;}
    virtual void do_copy(const uvm::uvm_object*) {;}
    virtual bool do_compare(const uvm::uvm_object*) const { return true;}

protected:

    map<string, T*> _pool_map;

    static map<string, this_type*> _pools;

    static int uvm_object_register_uvm_pool;
};

template <class T> class uvm_object_creator_uvm_pool : public uvm_object_creator
{
public:
    uvm_object* create(const string& name)
    {
        uvm_object* _uvmsc_obj = new uvm_pool<T>(name);
        _uvmsc_obj->set_name(name);
        return _uvmsc_obj;
    }
};

template <typename T> std::map<string, uvm_pool<T>*> uvm_pool<T>::_pools;

// auto register
template <typename T> int uvm_pool<T>::uvm_object_register_uvm_pool = uvm::uvm_factory::register_uvm_object_creator(gen_type_name<uvm_pool<T> >, new uvm_object_creator_uvm_pool <T> ());

} // namespace

#endif  // __UVM_POOL_H__



