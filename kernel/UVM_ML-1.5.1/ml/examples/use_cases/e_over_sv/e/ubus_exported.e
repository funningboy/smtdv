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
type ubus_read_write_enum: [NOP = 0, READ = 1, WRITE = 2];

// exported sequence item from SV ubus
struct ubus_transfer like any_sequence_item {
  %addr : uint(bits:16);
  %read_write : ubus_read_write_enum;
  %size : uint;
  %data : list of byte;
  %wait_state : list of uint(bits:4);
  %error_pos : uint;
  %transmit_delay : uint;
  !%master : string;
  !%slave : string;
}; // end struct ubus_transfer

// Constrain UBUS sequence item (optional)
extend ubus_transfer {
    keep read_write in [READ, WRITE];
    keep data.size() == size;
    keep wait_state.size() < size;
    keep error_pos < size;
    keep transmit_delay < 10;
}; 


// empty base class used for ML transfer for the sequences
struct ubus_base_sequence like any_sequence_item { };


// exported sequences from SV ubus
struct write_word_seq like ubus_base_sequence {
  %start_addr : uint(bits:16);
  %data0 : byte;
  %data1 : byte;
  %data2 : byte;
  %data3 : byte;
  %transmit_del : uint;
}; // end struct write_word_seq

struct read_word_seq like ubus_base_sequence {
  %start_addr : uint(bits:16);
  %transmit_del : uint;
}; // end struct read_word_seq



'>
