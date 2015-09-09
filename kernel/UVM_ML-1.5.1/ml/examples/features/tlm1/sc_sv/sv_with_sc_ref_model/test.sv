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


module topmodule;
import uvm_pkg::*;
import uvm_ml::*;
   
`include "uvm_macros.svh"
   
class packet extends uvm_transaction;
   int    data;
   bit 	  kind;

   `uvm_object_utils_begin(packet)
   `uvm_field_int(data, UVM_ALL_ON)
   `uvm_field_int(kind, UVM_ALL_ON)
   `uvm_object_utils_end
     
   function void next();
      static int d = 101;
      data = d++;
   endfunction
   
   function int get_data();
      return data;
   endfunction // get_data

   function void set_kind();
      kind = 1;
   endfunction // set_kind 

   function new(string name = "packet");
     super.new(name);
   endfunction
   
endclass // packet
  

class monitor #(type T=packet) extends uvm_component;
    uvm_analysis_port #(T) aport;
  
    function new(string name, uvm_component parent=null);
      super.new(name,parent);
      aport=new("aport",this);
    endfunction
  
    typedef monitor#(T) monitor_type;
    `uvm_component_utils_begin(monitor_type)
    `uvm_component_utils_end

    task run_phase (uvm_phase phase);
      T p;
      phase.raise_objection(this);
      p = new();
      p.set_kind();
      p.next();
      
      for (integer i = 0; i < 6; i++) begin
	 `uvm_info(get_type_name(),$sformatf("monitor sends %d", p.get_data()),UVM_LOW);
         aport.write(p);
         #10;
         p.next();
      end
      phase.drop_objection(this); 
    endtask
  
  endclass

    
  class env extends uvm_env;
    monitor #(packet) mon1;
    monitor #(packet) mon2;

    function new (string name, uvm_component parent=null);
      super.new(name,parent);
    endfunction

    function void build();
      super.build();
      mon1 = new("monitor1", this);
      mon2 = new("monitor2", this);
   endfunction

    // Register ML ports at the end of build phase
    function void phase_ended(uvm_phase phase);
      if (phase.get_name() == "build") begin
        uvm_ml::ml_tlm1 #(packet)::register(mon1.aport);
        uvm_ml::ml_tlm1 #(packet)::register(mon2.aport);
      end
    endfunction

    // Connect ports in connect phase
    function void connect();
      bit res;
`ifdef UVM_ML_PORTABLE_QUESTA
        res   = uvm_ml::connect(mon1.aport.get_full_name(), "sc_main/sctop/ref_model/aexport1");
        res   = uvm_ml::connect(mon2.aport.get_full_name(), "sc_main/sctop/ref_model/aexport2");
`else
        res   = uvm_ml::connect(mon1.aport.get_full_name(), "sctop.ref_model.aexport1");
        res   = uvm_ml::connect(mon2.aport.get_full_name(), "sctop.ref_model.aexport2");
`endif
    endfunction

    `uvm_component_utils(env)

  endclass    


    // Test instantiates the "env"
    
  class test extends uvm_env;
    env top_env;

    function new (string name, uvm_component parent=null);
      super.new(name,parent);
    endfunction

    function void build();
      super.build();
      top_env = new("top_env", this);
    endfunction

    task run_phase(uvm_phase phase);
      while(1) begin
	 #1 uvm_ml::synchronize();
      end;                
    endtask // run_phase
   
    `uvm_component_utils(test)
  endclass // test

    
`ifdef USE_UVM_ML_RUN_TEST 
initial begin
    string tops[2];
    tops[0] = "SV:test";
`ifdef UVM_ML_PORTABLE_QUESTA
    tops[1] = "SC:sc_main/sctop";
`else
    tops[1] = "SC:sctop";
`endif    
    uvm_ml_run_test(tops, "");
end
`endif
endmodule
