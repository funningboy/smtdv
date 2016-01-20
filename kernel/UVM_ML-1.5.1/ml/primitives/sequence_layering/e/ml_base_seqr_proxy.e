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
// Template defining a sequencer proxy for ML sequence layering
// BASE_SEQ is the type of the UVM-ML sequences 
template unit ml_base_seqr_proxy of (<BASE_SEQ'type>) like any_sequence_driver {
    event clock is only cycle @sys.any;
    // TLM port implementation providing the next item to caller
    send_item_imp : in interface_port of tlm_blocking_get of any_sequence_item is instance;
    keep bind(send_item_imp,external);
    // TLM port implementation receiving the response from last sent item
    get_response_imp : in interface_port of tlm_blocking_put of any_sequence_item is instance;
    keep bind(get_response_imp,external);
    //	 TLM port sending a sequence to be started at the target
    start_sequence_p : out interface_port of tlm_blocking_put of <BASE_SEQ'type> is instance;
    keep bind(start_sequence_p,external);
       
    // Send item to remote sequencer
    // Must be extended to return the proper type
    // Use get_next_item() to generate the next item
    // If items are never to be sent, use "wait @never"
    get(req : *any_sequence_item)@sys.any is undefined;
//     {
//        //req = get_next_item();
//        //wait @never;
//     };
       
    // Receive response from remote sequencer
    // Emits item_done to allow next item
    // Should be extended to cast the item to the actual type
    put(rsp : any_sequence_item) @sys.any is {
       emit item_done;
    };
       
    // Invoke remote sequence
    // s is the sequence to be started, must be derived from BASE_SEQ'type
    send_sequence(s : <BASE_SEQ'type>)@sys.any is {
       if(s != NULL) {
          start_sequence_p$.put(s);
       };
    };
       
    // Connect the TLM ports in the proxy sequencer to the corresponding target TLM interface
    connect_proxy(st : string) is {
       compute uvm_ml.connect_names(append(st,".send_item_p"), 
        append(me.e_path(), ".send_item_imp"));
       compute uvm_ml.connect_names(append(st,".get_response_p"), 
        append(me.e_path(), ".get_response_imp"));
       compute uvm_ml.connect_names(append(me.e_path(), ".start_sequence_p"),
        append(st, ".start_sequence_imp"));
    }; // connect_proxy
       
};
   

'>