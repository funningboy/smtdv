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

<'

// base type for exported sequences
struct ml_seq {
   % kind : string;
};

// Sequencer TLM interface
// To be instantiated in a sequencer and driven through TLM from a
// proxy sequencer in another framework
// ACTUAL_SEQ is the base type for UVM-ML sequences
// ACTUAL_SEQITEM is the type of the actual sequence item
template unit ml_seqr_tlm_if of (<ACTUAL_SEQITEM'type>,<ACTUAL_SEQ'type>) {
   // Pointer to the sequencer executing the requested items and sequences
   sequencer: any_sequence_driver;
   // Service sequence acting as the parent for requested items
   ml_service_seq: <ACTUAL_SEQ'type>;
     keep ml_service_seq.driver == sequencer;

   //TLM port implementing the execution of received item
   send_item_imp : in interface_port of tlm_nonblocking_put of any_sequence_item 
     using suffix=_send_item is instance;
      keep bind(send_item_imp,external);
   // TLM port implementing the request for returning the result of the item
   get_response_imp : in interface_port of tlm_blocking_get of any_sequence_item 
     using suffix=_response is instance;
      keep bind(get_response_imp,external);
   // TLM port implementing the execution of received sequence, no response expected
   start_sequence_imp : in interface_port of tlm_blocking_put of ml_seq 
     using suffix=_start_sequence is instance;
      keep bind(start_sequence_imp,external);
   // TLM port implementing the execution of received sequence expecting a response
   start_seq_imp : in interface_port of tlm_blocking_transport of (ml_seq,ml_seq)
     using suffix=_start_seq is instance;
      keep bind(start_seq_imp,external);     

   // Virtual method - must be implemented
   // Process the received data to create a valid sequence item
   // Copy the valus you want to be controlled externally
   // Use gen to apply the necessary constraints
   process_item(p : any_sequence_item) : <ACTUAL_SEQITEM'type> is empty;
   // Virtual method - must be implemented
   // Use the original item received
   // Update the modified values from the resulting item
   restore_item() : <ACTUAL_SEQITEM'type> is empty;
    
   // Execute the requested sequence
   // Sequence must be derived from ml_seq
   do_ml_sequence(p : ml_seq) @sequencer.clock is {
      ml_service_seq.do_user_seq(p);
   };

   // Wait for item done
   get_response(p : *any_sequence_item) @sys.any is {
      var res : <ACTUAL_SEQITEM'type>;
      wait @sequencer.item_done;
      res = restore_item();
      message(LOW,"sequence item done ");
      p = res;
   }; // get_response
   
   // Execute the requested item 
   try_put_send_item(p : any_sequence_item) : bool is {
      start sequencer.execute_item(process_item(p));
      return TRUE;
   }; // try_put_send_item
   
   // required method, not used
   can_put_send_item() : bool is { };

   // required method, not used
   ok_to_put_send_item() : tlm_event is { }; 
   
   // Start the requested sequence; no response expected
   // Sequence must be derived from ml_seq
   put_start_sequence(p : ml_seq) @ sys.any  is {
      do_ml_sequence(p);
   };
   
   // Start the requested sequence; response expected
   // Sequence must be derived from ml_seq
   transport_start_seq(req: ml_seq, resp: *ml_seq)@sys.any is {
      do_ml_sequence(req);
      resp = req;   // update the response value
   };
};

'>

