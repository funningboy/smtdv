
`ifndef __APB_MASTER_BASE_SEQ_SV__
`define __APB_MASTER_BASE_SEQ_SV__

//typedef class apb_sequence_item;
//typedef class apb_master_cfg;
//typedef class apb_master_sequencer;

class apb_master_base_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_master_cfg),
      .SEQR(apb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_master_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_sequence_item#(ADDR_WIDTH ,DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_base_seq");
    super.new(name);
  endfunction : new

endclass : apb_master_base_seq

/*
* as background seq
*/
class apb_master_retry_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_retry_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_master_cfg),
      .SEQR(apb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_master_retry_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_retry_seq");
    super.new(name);
  endfunction : new

endclass : apb_master_retry_seq

/*
* as base background polling seq
*/
class apb_master_polling_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_master_cfg),
      .SEQR(apb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_master_polling_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  rand bit [ADDR_WIDTH-1:0] start_addr;
  rand bit [DATA_WIDTH-1:0] expect_data;
  rand int prio;

  constraint c_prio { prio inside {[-1:0]}; }

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_polling_seq");
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
      item.prio == prio;
      })

    `uvm_create(req)
    req.copy(item);
    start_item(req);
    finish_item(req);
    wait(item.unpack_data(0) == expect_data);
    //if (blocking) get_response(rsp);
  endtask : body

endclass : apb_master_polling_seq


class apb_master_stop_seqr_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_stop_seqr_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_master_cfg),
      .SEQR(apb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_stop_seqr_seq");
    super.new(name);
  endfunction : new

endclass : apb_master_stop_seqr_seq

`endif // __APB_MASTER_BASE_SEQ_SV__
