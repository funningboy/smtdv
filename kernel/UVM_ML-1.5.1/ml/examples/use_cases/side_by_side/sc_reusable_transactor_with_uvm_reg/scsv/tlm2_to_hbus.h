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

#ifndef _TLM2_TO_HBUS_H_
#define _TLM2_TO_HBUS_H_

#define NCSC_INCLUDE_TASK_CALLS
#include "systemc.h"
#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"
#define CLK_PERIOD 10
#define clkcycle sc_time(CLK_PERIOD, SC_NS)

using namespace tlm;
using namespace sc_dt;
using namespace tlm_utils;

class tlm2_to_hbus : public sc_module {
public :
  sc_in<sc_logic> clk;
  sc_in<sc_logic> resetn;
  sc_out<sc_lv<8> > haddr;
  sc_out<sc_logic> hen;
  sc_out<sc_logic> hwr_rd;
  sc_inout<sc_lv<8> > hdata;

  simple_target_socket<tlm2_to_hbus> tsocket;
  virtual void transport(tlm_generic_payload& tx, sc_time& dt);

  SC_HAS_PROCESS(tlm2_to_hbus);
  tlm2_to_hbus(sc_module_name mn) : sc_module(mn),
    clk("clk"),
    resetn("resetn"),
    haddr("haddr"),
    hen("hen"),
    hwr_rd("hwr_rd"),
    hdata("hdata"),
    tsocket("tsocket")
  {
	 cout << "construction of " << this->name() << endl;
	 tsocket.register_b_transport(this, &tlm2_to_hbus::transport);
    SC_THREAD(reset_signals);
    sensitive_pos << clk;
  }
  ~tlm2_to_hbus() {
  }
 private :
  void reset_signals() {
    hen.write(SC_LOGIC_0);
	 hdata.write("ZZZZZZZZ");
	 wait();
  }

};

void tlm2_to_hbus::transport(tlm_generic_payload& tx, sc_time& dt) {
  tlm_command opcode       = tx.get_command();
  uint64 addr              = tx.get_address();
  unsigned char * data_ptr = tx.get_data_ptr();
  
  cout << " transport from " << this->name() << " reset ended" << endl;
  wait(sc_time(CLK_PERIOD/2, SC_NS));
  wait(clkcycle);
  haddr.write(addr);
  hen.write(SC_LOGIC_1);
  hwr_rd.write((opcode == TLM_READ_COMMAND)?SC_LOGIC_0:SC_LOGIC_1);
  if (opcode == 1) {
     hdata.write((sc_lv<8>)data_ptr[0]);
	  wait(clkcycle);
     hdata.write("ZZZZZZZZ");
	  
  } else {
     wait(clkcycle);
	  data_ptr[0] = static_cast< sc_uint<8> >(hdata.read());	
     wait(clkcycle);
  }
  hen.write(SC_LOGIC_0);
  wait(clkcycle);
  
}


#endif // _TLM2_TO_HBUS_H_
