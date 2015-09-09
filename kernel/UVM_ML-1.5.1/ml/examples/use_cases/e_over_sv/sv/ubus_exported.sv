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

//package sn_ub_ser;


//////////////////////////////////////////////
// Serializer for class ubus_pkg::write_word_seq
//////////////////////////////////////////////

class ubus_pkg_write_word_seq_serializer extends uvm_ml::uvm_ml_class_serializer;

  function void deserialize(inout uvm_pkg::uvm_object obj);
    ubus_pkg::write_word_seq inst;
    int tmp_size; // used for deserialization of arrays
    $cast(inst,obj);
    inst.start_addr = unpack_field_int(16);
    inst.data0 = unpack_field_int(8);
    inst.data1 = unpack_field_int(8);
    inst.data2 = unpack_field_int(8);
    inst.data3 = unpack_field_int(8);
    inst.transmit_del = unpack_field_int(32);
  endfunction : deserialize

endclass : ubus_pkg_write_word_seq_serializer


// code for serializer registration
function int register_ubus_pkg_write_word_seq_serializer();
  ubus_pkg_write_word_seq_serializer inst;
  inst = new;
  return uvm_ml::register_class_serializer(inst,ubus_pkg::write_word_seq::get_type());
endfunction : register_ubus_pkg_write_word_seq_serializer
int dummy_ubus_pkg_write_word_seq_serializer = register_ubus_pkg_write_word_seq_serializer();


//////////////////////////////////////////////
// Serializer for class ubus_pkg::read_word_seq
//////////////////////////////////////////////

class ubus_pkg_read_word_seq_serializer extends uvm_ml::uvm_ml_class_serializer;

  function void deserialize(inout uvm_pkg::uvm_object obj);
    ubus_pkg::read_word_seq inst;
    int tmp_size; // used for deserialization of arrays
    $cast(inst,obj);
    inst.start_addr = unpack_field_int(16);
    inst.transmit_del = unpack_field_int(32);
  endfunction : deserialize

endclass : ubus_pkg_read_word_seq_serializer


// code for serializer registration
function int register_ubus_pkg_read_word_seq_serializer();
  ubus_pkg_read_word_seq_serializer inst;
  inst = new;
  return uvm_ml::register_class_serializer(inst,ubus_pkg::read_word_seq::get_type());
endfunction : register_ubus_pkg_read_word_seq_serializer
int dummy_ubus_pkg_read_word_seq_serializer = register_ubus_pkg_read_word_seq_serializer();


function int force_inst();
  return 1;
endfunction

//endpackage : sn_ub_ser

int dummy_force_inst_sn_ub_ser = force_inst();
