
`ifndef __APB_ITEM_SV__
`define __APB_ITEM_SV__

/**
* apb item
* a basic apb item
*
* @class apb_item
*
*/
class apb_item #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_sequence_item #(
      ADDR_WIDTH,
      DATA_WIDTH
    );

  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  rand bit [15:0]           sel;
  rand trx_rsp_t	          rsp;

  rand bit [(DATA_WIDTH>>3)-1:0][7:0] rdata;

  rand int psel_L2H;
  rand int penable_L2H;
  rand int pready_L2H;

  constraint c_rsp_value { rsp == OK; }

// only work for dynamic array init, that's doesn't work for static queue
//  constraint c_data_size { data_beat.size() == 1; }
//  constraint c_addr_size { addrs.size() == 1; }

  // used only two slaves
  constraint c_sel_size { sel inside {[0:1]}; }

  constraint c_psel_L2H { psel_L2H inside {[0:10]}; }
  constraint c_penable_L2H { penable_L2H inside {[0:10]}; }
  constraint c_pready_L2H { pready_L2H inside {[0:10]}; }

  `uvm_object_param_utils_begin(item_t)
    `uvm_field_enum(trx_rsp_t, rsp, UVM_ALL_ON)
    `ifdef APB_DEBUG
      `uvm_field_int(psel_L2H, UVM_DEFAULT)
      `uvm_field_int(penable_L2H, UVM_DEFAULT)
      `uvm_field_int(pready_L2H, UVM_DEFAULT)
    `endif
  `uvm_object_utils_end

  function new (string name = "apb_item");
    super.new(name);
  endfunction

  function void post_randomize();
    bit [ADDR_WIDTH-1:0] addrs[$];
    bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];

    super.post_randomize();
    this.data_beat.delete();
    this.addrs.delete();

    this.addrs.push_back(addr);

    `SMTDV_RAND_VAR(rdata);
    this.data_beat.push_back(rdata);

  endfunction : post_randomize

endclass : apb_item

`endif // end of __APB_ITEM_SV__

