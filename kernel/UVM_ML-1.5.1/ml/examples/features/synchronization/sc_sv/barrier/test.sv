//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   Copyright 2014 Advanced Micro Devices, Inc.
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

`timescale 1 ps/1 ps        // align with SystemC timescale

import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_ml::*;

//----------------------------------------------------------------------
// mate 
//----------------------------------------------------------------------

class mate extends uvm_component;

    uvm_barrier_pool bpool;
    uvm_barrier_pool gpool;
    uvm_barrier b;
    uvm_barrier b_g;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        bpool = uvm_ext_barrier_pool::get_pool("uvm_test_top.env.mate");
        gpool = uvm_ext_barrier_pool::get_global_pool();
        b = bpool.get("test_barrier");
        b_g = gpool.get("test_barrier");
    endfunction

    `uvm_component_utils(mate)

    function void build();
    endfunction

    function void connect();
    endfunction

    task run_phase(uvm_phase phase);
       #1
       $display("[SV ",$realtime," ps] wait for barrier");
       b.wait_for();
       $display("[SV ",$realtime," ps] go through barrier");
       $display("[SV ",$realtime," ps] raise barrier");
       b.set_threshold(1);
       #2;
       $display("[SV ",$realtime," ps] drop barrier");
       b.set_threshold(0);
       #2;
       $display("[SV ",$realtime," ps] drop barrier");
       b.set_threshold(0);
       #1;
       $display("[SV ",$realtime," ps] raise barrier and wait");
       b.set_threshold(2);
       b.wait_for();
       $display("[SV ",$realtime," ps] go through barrier");
       #2;
       $display("[SV ",$realtime," ps] drop global barrier");
       b_g.set_threshold(0);
       #1;
       gpool.delete("test_barrier");
       #4;
       if(gpool.exists("test_barrier")) begin
           `uvm_fatal("MLBARRIER", "barrier 'test_barrier' not deleted");
       end
       #10;
    endtask

endclass

//----------------------------------------------------------------------
// env
//----------------------------------------------------------------------
class env extends uvm_component;

    `uvm_component_utils(env)

    mate c;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build();
        c = new("mate", this);
    endfunction

    function void phase_ended(uvm_phase phase);
    endfunction

    function void connect();
    endfunction

endclass

//----------------------------------------------------------------------
// test
//----------------------------------------------------------------------
class test extends uvm_component;

    `uvm_component_utils(test)

    env e;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build();
        e = new("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);
    endtask
endclass

module top1;
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[1];

   $timeformat(-12,0," ps", 4);

`ifdef UVM_ML_PORTABLE_QUESTA
    tops[0]   = "SC:sc_main/top";
    
`else
                tops[0]   = "SC:top";
`endif

   uvm_ml_run_test(tops, "SV:test");
end // initial begin
`endif
endmodule
