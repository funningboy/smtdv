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
//   Unless required by applicable
// law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

// Exported sequences from xbus

// Sequence representing WRITE_TRANSFER xbus_master_sequence in e
class WRITE_TRANSFER extends ml_seq;
   rand bit[15:0] base_addr;
   rand int unsigned size;
   rand bit[63:0] data;
   
   
  `uvm_object_utils_begin(WRITE_TRANSFER)
    `uvm_field_int(base_addr, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(ml_sequencer_proxy)

   constraint  data_c {
     data == 64'h1111 ;
   };
   
   
  function new(string name="WRITE_TRANSFER");
      super.new(name);
  endfunction

endclass : WRITE_TRANSFER

// Sequence representing READ_TRANSFER xbus_master_sequence in e
class READ_TRANSFER extends ml_seq;
   rand bit[15:0] base_addr;
   rand int unsigned size;
   rand bit[63:0] data;

  `uvm_object_utils_begin(READ_TRANSFER)
    `uvm_field_int(base_addr, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(ml_sequencer_proxy)

  function new(string name="READ_TRANSFER");
      super.new(name);
  endfunction

endclass : READ_TRANSFER

//////////////////////////////////////
  
// Example XBUS sequence doing items and sequences in e
class xbus_seq extends uvm_sequence;
  xbus_trans_s      xb_item;   // xbus sequence item
  WRITE_TRANSFER    wt_seq;    // xbus WRITE_TRANSFER sequence
  READ_TRANSFER     rt_seq;    // xbus READ_TRANSFER sequence
  uvm_sequence_item resp_item; // xbus response
  int               target_addr;

  `uvm_object_utils(xbus_seq)
  `uvm_declare_p_sequencer(ml_sequencer_proxy)

  function new(string name="xbus_seq");
      super.new(name);
  endfunction

  virtual task body();
      
      `uvm_info(get_type_name(), $sformatf("Starting ML sequence on %s",get_name()), UVM_LOW);

      // Write 8 random bytes
//      `uvm_do_with(xb_item, {addr == 'h1000;
     //			     size == 8;
     `uvm_do_with(xb_item,{read_write == WRITE;
			   size == 8;
			   })
     
      // Write 4 bytes
      target_addr = $urandom() & 'hffff;
      `uvm_do_with(xb_item, {addr == target_addr;
			     read_write == WRITE;
			     size == 4;
			     foreach (data[i]) {i==0 -> data[i]=='hde;
			     			i==1 -> data[i]=='had;
			     			i==2 -> data[i]=='hbe;
			     			i==3 -> data[i]=='hef;}
			     })
      
     
      // Read back 4 bytes
      `uvm_do_with(xb_item, {addr == target_addr;
			     read_write == READ;
			     size == 4;
			     })
      
      void'(p_sequencer.update_done_item(resp_item));
      $cast(xb_item,resp_item);
      `uvm_info(get_type_name(),$sformatf("%s - read %x %x %x %x", get_name(), 
					  xb_item.data[0],
					  xb_item.data[1],
					  xb_item.data[2],
					  xb_item.data[3]),
		UVM_LOW);

      // Invoke exported sequences
      target_addr = $urandom() & 'hffff;
      `uvm_do_with (wt_seq, {base_addr == target_addr;
			     size == 4;})
      `uvm_info(get_type_name(),$sformatf("%s - wrote %x",get_name(), wt_seq.data),UVM_LOW);
      
      `uvm_do_with (rt_seq, {base_addr == target_addr;
			     size == 4;})
      `uvm_info(get_type_name(),$sformatf("%s - read %x", get_name() ,rt_seq.data),UVM_LOW);
      
      #100ns; // drain time
      `uvm_info(get_type_name(), $sformatf("Done ML sequence from %s",get_name()), UVM_LOW);
//      `uvm_info(get_type_name(),"** UVM TEST PASSED **",UVM_LOW)
  endtask // body
  
endclass : xbus_seq

