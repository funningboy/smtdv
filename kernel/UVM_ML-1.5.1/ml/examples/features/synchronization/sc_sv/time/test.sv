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

class my_callback extends uvm_event_callback;
  function new(string name="");
    super.new(name);
  endfunction
  virtual function void post_trigger(uvm_event e, uvm_object data);
    $display("[SV ",$realtime," ps] trigger event %s", e.get_full_name());
    if($realtime != 3) begin
        `uvm_fatal("MLSYNC", "time does not match expected");
    end
  endfunction
endclass

class mate extends uvm_component;

    uvm_event_pool epool;
    uvm_event e;
    uvm_event e2;
    my_callback cb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        epool = uvm_ext_event_pool::get_pool("uvm_test_top.env.mate");
        e = epool.get("test_event");
        e2 = epool.get("test_event2");
        cb = new();
        e2.add_callback(cb);
    endfunction

    `uvm_component_utils(mate)

    function void build();
    endfunction

    function void connect();
    endfunction

    task run_phase(uvm_phase phase);
       phase.raise_objection(this);
       #1;
       for(int i=0; i < 10; i++) begin
           event_trigger();
           #10;
       end
       #10;
       phase.drop_objection(this);
    endtask

    function void event_trigger();
       e.trigger();
    endfunction

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
    endtask
endclass

module top1;
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[1];

`ifdef UVM_ML_PORTABLE_QUESTA
    tops[0]   = "SC:sc_main/top";
    
`else
                tops[0]   = "SC:top";
`endif

   uvm_ml_run_test(tops, "SV:test");
end // initial begin
`endif
endmodule
