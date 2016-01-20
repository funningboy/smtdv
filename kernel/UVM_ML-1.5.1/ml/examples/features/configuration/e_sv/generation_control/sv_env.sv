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

`include "packet.sv"
    
  class env extends uvm_env;

    function new (string name, uvm_component parent=null);
      super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV env::build",UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
      packet p;
      p = packet::type_id::create("packet", this);
      p.randomize();
      $display("size = %d ", p.data.size());
      foreach (p.data[i]) $display("%d ", p.data[i]);    
    endtask : run_phase
  
    `uvm_component_utils(env)
  endclass

  class ml_env extends env;
    trans_size transfer_kind;
 
    function new (string name, uvm_component parent=null);
      super.new(name,parent);      
    endfunction
 
    function void build_phase(uvm_phase phase);
      int tmp_kind;

      super.build_phase(phase);
      void'(uvm_config_int::get(this, "", "transfer_kind", tmp_kind));
      transfer_kind = trans_size'(tmp_kind);

      if (transfer_kind == SHORT_TRANSACTION ) begin
	 $display(">>>>>>>>>>> override to short_trans ");
	 packet::type_id::set_type_override(short_trans::get_type());	 
      end
      if (transfer_kind == LONG_TRANSACTION ) begin
	 $display(">>>>>>>>>>> override to long_trans ");
	 packet::type_id::set_type_override(long_trans::get_type());
      end
    endfunction

    `uvm_component_utils(ml_env)
  endclass : ml_env

module topmodule;
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[1];
   
   tops[0] = "";
   
   uvm_ml_run_test(tops, "e:top.e");
end
`endif
endmodule
