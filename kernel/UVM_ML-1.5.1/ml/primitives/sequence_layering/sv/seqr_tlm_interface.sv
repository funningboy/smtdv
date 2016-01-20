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

// /////////////////////////////////////////////////////////////////
//
// Title: Sequencer TLM interface
//

// File: seqr_tlm_interface.sv
// Sequencer TLM interface template for sequence layering in UVM-ML

// Class: item_seq
// Empty sequence serves as parent to items received from the *proxy sequencer*.
class item_seq extends uvm_sequence;
  function new(string name="item_seq");
    super.new(name);
  endfunction
  `uvm_object_utils(item_seq)
endclass : item_seq


// Class: ml_seqr_tlm_if
// *Sequencer TLM interface* template.
// The actual interface is derived from this template. For example: 
// +-------------------------------------------------+
// |class ubus_master_seqr_tlm_if extends ml_seqr_tlm_if#(ubus_transfer,ubus_base_sequence);
// +-------------------------------------------------+
class ml_seqr_tlm_if #(type TR=uvm_sequence_item, type BASE_SEQ=uvm_sequence) extends uvm_component;
  // Variable: send_item_p
  // blocking TLM get port to get items from the *proxy sequencer*.
  uvm_blocking_get_port #(uvm_sequence_item) send_item_p;
  // Variable: get_response_p
  // blocking TLM put port to send response to the *proxy sequencer*.
  uvm_blocking_put_port #(uvm_sequence_item) get_response_p;
  // Variable: start_sequence_imp
  // blocking TLM put implementation to receive sequences from the *proxy sequencer*.
  uvm_blocking_put_imp  #(BASE_SEQ, ml_seqr_tlm_if#(TR,BASE_SEQ)) start_sequence_imp;
  // Variable: req
  // item received from *proxy sequencer*.
  uvm_pkg::uvm_sequence_item req; 
  // Variable: rsp
  // item response to be sent to *proxy sequencer*.
  uvm_pkg::uvm_sequence_item rsp = new();
  // Variable: seqr
  // pointer to the actual sequencer that executes the items and sequences.
  uvm_pkg::uvm_sequencer_base seqr;

  typedef ml_seqr_tlm_if #(TR,BASE_SEQ) seqr_tlm_if_type;
  `uvm_component_utils(seqr_tlm_if_type)

  // function: new
  // Constructor instantiates the TLM ports.
  function new(string name, uvm_component parent=null);
      super.new(name,parent);
      send_item_p        = new("send_item_p",this);
      get_response_p     = new("get_response_p",  this);
      start_sequence_imp = new("start_sequence_imp",this);
  endfunction

  // function: phase_ended
  // The UVM-ML ports are registered at the end of the build phase.
  function void phase_ended(uvm_phase phase);
      if (phase.get_name() == "build") begin
          uvm_ml::ml_tlm1 #(uvm_sequence_item)::register(send_item_p);
          uvm_ml::ml_tlm1 #(uvm_sequence_item)::register(get_response_p);
          uvm_ml::ml_tlm1 #(BASE_SEQ)::register(start_sequence_imp);
      end
  endfunction

  // function: set_fields
  // Hook method to control randomization of the item. 
  // For example:
// +-------------------------------------------------+
// |function uvm_sequence_item set_fields(uvm_sequence_item item);
// |   ubus_transfer tr;   
// |   if($cast(tr, item)) begin
// |	  tr.addr.rand_mode(0); // do not randomize
// |	  tr.size.rand_mode(0);
// |   end;
// |   return tr;      
// |endfunction : set_fields
// +-------------------------------------------------+
  virtual function uvm_sequence_item set_fields(uvm_sequence_item item);
      return null;
  endfunction : set_fields

  // function: set_seqr
  // Associate this *sequencer TLM interface* with the actual sequencer that will process the items and sequences.
  function set_seqr(uvm_sequencer_base sequencer);
      seqr = sequencer;
      return 0;
  endfunction : set_seqr

  // task: put
  // Start a sequence. Implements the TLM put interface.
  task put(uvm_sequence_base seq);
      seq.set_use_sequence_info(1);
      seq.set_parent_sequence(null);
      seq.set_sequencer(seqr);
      `uvm_info(get_type_name(),$sformatf("ML: Starting sequence \n%s",seq.sprint()), UVM_HIGH);
      seq.start(seqr); // returns when the sequence is completed
      //seq.wait_for_sequence_state(FINISHED);
  endtask : put

  // task: run_phase
  // The run phase of the *sequencer TLM interface*.
  // Execute items received from *proxy sequencer*.
  task run_phase(uvm_phase phase);
      item_seq s;      
      uvm_pkg::uvm_sequence_item processed;
      
      s = new("item_seq");
      while(1) begin
	 get_item(req); // pull mode - wait until upper layer has item
         `uvm_info(get_type_name(),$sformatf("ML: Got item from remote sequencer \n%s",
					     req.sprint()), UVM_HIGH);
	 processed = process_item(req); // process the item before executing it
	 seqr.wait_for_grant(s);
         `uvm_info(get_type_name(),$sformatf("ML: Sending request on local sequencer \n%s",
					     processed.sprint()), UVM_HIGH);
	 seqr.send_request(s,processed); 
	 seqr.wait_for_item_done(s,processed.get_transaction_id());
   	 update_response(s,req,rsp); // obtain response for upper layer
         `uvm_info(get_type_name(),$sformatf("ML: Updated response on remote sequencer \n%s",
					     rsp.sprint()), UVM_HIGH);
     end
  endtask : run_phase
    
  // task: get_item
  // Receive a sequence item from *proxy sequencer*.
  virtual task get_item(output uvm_sequence_item req);   
      send_item_p.get(req); // get item
      assert(req != null);
  endtask : get_item

  // task: update_response
  // Update the response and send to the *proxy sequencer*. 
  // For example:
// +-------------------------------------------------+
// |task update_response(item_seq s, uvm_sequence_item req, uvm_sequence_item response);
// |   TR ireq; 
// |   if(!$cast(ireq, req)) `uvm_fatal("get_response","Cannot cast response");
// |   if(ireq.read_write == READ) begin	    
// |      s.get_response(response);
// |      rsp = response;
// |      get_response_p.put(rsp); // send read response
// |   end else   
// |      get_response_p.put(req); // send write response   
// |endtask : update_response        
// +-------------------------------------------------+
  virtual task update_response(item_seq s, uvm_sequence_item req, uvm_sequence_item response);  
      TR ireq;      
      if(!$cast(ireq, req)) `uvm_fatal("get_response","Cannot cast response");
      get_response_p.put(req); // send item_done response
  endtask : update_response

  // function: process_item
  // Process the item received from the *proxy sequencer*.
  function uvm_sequence_item process_item(uvm_sequence_item req);
      TR item;
      TR result;
      
      if(!$cast(item,req)) `uvm_fatal("process_item","Cannot cast received item");
      // Randomize the item to verify it is valid according to the constraints
      if(!$cast(result,set_fields(item))) `uvm_fatal("process_item","Cannot cast item"); // user hook to control randomization
      if(!result.randomize()) `uvm_fatal("process_item","Cannot randomize item");
      return result;
  endfunction : process_item

endclass : ml_seqr_tlm_if
