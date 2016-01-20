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

           
// xbus transaction translated to SV 
typedef enum bit[1:0] {NOP = 0, READ = 1, WRITE = 2} xbus_read_write_t;
typedef enum {GENERIC = 0, MONITOR = 1, MASTER = 2, SLAVE = 3} xbus_trans_kind_t;
typedef shortint unsigned xbus_addr_t;

class xbus_trans_s extends uvm_sequence_item;
  rand xbus_trans_kind_t kind;
  rand xbus_addr_t addr;
  rand bit[1:0]  size_ctrl;
  rand xbus_read_write_t read_write;
  rand int unsigned size;
  rand byte unsigned data[];
  rand bit [3:0] MASTER__wait_states[];
  rand int MASTER__error_pos_master;
  rand int unsigned MASTER__transmit_delay;
  `uvm_object_utils_begin(xbus_trans_s)
   `uvm_field_enum(xbus_trans_kind_t, kind, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON|UVM_DEC|UVM_UNSIGNED)
    `uvm_field_int(size_ctrl, UVM_ALL_ON|UVM_DEC|UVM_UNSIGNED)
    `uvm_field_enum(xbus_read_write_t, read_write, UVM_ALL_ON)
    `uvm_field_int(size, UVM_ALL_ON|UVM_DEC|UVM_UNSIGNED)
    `uvm_field_array_int(data, UVM_ALL_ON|UVM_DEC)
    `uvm_field_array_int(MASTER__wait_states, UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(MASTER__error_pos_master, UVM_ALL_ON|UVM_DEC)
    `uvm_field_int(MASTER__transmit_delay, UVM_ALL_ON|UVM_DEC|UVM_UNSIGNED)
  `uvm_object_utils_end
   constraint default_master_kind{kind == MASTER;}
   constraint default_data_size{data.size() == size;}
   constraint default_direction{read_write inside {READ,WRITE};}
   constraint default_size_ctrl{size==1 -> size_ctrl==0;
				size==2 -> size_ctrl==1;
				size==4 -> size_ctrl==2;
				size==8 -> size_ctrl==3;}
   constraint default_error_pos{MASTER__error_pos_master == -1;}		     
   constraint default_wait_size{MASTER__wait_states.size() == size;}
   constraint default_transmit_delay{MASTER__transmit_delay == 0;}

   function new(string name = "xbus_trans_s");
     super.new(name);
   endfunction

endclass : xbus_trans_s
                    


