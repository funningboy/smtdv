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

class producer #(type T=packet) extends uvm_component;

  uvm_blocking_put_port    #(T) put_port;
  uvm_nonblocking_put_port #(T) put_nb_port;
   
  function new(string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),"SV producer::new",UVM_LOW);
      put_port    = new("put_port",this);
      put_nb_port = new("put_nb_port",this);
  endfunction

  typedef producer#(T) prod_type;
  `uvm_component_utils_begin(prod_type)
  `uvm_component_utils_end
  
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV producer::build",UVM_LOW);
  endfunction

  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"SV producer::connect",UVM_LOW);
  endfunction

  task run_phase(uvm_phase phase);
      T p;
      int count;
      bit b;
      
      phase.raise_objection(this);
      p = new;      
      #10ns;
      
      // start TLM1 transactions
      `uvm_info(get_type_name(),"*** Nonblocking TLM1 transactions from SV ",UVM_LOW);
      for (count =0; count < 3; count++) begin	 
	 #5ns;
	 p.next();
	 `uvm_info(get_type_name(),$sformatf("SV producer::try_put %d",p.data),UVM_LOW);
	 b = put_nb_port.try_put(p);
	 `uvm_info(get_type_name(),"SV producer::try_put returned ",UVM_LOW);
      end // for
      #10ns;
      
      `uvm_info(get_type_name(),"*** Blocking TLM1 transactions from SV ",UVM_LOW);
      for (count =0; count < 3; count++) begin	 
	 p.next();
	 `uvm_info(get_type_name(),$sformatf("SV producer::putting %d",p.data),UVM_LOW);
	 put_port.put(p);
	 `uvm_info(get_type_name(),"SV producer::put returned ",UVM_LOW);
	 #5ns;
      end // for
           
      phase.drop_objection(this);
  endtask // run_phase

endclass

