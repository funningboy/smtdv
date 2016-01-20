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

class consumer extends uvm_component;

    uvm_tlm_nb_target_socket #(consumer) nb_target_socket;
    uvm_tlm_b_target_socket  #(consumer) b_target_socket;

    byte unsigned save_gp[];
    int save_length;

   `uvm_component_utils(consumer)   
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
      `uvm_info(get_type_name(),"SV consumer::new",UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV consumer::build",UVM_LOW);
      nb_target_socket = new("nb_target_socket", this, this);
      b_target_socket  = new("b_target_socket",  this, this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(),"SV consumer::connect",UVM_LOW);
    endfunction


    //TLM2 functions implementation
    function uvm_tlm_sync_e nb_transport_fw(uvm_tlm_generic_payload t,
                                            ref uvm_tlm_phase_e p,
					    input uvm_tlm_time delay);
      uvm_tlm_sync_e res;
      t.set_response_status(UVM_TLM_OK_RESPONSE);
      `uvm_info(get_type_name(),$sformatf("SV consumer received %s", t.convert2string()),UVM_LOW);
      if(t.is_write) begin
	 t.get_data(save_gp);
	 save_length = t.get_data_length();
      end
      if(t.is_read) begin
	 t.set_data_length(save_length);
	 t.set_data(save_gp);
      end
      t.set_response_status(UVM_TLM_OK_RESPONSE);
      return UVM_TLM_COMPLETED;
    endfunction

    task b_transport(uvm_tlm_generic_payload t, uvm_tlm_time delay);
      #10ns; // simulate DUT delay
      t.set_response_status(UVM_TLM_OK_RESPONSE);
      `uvm_info(get_type_name(),$sformatf("SV consumer received %s", t.convert2string()),UVM_LOW);
      if(t.is_write) begin
	 t.get_data(save_gp);
	 save_length = t.get_data_length();
      end
      if(t.is_read) begin
	 t.set_data_length(save_length);
	 t.set_data(save_gp);
      end     
    endtask


endclass
