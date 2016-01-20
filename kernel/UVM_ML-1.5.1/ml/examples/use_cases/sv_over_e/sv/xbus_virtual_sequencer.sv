//----------------------------------------------------------------------
//   Copyright 2008-2010 Cadence Design Systems, Inc.
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

`include "seq_lib.sv"

class xbus_virtual_sequencer extends uvm_sequencer;

    ml_sequencer_proxy seqr_proxy_0;
    ml_sequencer_proxy seqr_proxy_1;

     `uvm_component_utils(xbus_virtual_sequencer)

    function new(string name,uvm_component parent=null);
       super.new(name, parent);  
    endfunction // new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      $display("SV xbus_virt_seqr::build ", get_full_name());
      seqr_proxy_0 = ml_sequencer_proxy::type_id::create("seqr_proxy_0", this); // for active agent 0
      seqr_proxy_1 = ml_sequencer_proxy::type_id::create("seqr_proxy_1", this);   // for active agent 1
   endfunction // build_phase
   
   
endclass // xbus_virt_sequencer


class xbus_virt_seq extends uvm_sequence;
   
   `uvm_declare_p_sequencer(xbus_virtual_sequencer)
   
   xbus_seq seq;
   
   `uvm_object_utils_begin(xbus_virt_seq)
      `uvm_field_object(seq,UVM_ALL_ON )
   `uvm_object_utils_end
   
   function new(string name = "xbus_virt_seq");
       super.new(name);
   endfunction
   
   virtual task body();
      
      `uvm_info(get_type_name(),"Invoking sequences in proxy sequencers", UVM_LOW);
      fork
	 begin
	    `uvm_info(get_type_name(),"Starting sequence driving on MASTER_0", UVM_LOW);
	    `uvm_do_on(seq, p_sequencer.seqr_proxy_0)
	 end
	 begin
	    `uvm_info(get_type_name(),"Starting sequence driving on MASTER_1", UVM_LOW);
	    `uvm_do_on(seq, p_sequencer.seqr_proxy_1)
	 end
      join       
      #100ns; // drain time
      `uvm_info(get_type_name(),"** TEST PASSED **",UVM_LOW)
   endtask // body
   
   
   task pre_body(); 
      uvm_phase st_phase;

`ifdef UVM_VERSION_1_2
      st_phase = get_starting_phase();
`else
      st_phase = starting_phase;
`endif
      if(st_phase != null) begin
	st_phase.raise_objection(this);
      end
   endtask // pre_body
   
   task post_body(); 
      uvm_phase st_phase;

`ifdef UVM_VERSION_1_2
      st_phase = get_starting_phase();
`else
      st_phase = starting_phase;
`endif
      if(st_phase != null) begin
	st_phase.drop_objection(this);
      end
   endtask // post_body

   
endclass // xbus_virt_seq

