`ifndef __AHB_MASTER_SEQS_SV__
`define __AHB_MASTER_SEQS_SV__

//typedef class ahb_master_base_seq;
// bunch of physical sequences

class ahb_master_1w_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_item #(ADDR_WIDTH, DATA_WIDTH) item_t;

  rand bit [ADDR_WIDTH-1:0] start_addr;
  rand bst_type_t           bst_type;
  rand trx_size_t           trx_size;
  bit blocking = TRUE;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_1w_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();
    item = item_t::type_id::create("item");
    `SMTDV_RAND_WITH(item,
      {
      item.mod_t == MASTER;
      item.trs_t == WR;
      item.run_t == FORCE;
      item.addr == start_addr;
      item.bst_type == bst_type;
      item.trx_size == trx_size;
      })

    `uvm_create(req)
    req.copy(item);
    start_item(req);
    finish_item(req);
    //if (blocking) get_response(rsp);
  endtask : body

endclass : ahb_master_1w_seq


class ahb_master_1r_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  rand bit [ADDR_WIDTH-1:0] start_addr;
  rand bst_type_t           bst_type;
  rand trx_size_t           trx_size;
  bit blocking = TRUE;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_1r_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();
    item = item_t::type_id::create("item");
    `SMTDV_RAND_WITH(item,
      {
      item.mod_t == MASTER;
      item.trs_t == RD;
      item.run_t == FORCE;
      item.addr == start_addr;
      item.bst_type == bst_type;
      item.trx_size == trx_size;
    })

    `uvm_create(req)
    req.copy(item);
    start_item(req);
    finish_item(req);
    //if (blocking) get_response(rsp);
  endtask : body

endclass : ahb_master_1r_seq


`endif // end of __AHB_MASTER_SEQS_SV__
