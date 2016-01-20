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

`include "producer.sv"

// env component containing a producer
class env extends uvm_env;
   producer prod;   
   
   function new (string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"SV env::new ",UVM_LOW);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV env::build",UVM_LOW);
      prod = producer::type_id::create("producer", this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"SV env::connect ",UVM_LOW);
   endfunction

   `uvm_component_utils(env)   
endclass    

// top component
class svtop extends uvm_test;
   env sv_env;
   string e_consumer = "sys.env.consumer.";
    
   `uvm_component_utils(svtop)

   function new (string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"SV svtop::new",UVM_LOW);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV svtop::build ",UVM_LOW);
      sv_env = env::type_id::create("sv_env", this);
   endfunction

   // register the ML sockets
   function void phase_ended(uvm_phase phase);
      if (phase.get_name() == "build") begin
	 `uvm_info(get_type_name(),"SV svtop::build phase ended",UVM_LOW);
	 uvm_ml::ml_tlm2 #()::register(sv_env.prod.b_initiator_socket);
	 uvm_ml::ml_tlm2 #()::register(sv_env.prod.nb_initiator_socket);
      end
   endfunction

   // connect the ML sockets
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"SV svtop::connect ",UVM_LOW);

        if(!uvm_ml::connect(sv_env.prod.b_initiator_socket.get_full_name(), {e_consumer, "b_tsocket"})) begin
	   `uvm_fatal("MLCONN", "uvm_ml connect failed");
        end;
        if(!uvm_ml::connect(sv_env.prod.nb_initiator_socket.get_full_name(), {e_consumer, "nb_tsocket"})) begin
	   `uvm_fatal("MLCONN", "uvm_ml connect failed");
        end;
   endfunction

endclass
  
module topmodule;
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[2];

   tops[0] = "sv:svtop";
   tops[1] = "e:top.e";
   
   uvm_ml_run_test(tops, "");
end
`endif
   
endmodule


