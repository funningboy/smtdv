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

import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_ml::*;

parameter WIDTH = 128;

`include "packet.sv"
`include "consumer.sv"

//----------------------------------------------------------------------
// env
//----------------------------------------------------------------------
class env extends uvm_component;

    `uvm_component_utils(env)

    consumer #(psi_word#(WIDTH)) cons;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_type_name(),"SV env::new ",UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV env::build",UVM_LOW);
      cons = consumer #(psi_word#(WIDTH))::type_id::create("consumer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(),"Connecting the sockets",UVM_LOW);
    endfunction

endclass

//----------------------------------------------------------------------
// top
//----------------------------------------------------------------------
class svtop extends uvm_env;

    `uvm_component_utils(svtop)

    env sv_env;
    string e_producer = "sys.env.producer.";
    bit res;

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"SV svtop::new ",UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"SV svtop::build ",UVM_LOW);
        sv_env = env::type_id::create("sv_env", this);
    endfunction

    function void phase_ended(uvm_phase phase);
        // Register ML ports and sockets
        if (phase.get_name() == "build") begin
	   uvm_ml::ml_tlm1 #(psi_word#(WIDTH))::register(sv_env.cons.get_imp);
	   uvm_ml::ml_tlm1 #(psi_word#(WIDTH))::register(sv_env.cons.put_imp);
         end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(),"SV svtop::connect ",UVM_LOW);
        if(!uvm_ml::connect({e_producer, "get_port"}, sv_env.cons.get_imp.get_full_name())) begin
	   `uvm_fatal("MLCONN", "uvm_ml connect failed");
        end;
        if(!uvm_ml::connect({e_producer, "put_port"}, sv_env.cons.put_imp.get_full_name())) begin
	   `uvm_fatal("MLCONN", "uvm_ml connect failed");
        end;
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        for (integer i = 0; i < 1000000; i++) begin
            uvm_ml::synchronize();
            #1;
        end    
        phase.drop_objection(this);
    endtask
endclass

module topmodule;
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[2];

   tops[0] = "sv:svtop";
   tops[1] = "e:top.e";

   uvm_ml_run_test(tops, "");
end // initial begin
`endif
endmodule
