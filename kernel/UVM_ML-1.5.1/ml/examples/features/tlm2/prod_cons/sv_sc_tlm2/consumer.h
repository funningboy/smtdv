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
#define PAYLOAD_TYPE tlm_generic_payload

class consumer : public uvm_component 
	       , tlm::tlm_fw_transport_if< tlm::tlm_base_protocol_types>
{
public:
  tlm::tlm_target_socket <32, tlm::tlm_base_protocol_types> b_tsocket;
  tlm::tlm_target_socket <32, tlm::tlm_base_protocol_types> nb_tsocket;
  int ind1, ind2;
  unsigned char* data;

  consumer(sc_module_name nm) : uvm_component(nm)
    , b_tsocket("b_tsocket")
    , nb_tsocket("nb_tsocket")
 { 
    b_tsocket(*this);
    nb_tsocket(*this);
  }

  UVM_COMPONENT_UTILS(consumer)

  void build() {
    cout << "SC consumer::build" << endl;
  }

  // b_transport method for the TLM2 transactions
  void b_transport(PAYLOAD_TYPE& tx, sc_time& dt) {    
    static char save_data[100];   
    tx.set_response_status(TLM_OK_RESPONSE);
    if(tx.get_command() == TLM_WRITE_COMMAND) {
      cout << "[" <<  sc_time_stamp() << "] SC consumer::b_transport WRITE ";
      for(unsigned int i = 0; i < tx.get_data_length(); i++) 
	save_data[i] = *(tx.get_data_ptr()+i);
    } else {
      cout << "[" <<  sc_time_stamp() << "] SC consumer::b_transport READ ";
      for(unsigned int i = 0; i < tx.get_data_length(); i++) 
	*(tx.get_data_ptr()+i) = save_data[i];
    };
    print_gp(tx);
    wait(5, SC_NS);
  }

  // nb_transport method for the TLM2 transactions
  tlm::tlm_sync_enum nb_transport_fw(PAYLOAD_TYPE& trans,tlm::tlm_phase& phase, sc_time& delay ) {
    static char save_data[100];   
    trans.acquire();  
    trans.set_response_status(TLM_OK_RESPONSE);
    if(trans.get_command() == TLM_WRITE_COMMAND) {
      cout << "[" <<  sc_time_stamp() << "] SC consumer::nb_transport WRITE ";
      for(unsigned int i = 0; i < trans.get_data_length(); i++) 
	save_data[i] = *(trans.get_data_ptr()+i);
    } else {
      cout << "[" <<  sc_time_stamp() << "] SC consumer::nb_transport READ ";
      for(unsigned int i = 0; i < trans.get_data_length(); i++) 
	*(trans.get_data_ptr()+i) = save_data[i];
    };
    print_gp(trans);
    trans.release();
    return tlm::TLM_COMPLETED;
  }

  // must be implemented for TLM2 - but not important for ML stuff
  virtual bool get_direct_mem_ptr(PAYLOAD_TYPE& trans, tlm::tlm_dmi& dmi_data) {
    return false; 
  }

  virtual unsigned int transport_dbg(PAYLOAD_TYPE& trans) { 
    return 0; 
  }

  // print content of generic payload
  void print_gp(PAYLOAD_TYPE& gp){
    unsigned char * data;
    
    data = gp.get_data_ptr();
    cout<<hex<<" address = " << dec << gp.get_address();
    cout << " data_length = "<<gp.get_data_length() << hex << " m_data = ";
    
    for (int i = 0; i<(int)gp.get_data_length(); i++){
      cout << (int)(*data++);
      cout<< " ";
    };
    cout << " status= " << gp.get_response_status() << endl;
  }

};
