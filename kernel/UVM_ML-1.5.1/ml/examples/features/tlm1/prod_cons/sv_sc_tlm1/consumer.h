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
#include "packet.h"

template <class T>
class consumer : public uvm_component 
               , tlm_blocking_put_if<T> 
	       , tlm_nonblocking_put_if<T> 
{
public:
  sc_export<tlm_blocking_put_if<T> >    put_export;
  sc_export<tlm_nonblocking_put_if<T> > put_nb_export;
  int ind1, ind2;
  unsigned char* data;

  consumer(sc_module_name nm) : uvm_component(nm)
			      , put_export("put_export")
                              , put_nb_export("put_nb_export")
  { 
    put_export(*this);
    put_nb_export(*this);
  }

  UVM_COMPONENT_UTILS(consumer)

  void build() {
    cout << "SC consumer::build" << endl;
  }

  // methods to implement TLM1 put
  virtual void put( const T& t ) {
    cout << "[SC " <<  sc_time_stamp() << "] consumer::put: " << t << endl;
    save = t.data;
    wait(1, SC_NS);
    cout << "[SC " <<  sc_time_stamp() << "] consumer::put done " << endl;
  }

  virtual bool nb_put( const T& t ) {
    cout << "[SC " <<  sc_time_stamp() << "] consumer::nb_put: " << t << endl;
    save = t.data;
    return true;
  }

  virtual bool nb_can_put( tlm_tag<T> *t ) const {
    cout << "[SC " <<  sc_time_stamp() << "] consumer::nb_can_put" << endl;
    return true;
  }

  virtual const sc_event &ok_to_put( tlm_tag<T> *t ) const { 
    return dummy; 
  }

  sc_event dummy;
  int save;
};
