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

#include "systemc.h"

class hbus : public ncsc_foreign_module {
public:
  sc_out<sc_logic> clk;
  sc_out<sc_logic> resetn;
  sc_in<sc_lv<8> > haddr;
  sc_in<sc_logic> hen;
  sc_in<sc_logic> hwr_rd;
  sc_inout<sc_lv<8> > hdata;

	hbus(
		sc_module_name nm
	) : ncsc_foreign_module(nm)
		, clk("clk")
		, resetn("resetn")
		, haddr("haddr")
		, hen("hen")
		, hwr_rd("hwr_rd")
		, hdata("hdata")
	{
	}

	const char* hdl_name() const { return "hbus"; }
};
