
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_ml::*;

import xor1::*;

`include "producer.sv"

class svtop extends uvm_test;
   
   `uvm_component_utils(svtop)
   
   uvm_component verify;
   producer  prod;
   
   function new (string name, uvm_component parent=null);
      super.new(name,parent);
      `uvm_info(get_type_name(),$sformatf("SV svtop::new %s", name),UVM_LOW);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),$sformatf("SV svtop::build"),UVM_LOW);
      //set the UVM configuration
      // for IES 14.1 and later
      uvm_config_string::set(this,"verify","agent()","SV");
      uvm_config_string::set(this,"verify","hdl_path()","~/top.xor_try");
      // for IES 13.1 and 13.2
      uvm_config_string::set(this,"verify","agent","SV");
      uvm_config_string::set(this,"verify","hdl_path","~/top.xor_try");
      // create local SV env
       prod = producer#()::type_id::create("prod", this);
      // create remote ML junction node in e
      verify = uvm_ml_create_component("e", "verify", "verify", this);
   endfunction
   
   // Register ML sockets
   function void phase_ended(uvm_phase phase);
      if (phase.get_name() == "build") begin
	 uvm_ml::ml_tlm1 #(operation)::register(prod.get_imp);
      end
   endfunction
   
   // Connect sockets
   function void connect_phase(uvm_phase phase);
      string e_consumer = "uvm_test_top.verify.";
      super.connect_phase(phase);
      `uvm_info(get_type_name(),$sformatf("SV svtop::connect %s", get_full_name()),UVM_LOW);
      if(!uvm_ml::connect( {e_consumer, "get_port"},prod.get_imp.get_full_name())) begin
         `uvm_info(get_type_name(),$sformatf("SV svtop::connect failed %s", prod.get_imp.get_full_name()),UVM_LOW);
	 `uvm_fatal("MLCONN", "uvm_ml connect failed");
      end;
endfunction
   
   // Watchdof time - the e is supposed to end the simulation
   task run_phase (uvm_phase phase);
      phase.raise_objection(this);
      #1000ns;
      phase.drop_objection(this);
   endtask
   
   function void resolve_bindings();
      `uvm_info(get_type_name(),$sformatf("SV env::resolve_bindings %s", get_full_name()),UVM_LOW);
   endfunction
   
   function void end_of_elaboration();
      `uvm_info(get_type_name(),$sformatf("SV env::end_of_elaboration %s", get_full_name()),UVM_LOW);
   endfunction
   
   function void start_of_simulation();
      `uvm_info(get_type_name(),$sformatf("SV env::start_of_simulation %s", get_full_name()),UVM_LOW);
   endfunction
   
endclass // svtop


