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

// Definition of packet for TLM1 transactions
class cppi_pkt_data extends uvm_object;

    rand int unsigned val;
    reg [7:0] pkt_data[$];

    `uvm_object_utils_begin(cppi_pkt_data)
        `uvm_field_int(val, UVM_DEFAULT)
        `uvm_field_queue_int(pkt_data, UVM_DEFAULT)
    `uvm_object_utils_end
      
    function new(string name = "");
        super.new(name);
    endfunction

endclass


class  packet extends uvm_sequence_item;
  cppi_pkt_data	combined[$];

  `uvm_object_utils_begin(packet)
    `uvm_field_queue_object(combined,    UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "packet");
    super.new(name);
  endfunction : new
endclass : packet

class psi_word #(parameter WIDTH=128) extends packet;
   localparam BWIDTH = WIDTH / 8;
   reg [WIDTH-1:0] data;

  `uvm_object_utils_begin(psi_word)
    `uvm_field_int(data, UVM_DEFAULT)
  `uvm_object_utils_end
    
  function new (string name = "psi_word");
    super.new(name);
  endfunction : new
endclass : psi_word
