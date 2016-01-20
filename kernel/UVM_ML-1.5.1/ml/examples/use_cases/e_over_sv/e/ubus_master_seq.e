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

<'
import sequence_layering/e/ml_base_seqr_proxy;

// ML sequence type
sequence ubus_master_sequence using 
  item = ubus_transfer,
  sequence_driver_type = ml_base_seqr_proxy of (ubus_base_sequence),
  created_driver = ubus_master_seqr_proxy
  ;

// Add ML specific code to the ubus master sequence  
extend ubus_master_sequence {
   //exported_seq : ubus_base_sequence;
   get_exported_seq() : ubus_base_sequence is {
      result = NULL;
   };
   body()@sys.any is only {
      driver.send_sequence(get_exported_seq());
   };
};


// Define wrappers for exported sequences
extend ubus_master_sequence_kind : [WRITE_WORD];
extend WRITE_WORD ubus_master_sequence {
   exported_seq : write_word_seq;
   get_exported_seq() : ubus_base_sequence is {
      result = exported_seq;
   };
};

extend ubus_master_sequence_kind : [READ_WORD];
extend READ_WORD ubus_master_sequence {
   exported_seq : read_word_seq;
   get_exported_seq() : ubus_base_sequence is {
      result = exported_seq;
   };
};



// Extend the sequencer proxy with application specific code as needed
// Update the original item with the response coming from ubus
extend ubus_master_seqr_proxy {
   current : any_sequence_item;
   get(req : *any_sequence_item)@sys.any is only {
      req = me.get_next_item();
      current = req; // save original item
   };
   // update the result data in the original item
   put(rsp : any_sequence_item) @sys.any is first {
      current.as_a(ubus_transfer).data = rsp.as_a(ubus_transfer).data; 
   };
};


'>