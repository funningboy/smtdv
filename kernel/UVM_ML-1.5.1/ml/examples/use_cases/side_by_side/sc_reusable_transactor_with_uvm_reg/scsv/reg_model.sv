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

`ifndef REG_SLAVE
`define REG_SLAVE

typedef reg_block_slave;
typedef tlm2_sequencer;

class reg_max_pkt extends uvm_reg;
   uvm_reg_field MAXVALUE;

   function new(string name = "slave_ID");
      super.new(name,8,UVM_NO_COVERAGE);
   endfunction

   virtual function void build();
       this.MAXVALUE = uvm_reg_field::type_id::create("MAXVALUE");
      this.MAXVALUE.configure(this, 8,  0, "RO",   0, 8'h3F, 1, 0, 1);
   endfunction
   
   `uvm_object_utils(reg_max_pkt)  
endclass


class uvm_reg_tlm2_adapter extends uvm_reg_adapter;

  `uvm_object_utils(uvm_reg_tlm2_adapter)
  
   function new(string name = "uvm_reg_tlm2_adapter");
      super.new(name);
   endfunction 
	
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    uvm_reg_item cur_item;
    byte unsigned data[];
    uvm_tlm_generic_payload t = uvm_tlm_generic_payload::type_id::create("trans");
    t.set_command((rw.kind == UVM_READ)?UVM_TLM_READ_COMMAND:UVM_TLM_WRITE_COMMAND);
    t.set_data_length(rw.n_bits/8);
    t.set_address(rw.addr);
    for(int unsigned i = 0; i < rw.n_bits/8; i++) begin
      data = {data,  rw.data[(i*8)+7 -: 8]};
    end   
    t.set_data(data);
    return t;
  endfunction
  
  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    byte unsigned data[];
    uvm_tlm_generic_payload t = uvm_tlm_generic_payload::type_id::create("trans");
    if (!$cast(t,bus_item)) begin
      `uvm_fatal("NOT_UVM_TLM_GENERIC_PAYLOAD_TYPE","Provided bus_item is not of the correct type")
      return;
    end
    rw.kind = (t.get_command() == UVM_TLM_READ_COMMAND) ? UVM_READ : UVM_WRITE;
    rw.addr = t.get_address();
	 t.get_data(data);
    for(int unsigned i = 0; i < t.get_data_length(); i++) begin
      rw.data[i*8+7 -:8] = data[i];
    end   
    rw.status = UVM_IS_OK;
  endfunction

endclass : uvm_reg_tlm2_adapter


class reg_block_slave extends uvm_reg_block;

   reg_max_pkt     			MAX_PKT;
	
   function new(string name = "slave");
      super.new(name,UVM_NO_COVERAGE);
   endfunction

   virtual function void build();

      // create
      MAX_PKT              = reg_max_pkt::type_id::create("MAX_PKT");

      // configure
      MAX_PKT.configure(this,null,"MAX_PKT");
      MAX_PKT.build();

      // define default map
      default_map = create_map("default_map", 'h0, 4, UVM_LITTLE_ENDIAN);
      default_map.add_reg(MAX_PKT,    'h0,  "RW");
		
   endfunction
   
   `uvm_object_utils(reg_block_slave)
   
endclass : reg_block_slave
   

class user_reg_seq1 extends uvm_reg_sequence;

   function new(string name="user_reg_seq1");
      super.new(name);
   endfunction : new
   `uvm_object_utils(user_reg_seq1)
  `uvm_declare_p_sequencer(tlm2_sequencer)

   virtual task body();
      uvm_reg_data_t r_data;
      reg_block_slave mymodel;
      uvm_status_e status;
		$cast(mymodel, model);
      `uvm_info(get_type_name(), "Starting normal seq", UVM_LOW)
      #300;
      mymodel.MAX_PKT.write(status, 'h55);
      #40;
      mymodel.MAX_PKT.write(status, 'h66);
      mymodel.MAX_PKT.read(status, r_data);
      `uvm_info(get_type_name(), $sformatf(" Recieved data from reg : %x", r_data), UVM_LOW)
		
   endtask : body

endclass : user_reg_seq1


`endif
