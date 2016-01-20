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
// Respond to messages from ML producer
//----------------------------------------------------------------------

class consumer #(type T=packet) extends uvm_component;

    uvm_blocking_put_imp    #(T, consumer #(T)) put_export;
    uvm_nonblocking_put_imp #(T, consumer #(T)) put_nb_export;

    typedef consumer#(T) cons_type;
    `uvm_component_utils_begin(cons_type)
    `uvm_component_utils_end
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
      `uvm_info(get_type_name(),"SV consumer::new",UVM_LOW);
      put_export    = new("put_export",this);
      put_nb_export = new("put_nb_export",this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV consumer::build",UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"SV consumer::connect",UVM_LOW);
    endfunction


    // implement TLM1 put interface
    task put (T p);
      `uvm_info(get_type_name(),$sformatf("SV consumer::put %d",p.data),UVM_LOW);
      #1ns;
      `uvm_info(get_type_name(),$sformatf("SV consumer::put returns %d", p.data),UVM_LOW);
    endtask 

    function bit try_put (T p);
      `uvm_info(get_type_name(),$sformatf("SV consumer::try_put %d",p.data),UVM_LOW);
      return 1;
    endfunction 

    function bit can_put ();
      `uvm_info(get_type_name(),"SV consumer::can_put()",UVM_LOW);
      return 1;
    endfunction 

endclass
