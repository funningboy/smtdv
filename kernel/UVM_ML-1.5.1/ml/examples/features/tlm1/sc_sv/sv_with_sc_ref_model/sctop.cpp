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

#include "uvm_ml.h"
using namespace tlm;
using namespace uvm_ml;

#include "packet.h"

template <typename T>
class mon1_in : public tlm_analysis_if<T> {
  void write(const T& t) {
    cout << "[SC " << sc_time_stamp() << "] mon1_in::write received " << t;
  };
};
template <typename T>
class mon2_in : public tlm_analysis_if<T> {
  void write(const T& t) {
    cout << "[SC " << sc_time_stamp() << "] mon2_in::write received " << t;
  };
};


// Template class of ref_model
// Prints the packets received through its export

template <typename T>
class ref_model : public sc_module {
public:
  sc_export<tlm_analysis_if<T> > aexport1;
  sc_export<tlm_analysis_if<T> > aexport2;
  mon1_in<T> m1;
  mon2_in<T> m2;

  SC_CTOR(ref_model) : aexport1("aexport1")
		     , aexport2("aexport2") 
  {
    aexport1(m1);
    aexport2(m2);
  }

};

SC_MODULE(sctop) {
  ref_model<packet> sub;
 
  SC_CTOR(sctop) :  sub("ref_model") {
    uvm_ml_register(&sub.aexport1); 
    uvm_ml_register(&sub.aexport2); 
  }
};

#ifndef NC_SYSTEMC
int sc_main(int argc, char** argv) {
#ifdef UVM_ML_PORTABLE_QUESTA
    sctop a_top("sctop");
    sc_start(-1);
#endif
  return 0;
}
#endif

UVM_ML_MODULE_EXPORT(sctop)
