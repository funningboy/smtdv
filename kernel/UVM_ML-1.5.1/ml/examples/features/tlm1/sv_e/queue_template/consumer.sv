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

//----------------------------------------------------------------------
// consumer
// Respond to messages from e producer
//----------------------------------------------------------------------
class consumer #(type T=psi_word#(128)) extends uvm_component;
    uvm_get_imp #(T, consumer#(T)) get_imp;
    uvm_nonblocking_put_imp #(T, consumer#(T)) put_imp;

    int unsigned transaction_count;
    int call_index;

    typedef consumer#(T) cons_type;
    `uvm_component_utils_begin(cons_type)
    `uvm_component_utils_end
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
      `uvm_info(get_type_name(),"SV consumer::new",UVM_LOW);
      get_imp = new("get_imp", this);
      put_imp = new("put_imp", this);
      call_index = 1;      
    endfunction


    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"SV consumer::connect",UVM_LOW);
    endfunction

   virtual task put(T obj);
      `uvm_info(get_type_name(),$sformatf("SV consumer put val = %0d %0d", 
					  obj.combined[0].val, 
					  obj.combined[0].pkt_data[0]),UVM_LOW);
      call_index++;
      #50;
      transaction_count++;
   endtask // put

   virtual function bit try_put(T obj);
      `uvm_info(get_type_name(),$sformatf("SV consumer put val = %0d %0d", 
					  obj.combined[0].val, 
					  obj.combined[0].pkt_data[0]),UVM_LOW);
      call_index++;
      transaction_count++;
   endfunction 
   virtual function bit can_put();
   endfunction

   //get functions implementation
   virtual task get(output T obj);
      string exp_txt;
      cppi_pkt_data pkt;
      
      obj = new;   
      pkt = new;
      pkt.val = 17+call_index;
      pkt.pkt_data[0] = 128+call_index;
      obj.combined[0] = pkt;
      `uvm_info(get_type_name(),$sformatf("SV consumer get val = %0d %0d", 
					  obj.combined[0].val, 
					  obj.combined[0].pkt_data[0]),UVM_LOW);
      call_index++;
      #50;
      transaction_count++;
   endtask // get

   virtual function bit try_get(output T obj);
      string exp_txt;
   endfunction // try_get
   
   virtual function bit can_get();
      `uvm_info(get_type_name(),$sformatf("going to return %d",can_get),UVM_LOW);
   endfunction 


endclass
