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

module test;
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_ml::*;
`include "reg_model.sv"


class tlm2_sequencer extends uvm_sequencer #(uvm_tlm_generic_payload);

  `uvm_component_utils(tlm2_sequencer)
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : tlm2_sequencer

class tlm2_driver extends uvm_driver #(uvm_tlm_generic_payload);

   uvm_tlm_b_initiator_socket #(uvm_tlm_generic_payload) initiator_socket;
  `uvm_component_utils(tlm2_driver)

  function void phase_ended(uvm_phase phase);
    if (phase.get_name() == "build") begin
      uvm_ml::ml_tlm2#()::register(initiator_socket);
    end
  endfunction

  function new (string name, uvm_component parent);
    super.new(name, parent);
    initiator_socket = new("initator_socket", this);
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    fork
      get_and_send();
    join
  endtask : run_phase

  virtual protected task get_and_send();
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info(get_type_name(), $sformatf("Driving transaction :\n%s",req.sprint()), UVM_MEDIUM)
      send_transaction(req);
      seq_item_port.item_done();
    end
  endtask : get_and_send

  virtual protected task send_transaction (uvm_tlm_generic_payload transaction);
    uvm_tlm_sync_e sync;
	 uvm_tlm_time delay = new;
    initiator_socket.b_transport(transaction, delay);
    assert(sync == UVM_TLM_ACCEPTED);
    
  endtask : send_transaction

endclass : tlm2_driver

class reg_test extends uvm_test;
  reg_block_slave model; 
  tlm2_sequencer tlm2_seqr;
  tlm2_driver tlm2_drv;
  `uvm_component_utils(reg_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    tlm2_seqr = tlm2_sequencer::type_id::create("tlm2_seqr",this);
    tlm2_drv = tlm2_driver::type_id::create("tlm2_drv",this);
  
    if (model == null) begin
        model = reg_block_slave::type_id::create("model",this);
        model.build();  	 
        model.lock_model();
    end

   super.build_phase(phase);
  endfunction : build_phase
  
   virtual function void connect_phase(uvm_phase phase);	
	   bit result;	  
	   uvm_reg_tlm2_adapter reg2tlm2 = new;		
      tlm2_drv.seq_item_port.connect(tlm2_seqr.seq_item_export);
      if (model.get_parent() == null) begin
      	 model.default_map.set_sequencer(tlm2_seqr, reg2tlm2);
      	 model.default_map.set_auto_predict(1);

      end
      super.connect_phase(phase);
      result   = uvm_ml::connect(tlm2_drv.initiator_socket.get_full_name(), "top.TRANSACTOR.tsocket");

  endfunction : connect_phase
  
   virtual task run_phase(uvm_phase phase);
	   user_reg_seq1  regseq1;
		
		regseq1 = user_reg_seq1::type_id::create("regseq1");
      regseq1.model = model;
		
		model.print();
		phase.raise_objection(this);
      regseq1.start(null);
		#4000;
		phase.drop_objection(this);
	endtask
  
endclass : reg_test

endmodule
