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


// /////////////////////////////////////////////////////////////////
//
// Title: Proxy sequencer
//

// File: sequencer_proxy.sv
// Proxy sequencer base class for sequence layering in UVM-ML

typedef class ml_sequencer_proxy; // forward definition


// Class: ml_seq
// Base class for ML sequences.
// Every sequence in the target framework that is initiated from this framework must be exported as a derived type from ml_seq. 
// For example:
// +-------------------------------------------------+
// |class WRITE_TRANSFER extends ml_seq;
// |   rand bit[15:0] base_addr;
// |   rand int unsigned size;
// |   rand bit[63:0] data;
// |
// |  `uvm_object_utils_begin(WRITE_TRANSFER)
// |    `uvm_field_int(base_addr, UVM_ALL_ON)
// |    `uvm_field_int(size, UVM_ALL_ON)
// |    `uvm_field_int(data, UVM_ALL_ON)
// |  `uvm_object_utils_end
// |  `uvm_declare_p_sequencer(ml_sequencer_proxy)
// |
// |  function new(string name="WRITE_TRANSFER");
// |      super.new(name);
// |  endfunction
// |
// |endclass : WRITE_TRANSFER
// +-------------------------------------------------+
class ml_seq extends uvm_sequence;
  string kind;

  `uvm_object_utils_begin(ml_seq)
    `uvm_field_string(kind, UVM_ALL_ON)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(ml_sequencer_proxy)

  function new(string name="ml_seq");
      super.new(name);
      kind = name;
  endfunction

  virtual task body();
      p_sequencer.start_sequence(this);
  endtask : body

  virtual function update(ml_seq resp);
      this.copy(resp);
  endfunction : update

endclass : ml_seq

// not used
class ml_sequence_id extends uvm_object;
  int id;
  `uvm_object_utils_begin(ml_sequence_id)
    `uvm_field_int(id, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "ml_sequence_id");
    super.new(name);
  endfunction
endclass : ml_sequence_id


// Class: ml_sequencer_proxy
// Base class for UVM-ML *sequencer proxy*. Instantiates the TLM ports and connects them to the target *sequencer TLM interface*.
// Once connected to the target sequencer, one can send sequence items and start sequences on the target sequencer. For example: 
// +-------------------------------------------------+
// |`uvm_do_with(xb_item, {addr == 'h1000;
// |		 read_write == WRITE;
// |		 size == 8;
// |		 })
// |`uvm_do_with (wt_seq, {base_addr == target_addr;
// |			   size == 4;})
// +-------------------------------------------------+
class ml_sequencer_proxy extends uvm_sequencer;
  // Variable: send_item_p
  // non-blocking TLM put port to send items to the *sequencer TLM interface*.
  uvm_nonblocking_put_port #(uvm_sequence_item) send_item_p;
  // Variable: get_response_p
  // blocking TLM get port to receive item response the *sequencer TLM interface*.
  uvm_blocking_get_port    #(uvm_sequence_item) get_response_p;
  // Variable: start_sequence_p
  // blocking TLM put port to send sequences to the *sequencer TLM interface*.
  uvm_blocking_put_port    #(ml_seq) start_sequence_p;
  // Variable: start_seq_p
  // blocking TLM transport to send items to the *sequencer TLM interface*.
  uvm_blocking_transport_port #(ml_seq,ml_seq) start_seq_p;
  // Variable: save_item
  // save the last item.
  uvm_sequence_item save_item;
  // Variable: use_transport
  // use bi-directional interface to receive sequence result.
  int use_transport; //need the response from remote sequencer

  `uvm_component_utils(ml_sequencer_proxy)

  // function: new
  // Constructor instantiates the TLM ports.
  function new(string name="ml_sequencer_proxy", uvm_component parent=null);
      super.new(name,parent);
      send_item_p          = new("send_item_p" ,this);
      get_response_p       = new("get_response_p" ,this);
      start_sequence_p     = new("start_sequence_p" ,this);
      start_seq_p          = new("start_seq_p" ,this);
      use_transport = 1; // default return response from remote sequencer
  endfunction

  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
  endfunction 
   
  // function: phase_ended
  // The UVM-ML ports are registered at the end of the build phase.
  function void phase_ended(uvm_phase phase);
      if (phase.get_name() == "build") begin
	 uvm_ml::ml_tlm1 #(uvm_sequence_item)::register(send_item_p);
	 uvm_ml::ml_tlm1 #(uvm_sequence_item)::register(get_response_p);
	 uvm_ml::ml_tlm1 #(ml_seq)::register(start_sequence_p);
	 uvm_ml::ml_tlm1 #(ml_seq)::register(start_seq_p);
      end
  endfunction

  // function: connect_proxy
  // Connect the TLM ports to the target *sequencer TLM interface*.
  function void connect_proxy(string target);
      if(!uvm_ml::connect(send_item_p.get_full_name(), 
	                  {target, "send_item_imp"})) begin
	 `uvm_fatal("MLCONN", "uvm_ml connect failed");
      end;
      if(!uvm_ml::connect(get_response_p.get_full_name(), 
	                  {target, "get_response_imp"})) begin
	 `uvm_fatal("MLCONN", "uvm_ml connect failed");
      end;
      if(!uvm_ml::connect(start_sequence_p.get_full_name(), 
	                  {target, "start_sequence_imp"})) begin
	 `uvm_fatal("MLCONN", "uvm_ml connect failed");
      end;
      if(!uvm_ml::connect(start_seq_p.get_full_name(), 
	                  {target, "start_seq_imp"})) begin
	 `uvm_fatal("MLCONN", "uvm_ml connect failed");
      end;
  endfunction : connect_proxy

   // wait for grant (not implemented)
   virtual task wait_for_grant(uvm_sequence_base sequence_ptr, 
			       int item_priority = -1, bit lock_request = 0);
   endtask : wait_for_grant

   // function: send_request
   // Send an item to the target TLM interface.
   virtual function void send_request(uvm_sequence_base sequence_ptr, 
                                      uvm_sequence_item t, bit rerandomize = 0);
      bit b;
      b = send_item_p.try_put(t);
   endfunction : send_request

   // function: update_done_item
   // Update the item from last collected response.
   virtual function update_done_item(output uvm_sequence_item item);
      item = save_item;
   endfunction : update_done_item

   // function: wait_for_item_done
   // Wait for item done called by the sequencer after send_request.
   virtual task wait_for_item_done(uvm_sequence_base sequence_ptr, int transaction_id);
      uvm_sequence_item t;      
      t = new();
      get_response_p.get(t);
      save_item = t;            
   endtask : wait_for_item_done

   // function: set_seqr_resp_off
   // Use TLM put instead of transport to improve performance.
   // Use when no response is expected from sequence.
   function set_seqr_resp_off();
      use_transport = 0;
   endfunction : set_seqr_resp_off
   
   // function: set_seqr_resp_on
   // Use TLM transport instead of put.
   // Use when response is expected from sequence.
   function set_seqr_resp_on();
      use_transport = 1;
   endfunction : set_seqr_resp_on
   
   // task: start_sequence
   // Start a sequence in the target sequencer.
   virtual task start_sequence(uvm_sequence_base e_seq);
      ml_seq my_seq;
      ml_seq resp;
      
      if($cast(my_seq, e_seq) == 1) begin
	 if(use_transport == 1) begin
	    start_seq_p.transport(my_seq,resp);
	    void'(my_seq.update(resp));
	 end else
	    start_sequence_p.put(my_seq);
      end else 
	`uvm_info(get_type_name(), "error in start_sequence", UVM_LOW);
   endtask : start_sequence

endclass : ml_sequencer_proxy

