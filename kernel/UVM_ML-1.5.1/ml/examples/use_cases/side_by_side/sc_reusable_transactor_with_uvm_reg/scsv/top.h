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

#ifndef _TOP_TESTBENCH_H_
#define _TOP_TESTBENCH_H_

#include "systemc.h"

#include "hbus.h"
#include "tlm2_to_hbus.h"
#include "uvm_ml.h"

class top : public sc_module {
public :

  hbus BUS;
  tlm2_to_hbus TRANSACTOR;
  sc_signal<sc_logic> resetn;
  sc_signal<sc_logic> clk;
  sc_signal<sc_lv<8> > haddr;
  sc_signal<sc_logic> hen;
  sc_signal<sc_logic> hwr_rd;
  sc_signal<sc_lv<8> > hdata;

  top(sc_module_name name_) :
    sc_module(name_),
    BUS("BUS"),
    TRANSACTOR("TRANSACTOR"),
    resetn("resetn"),
    clk("clk"),
    haddr("haddr"),
    hen("hen"),
    hwr_rd("hwr_rd"),
    hdata("hdata")
  {
    cout << "construction of " << this->name() << endl;
    TRANSACTOR.clk(clk);
    TRANSACTOR.resetn(resetn);
    TRANSACTOR.haddr(haddr);
    TRANSACTOR.hen(hen);
    TRANSACTOR.hwr_rd(hwr_rd);
    TRANSACTOR.hdata(hdata);
    std::string full_target_socket_name = ML_TLM2_REGISTER_TARGET(TRANSACTOR, tlm_generic_payload, tsocket, 32);

    BUS.clk(clk);
    BUS.resetn(resetn);
    BUS.haddr(haddr);
    BUS.hen(hen);
    BUS.hwr_rd(hwr_rd);
    BUS.hdata(hdata);
  }

  ~top() {
  }

};

#endif // _TOP_TESTBENCH_H_
