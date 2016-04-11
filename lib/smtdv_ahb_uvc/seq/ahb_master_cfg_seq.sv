
`ifndef __AHB_MASTER_CFG_SEQ_SV__
`define __AHB_MASTER_CFG_SEQ_SV__

//typedef class ahb_sequence_item;
//typedef class ahb_master_cfg;
//typedef class ahb_master_sequencer;

class ahb_master_cfg_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_master_cfg_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  bit [ADDR_WIDTH-1:0] start_addr;
  bit [DATA_WIDTH-1:0] write_data;
  bst_type_t           bst_type;
  trx_size_t           trx_size;
  bit blocking = TRUE;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_cfg_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    super.body();
    item = item_t::type_id::create("item");
    `SMTDV_RAND_WITH(item,
      {
      mod_t == MASTER;
      trs_t == WR;
      run_t == FORCE;
      addr == start_addr;
      bst_type ==  bst_type;
      trx_size == trx_size;
    })
    item.pack_data(0, write_data);

    `uvm_create(req)
    req.copy(item);
    start_item(req);
    finish_item(req);
    //if (blocking) get_response(rsp);
  endtask : body

endclass : ahb_master_cfg_seq

`endif // __AHB_MASTER_CFG_SEQ_SV__
