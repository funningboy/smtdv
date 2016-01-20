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

class my_object extends uvm_object;
  `uvm_object_utils(my_object)
  int data;
  function new(string name="");
    super.new(name);
    data = 0;
  endfunction
  function void do_pack (uvm_packer packer);
    super.do_pack(packer); // pack mysupertype properties
    packer.pack_field_int(data, 32);
  endfunction
  function void do_unpack (uvm_packer packer);
    int d;
    super.do_unpack(packer); // unpack super's properties
    d = packer.unpack_field_int(32);
    this.data = d;
  endfunction
endclass

//----------------------------------------------------------------------
// mate 
//----------------------------------------------------------------------


class my_callback_d extends uvm_event_callback;
  int expected;
  int auto_inc;
  function new(string name="");
    super.new(name);
    expected = 0;
    auto_inc = 0;
  endfunction
`ifdef UVM_VERSION_1_2
  virtual function void post_trigger(uvm_event e, uvm_object data);
`else
  virtual function void post_trigger(uvm_event e, uvm_object data = null);
`endif
    my_object d;
    expected = expected + auto_inc;
    $cast(d, data);
    $display("[SV ",$realtime," ] trigger event %s", e.get_full_name(), " : ", d.data, " : expected ", expected);
    if(d.data != expected) begin
        `uvm_fatal("MLEVENT", "data does not match expected");
    end
  endfunction
endclass

class my_callback extends uvm_event_callback;
  int counter;
  function new(string name="");
    super.new(name);
    counter = 0;
  endfunction

`ifdef UVM_VERSION_1_2
  virtual function void post_trigger(uvm_event e, uvm_object data);
`else
  virtual function void post_trigger(uvm_event e, uvm_object data = null);
`endif
    counter ++;
    $display("[SV ",$realtime," ] trigger event %s", e.get_full_name(), " : ", counter);
  endfunction
  virtual function void check_counter(int c);
    $display("[SV ",$realtime," ] counter : ", counter, " : expected ", c);
    if(counter != c) begin
        `uvm_fatal("MLEVENT", "Counter does not match expected");
    end
  endfunction
endclass

class mate extends uvm_component;

    uvm_event_pool epool;
    uvm_event_pool gpool;
    uvm_event e_named_pool_d;
    uvm_event e_named_pool;
    uvm_event e_global_pool_d;
    uvm_event e_global_pool;
    my_callback_d cb_named_pool_d;
    my_callback   cb_named_pool;
    my_callback_d cb_global_pool_d;
    my_callback   cb_global_pool;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        epool = uvm_ext_event_pool::get_pool("uvm_test_top.env.mate");
        gpool = uvm_ext_event_pool::get_global_pool();
        e_named_pool_d  = epool.get("event_from_named_pool_d");
        e_named_pool    = epool.get("event_from_named_pool");
        e_global_pool_d = gpool.get("event_from_global_pool_d");
        e_global_pool   = gpool.get("event_from_global_pool");
        cb_named_pool_d  = new();
        cb_named_pool    = new();
        cb_global_pool_d = new();
        cb_global_pool   = new();
        e_named_pool_d.add_callback(cb_named_pool_d);
        e_named_pool.add_callback(cb_named_pool);
        e_global_pool_d.add_callback(cb_global_pool_d);
        e_global_pool.add_callback(cb_global_pool);
    endfunction

    `uvm_component_utils(mate)

    function void build();
    endfunction

    function void connect();
    endfunction

    task run_phase(uvm_phase phase);
       int counter_named_pool = 0;
       int counter_global_pool = 0;
       #1;
       // #1
       // trigger event from named pool with data
       for(int i=0; i < 10; i++) begin
           event_from_named_pool_d_trigger();
           #10;
       end
       // #101
       // wait event from named pool of sc with data
       cb_named_pool_d.auto_inc = 3;
       for(int i=0; i < 10; i++) begin
         #10;
       end
       cb_named_pool_d.auto_inc = 0;
       #2
       // #203
       // trigger event from global pool with data
       for(int i=0; i < 10; i++) begin
           event_from_global_pool_d_trigger();
           #10;
       end
       // #303
       // wait event from global pool of sc with data
       cb_global_pool_d.auto_inc = 3;
       for(int i=0; i < 10; i++) begin
         #10;
       end
       cb_global_pool_d.auto_inc = 0;
       #1
       // #404
       // trigger event from named pool
       for(int i=0; i < 10; i++) begin
           event_from_named_pool_trigger();
           counter_named_pool ++;
           #10;
       end
       // wait event from named pool of sc
       for(int i=0; i < 10; i++) begin
         counter_named_pool ++;
         #10;
       end
       // trigger event from global pool
       for(int i=0; i < 10; i++) begin
           event_from_global_pool_trigger();
           counter_global_pool ++;
           #10;
       end
       // wait event from global pool of sc
       for(int i=0; i < 10; i++) begin
         counter_global_pool ++;
         #10;
       end
       #1;
       // check triggerd counters;
       cb_named_pool.check_counter(counter_named_pool);
       cb_global_pool.check_counter(counter_global_pool);
       #1;
       // reset e_global_pool
       e_global_pool.reset();
       assert(e_global_pool_d.is_on());
       #2;
       // check reset e_global_pool_d
       if(e_global_pool_d.is_off() == 0) begin
           `uvm_fatal("MLEVENT", "Global pool is not off");
       end
       // delete e_global_pool;
       gpool.delete("event_from_global_pool");
       #2;
       // check deleted event_from_global_pool_d
       if(gpool.exists("event_from_global_pool_d")) begin
           `uvm_fatal("MLEVENT", "Global pool event 'event_from_global_pool_d' is not deleted");
       end
       #10;
    endtask

    function void event_from_named_pool_d_trigger();
       my_object d;
       d = new();
       cb_named_pool_d.expected = cb_named_pool_d.expected + 3;
       d.data = cb_named_pool_d.expected;
       e_named_pool_d.trigger(d);
    endfunction

    function void event_from_named_pool_trigger();
       e_named_pool.trigger();
    endfunction

    function void event_from_global_pool_d_trigger();
       my_object d;
       d = new();
       cb_global_pool_d.expected = cb_global_pool_d.expected + 3;
       d.data = cb_global_pool_d.expected;
       e_global_pool_d.trigger(d);
    endfunction

    function void event_from_global_pool_trigger();
       e_global_pool.trigger();
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
        phase.raise_objection(this);
        #10000;
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
