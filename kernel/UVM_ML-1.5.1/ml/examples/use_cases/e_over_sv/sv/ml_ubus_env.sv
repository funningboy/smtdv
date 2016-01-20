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

`include "ubus_exported.sv" // manual type mapping
`include "seqr_tlm_interface.sv"


// Ubus master specific additions
class ubus_master_seqr_tlm_if extends ml_seqr_tlm_if#(ubus_transfer,ubus_base_sequence);

  `uvm_component_utils(ubus_master_seqr_tlm_if)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Control randomization of the item in ubus
  function uvm_sequence_item set_fields(uvm_sequence_item item);
      ubus_transfer tr;   
      if($cast(tr, item)) begin
	 tr.addr.rand_mode(0); // do not randomize
	 tr.size.rand_mode(0);
	 tr.read_write.rand_mode(0);
	 tr.data.rand_mode(0);
	 //tr.wait_state.rand_mode(0);
	 //tr.error_pos.rand_mode(0);
	 //tr.transmit_delay.rand_mode(0);
      end;
      return tr;      
  endfunction : set_fields

  task update_response(item_seq s, uvm_sequence_item req, uvm_sequence_item response);  
      TR ireq;
      
      if(!$cast(ireq, req)) `uvm_fatal("get_response","Cannot cast response");
      if(ireq.read_write == READ) begin	    
	 s.get_response(response);
	 rsp = response;
	 get_response_p.put(rsp); // send read response
      end else
	 get_response_p.put(req); // send write response
  endtask : update_response
    
endclass : ubus_master_seqr_tlm_if

  
// Master sequencer with TLM IF replacing the original sequencer
class ubus_master_ml_sequencer extends ubus_master_sequencer;
  ubus_master_seqr_tlm_if seqr_tlm_if;
  `uvm_component_utils(ubus_master_ml_sequencer)
     
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
    
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr_tlm_if = ubus_master_seqr_tlm_if::type_id::create("seqr_tlm_if", this);
  endfunction 

  // set the sequencer pointer of the TLM interface
  function void end_of_elaboration_phase(uvm_phase phase);      
    void'(seqr_tlm_if.set_seqr(this));
  endfunction
endclass : ubus_master_ml_sequencer

   
class ml_ubus_env extends ubus_env;
  int slave0_max;
  int slave1_max;
  string slave_seq_name;

  `uvm_component_utils(ml_ubus_env)

  function new(string name, uvm_component parent);
      super.new(name, parent);
      $display("ml_ubus_env::new %s", get_full_name());
  endfunction : new
    
  function void build_phase(uvm_phase phase);
    uvm_factory factory = uvm_factory::get();
    uvm_object_wrapper seq_wrap;  
      
    super.build_phase(phase);
    // substitute the sequencer to add the TLM interface
    set_type_override_by_type(ubus_master_sequencer::get_type(), 
			      ubus_master_ml_sequencer::get_type());
      
    // Select the slave sequences
    void'(uvm_config_string::get(this, "", "slave_seq_name", slave_seq_name));
`ifdef UVM_VERSION_1_2
    seq_wrap = factory.find_wrapper_by_name(slave_seq_name);
`else
    seq_wrap = factory.find_by_name(slave_seq_name);
`endif
    if(seq_wrap == null) uvm_report_error("", 
       $sformatf("Could not find sequence by the name %s", slave_seq_name));
            
    uvm_config_db#(uvm_object_wrapper)::set(this,
					    "slaves[0].sequencer.run_phase", 
					    "default_sequence",
					    seq_wrap);
    uvm_config_db#(uvm_object_wrapper)::set(this,
					    "slaves[1].sequencer.run_phase", 
					    "default_sequence",
					    seq_wrap);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
      // Set the slave address space
      void'(uvm_config_int::get(this, "", "slave0_max", slave0_max));      
      void'(uvm_config_int::get(this, "", "slave1_max", slave1_max)); 
      set_slave_address_map("slaves[0]", 0, slave0_max);
      set_slave_address_map("slaves[1]", slave0_max+1, slave1_max);
  endfunction : end_of_elaboration_phase // unmatched end(function|task|module|primitive)
    
  // avoid premature termination since ubus is used as slave
  task run_phase(uvm_phase phase);
      phase.raise_objection(this);
  endtask : run_phase

endclass : ml_ubus_env

  
