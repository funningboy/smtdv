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

typedef enum { SHORT_TRANSACTION = 0, LONG_TRANSACTION = 1 } trans_size;

// Definition of packet
class packet extends uvm_object;

  rand bit[7:0] data[];

  function new(string name = "packet");
      super.new(name);
  endfunction : new

  `uvm_object_utils_begin(packet)
    `uvm_field_array_int(data, UVM_ALL_ON|UVM_DEC)
  `uvm_object_utils_end

endclass : packet

class short_trans extends packet;
   `uvm_object_utils(short_trans)
   constraint small_size { (data.size() <= 10); }

   function new (string name = "short_trans");
      super.new(name);
      $display(">>>>>>>>>>> short_trans ");
      $display("TEST PASSED");      
   endfunction
endclass : short_trans
  
class long_trans extends packet;
   `uvm_object_utils(long_trans)
   constraint big_size { (data.size() > 10 && data.size() <= 100) ; }

   function new (string name = "long_trans");
      super.new(name);
      $display(">>>>>>>>>>> long_trans ");
   endfunction
endclass : long_trans
