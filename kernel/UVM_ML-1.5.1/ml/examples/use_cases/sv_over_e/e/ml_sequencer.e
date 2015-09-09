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
import sequence_layering/e/seqr_tlm_interface;
import seq_lib;

uvm_ml_type_match "e:cdn_xbus::MASTER xbus_trans_s" "sv:xbus_trans_s";

// Only items and sequences from SV
extend MAIN xbus_master_sequence {
  keep count == 0;
};

// Extend xbus master sequencer by adding the TLM interface
extend xbus_master_driver_u {
   tlm_if: ml_seqr_tlm_if of (MASTER xbus_trans_s,ML_MASTER_SERVICE_SEQ xbus_master_sequence) is instance;
     keep tlm_if.sequencer == me;
}; // extend xbus_master_driver_u


// Implement the virtual methods of the TLM interface
extend ml_seqr_tlm_if of (MASTER xbus_trans_s,ML_MASTER_SERVICE_SEQ xbus_master_sequence) {
   // Keep the original item in case it is needed to be updated
   !save_item : MASTER xbus_trans_s;
   
   // create valid xbus item from the SV parameters
   process_item(p : any_sequence_item) : MASTER xbus_trans_s is {
      var inp := p.as_a(MASTER xbus_trans_s); 
      gen save_item keeping {
         .driver           == sequencer;
         .addr             == inp.addr; 
         .data             == {inp.data}; 
         .size             == inp.size; 
         .read_write       == inp.read_write;
         .size_ctrl        == inp.size_ctrl; 
         .wait_states      == {inp.wait_states};
         .error_pos_master == inp.error_pos_master;
         .transmit_delay   == inp.transmit_delay;
      }; // gen save_item
      return save_item;
   }; // process_item
   
   // Example code how to update the original item 
   // to propagate the data back to initiator
   restore_item() : MASTER xbus_trans_s is {
      result = save_item;
   }; // restore_item
}; // extend ml_seqr_tlm_if

'>

