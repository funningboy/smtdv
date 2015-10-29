/*******************************************************************************
  FILE : apb_master_seq_lib.sv
*******************************************************************************/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
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


`ifndef APB_MASTER_SEQ_LIB_SV
`define APB_MASTER_SEQ_LIB_SV

//-------------------------------------
// uvm_ref flow define sequences
//-------------------------------------
class read_byte_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
   `APB_MASTER_BASE_SEQ;

  rand bit[ADDR_WIDTH-1:0] start_addr;

  `uvm_sequence_utils(`READ_BYTE_SEQ, `APB_MASTER_SEQUENCER)

    function new(string name = "read_byte_seq");
      super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      `uvm_do_with(req,
        { req.addr == start_addr;
          req.trs_t == RD;
        })
     get_response(rsp);
      `uvm_info(get_type_name(), {$psprintf("\n%s", rsp.sprint())}, UVM_LOW)
    endtask
endclass


class write_byte_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_MASTER_BASE_SEQ;

  rand bit [ADDR_WIDTH-1:0] start_addr;
  rand bit [7:0] data[(DATA_WIDTH>>3)];

  `uvm_sequence_utils(`WRITE_BYTE_SEQ, `APB_MASTER_SEQUENCER)

  function new(string name = "write_byte_seq");
      super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      `uvm_do_with(req,
        { req.addr == start_addr;
          req.trs_t == WR;
          req.data == data;
        })
     get_response(rsp);
      `uvm_info(get_type_name(), {$psprintf("\n%s", rsp.sprint())}, UVM_LOW)
    endtask

endclass


//------------------------------------------------------------------------------
// SEQUENCE: read_word_seq
//------------------------------------------------------------------------------
class read_word_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_MASTER_BASE_SEQ;

  rand bit [ADDR_WIDTH-1:0] start_addr;

  constraint addr_ct {(start_addr[1:0] == 0); }

  `uvm_sequence_utils(`READ_WORD_SEQ, `APB_MASTER_SEQUENCER)

  function new(string name="read_word_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
    `uvm_do_with(req,
      { req.addr == start_addr;
        req.trs_t == RD;
      } )
    get_response(rsp);
      `uvm_info(get_type_name(), {$psprintf("\n%s", rsp.sprint())}, UVM_LOW)
    endtask

endclass

// SEQUENCE: write_word_seq
class write_word_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_MASTER_BASE_SEQ;

  rand bit [ADDR_WIDTH-1:0] start_addr;
  rand bit [7:0] data[(DATA_WIDTH>>3)];

  constraint addr_ct {(start_addr[1:0] == 0); }

  `uvm_sequence_utils(`WRITE_WORD_SEQ, `APB_MASTER_SEQUENCER)

  function new(string name="write_word_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
    `uvm_do_with(req,
      { req.addr == start_addr;
        req.trs_t == WR;
        req.data == data;
      } )
    get_response(rsp);
      `uvm_info(get_type_name(), {$psprintf("\n%s", rsp.sprint())}, UVM_LOW)
    endtask

endclass

// SEQUENCE: read_after_write_seq
class read_after_write_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_MASTER_BASE_SEQ;

  rand bit [ADDR_WIDTH-1:0] start_addr;
  rand bit [7:0] data[(DATA_WIDTH>>3)];

  constraint addr_ct {(start_addr[1:0] == 0); }

  `uvm_sequence_utils(`READ_AFTER_WRITE_SEQ, `APB_MASTER_SEQUENCER)

  function new(string name="read_after_write_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
    `uvm_do_with(req,
      { req.addr == start_addr;
        req.trs_t == WR;
        req.data == data;
      } )
    `uvm_do_with(req,
      { req.addr == start_addr;
        req.trs_t == RD;
      } )
    endtask

endclass

// SEQUENCE: multiple_read_after_write_seq
class multiple_read_after_write_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_MASTER_BASE_SEQ;

   `READ_AFTER_WRITE_SEQ raw_seq;
   `WRITE_BYTE_SEQ w_seq;
   `READ_BYTE_SEQ r_seq;
   rand int unsigned num_of_seq;

    constraint num_of_seq_c { num_of_seq <= 10; num_of_seq >= 5; }

  `uvm_sequence_utils(`MULTIPLE_READ_AFTER_WRITE_SEQ, `APB_MASTER_SEQUENCER)

    function new(string name="multiple_read_after_write_seq");
      super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
      for (int i = 0; i < num_of_seq; i++) begin
        `uvm_info(get_type_name(), $psprintf("Executing sequence # %0d", i),
                  UVM_HIGH)
        `uvm_do(raw_seq)
      end
      repeat (3) `uvm_do(w_seq)
      repeat (3) `uvm_do(r_seq)
    endtask

endclass


`endif // APB_MASTER_SEQ_LIB_SV

