
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
    smtdv_master_polling_seq#(
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

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_polling_seq");
    super.new(name);
  endfunction : new

endclass : apb_master_polling_seq

`endif // __APB_MASTER_BASE_SEQ_SV__
