/*******************************************************************************
  FILE : apb_slave_seq_lib.sv
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


`ifndef APB_SLAVE_SEQ_LIB_SV
`define APB_SLAVE_SEQ_LIB_SV

//------------------------------------------------------------------------------
// SEQUENCE: simple_response_seq
//------------------------------------------------------------------------------


class simple_response_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `APB_SLAVE_BASE_SEQ;

    // as eq  `uvm_declare_p_sequencer(`APB_SLAVE_SEQUENCER)
   `uvm_sequence_utils(`SIMPLE_RESPONSE_SEQ, `APB_SLAVE_SEQUENCER)

  function new(string name="simple_response_seq");
    super.new(name);
  endfunction

  `APB_ITEM req;
  `APB_ITEM util_item;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.mon_get_port.peek(util_item);
      if((util_item.trs_t == RD) &&
        (p_sequencer.cfg.check_address_range(util_item.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range Matching read.  Responding...", util_item.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.trs_t == RD; } )
      end
    end
  endtask

endclass

//------------------------------------------------------------------------------
// SEQUENCE: mem_response_seq
//------------------------------------------------------------------------------
class mem_response_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
     `APB_SLAVE_BASE_SEQ;

  rand bit [7:0] mem_data[$];

  `uvm_sequence_utils(`MEM_RESPONSE_SEQ, `APB_SLAVE_SEQUENCER)

  function new(string name="mem_response_seq");
    super.new(name);
  endfunction

  //simple assoc array to hold values
  bit [(DATA_WIDTH>>3)-1:0][7:0] slave_mem[int];
  bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];

  `APB_ITEM req;
  `APB_ITEM util_item;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      data_beat.delete();
      p_sequencer.mon_get_port.peek(util_item);
      if((util_item.trs_t == RD) &&
        (p_sequencer.parent.cfg.check_address_range(util_item.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range Matching APB_READ.  Responding...", util_item.addr), UVM_MEDIUM);
        if (slave_mem.exists(util_item.addr)) begin
          foreach(slave_mem[util_item.addr][i]) begin
            data_beat[0][i] = slave_mem[util_item.addr][i];
          end
          `uvm_do_with(req, { req.trs_t == RD;
                              req.addr == util_item.addr;
                              req.data_beat == data_beat; } )
        end
        else  begin
//          `uvm_do_with(req, { req.trs_t == RD;
//                              req.addr == util_item.addr;
//                              req.data_beat == mem_data; } )
        end
      end
      else begin
        if (p_sequencer.parent.cfg.check_address_range(util_item.addr) == 1) begin
        foreach(util_item.data_beat[i]) begin slave_mem[util_item.addr][i] = util_item.data_beat[i]; end
        // DUMMY response with same information
        `uvm_do_with(req, { req.trs_t == WR;
                            req.addr == util_item.addr;
                            req.data_beat == util_item.data_beat; } )
       end
      end
    end
  endtask

endclass

`endif // APB_SLAVE_SEQ_LIB_SV

