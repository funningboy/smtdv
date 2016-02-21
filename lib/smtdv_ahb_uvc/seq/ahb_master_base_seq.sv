
`ifndef __AHB_MASTER_BASE_SEQ_SV__
`define __AHB_MASTER_BASE_SEQ_SV__

//typedef class ahb_sequence_item;
//typedef class ahb_master_cfg;
//typedef class ahb_master_sequencer;

class ahb_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_master_cfg),
      .SEQR(ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef ahb_master_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_base_seq");
    super.new(name);
  endfunction : new

endclass : ahb_master_base_seq


class ahb_master_retry_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_master_retry_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_master_cfg),
      .SEQR(ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef ahb_master_retry_seq #(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_sequence_item #(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_retry_seq");
    super.new(name);
  endfunction : new

endclass : ahb_master_retry_seq

/*
* as base background polling seq
*/
class ahb_master_polling_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_polling_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_master_cfg),
      .SEQR(ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef ahb_master_polling_seq #(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_sequence_item #(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_polling_seq");
    super.new(name);
  endfunction : new

endclass : ahb_master_polling_seq

`endif // __AHB_MASTER_BASE_SEQ_SV__

