`ifndef __SMTDV_MASTER_TEST_SEQ_SV__
`define __SMTDV_MASTER_TEST_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_base_seq;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;
//typedef class smtdv_master_base_vseq;

class smtdv_master_test_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface smtdv_if),
      .CFG(smtdv_master_cfg),
      .SEQR(smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, virtual interface smtdv_if, smtdv_master_cfg, smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef smtdv_master_test_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_test_seq");
    super.new(name);
  endfunction : new

endclass : smtdv_master_test_seq


class smtdv_master_wait_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_master_test_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef smtdv_master_wait_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_wait_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(50) @(posedge seqr.vif.clk);
    `uvm_info(get_full_name(), {"do_seq_wait"}, UVM_LOW)
  endtask : body

endclass : smtdv_master_wait_seq


class smtdv_master_do_a_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_master_test_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef smtdv_master_do_a_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_do_a_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(4) begin
      // as eq item = type_id::create("item");
      `uvm_create_on(item, seqr)
      start_item(item);
      finish_item(item);
      `uvm_info(get_type_name(), {"do_seq_a"}, UVM_LOW)
    end
  endtask : body

endclass : smtdv_master_do_a_seq


class smtdv_master_do_b_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_master_test_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef smtdv_master_do_b_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_do_b_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(4) begin
      // as eq item = type_id::create("item");
      `uvm_do_on_pri_with(item,
        seqr,
        -1,
        {
          item.addr == 0;
        })
      `uvm_info(get_type_name(), {"do_seq_b"}, UVM_LOW)
    end
  endtask : body

endclass : smtdv_master_do_b_seq


class smtdv_master_do_grab_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_master_test_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef smtdv_master_do_grab_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_do_grab_seq");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(3) begin
      grab();
      repeat(2) begin
       #30
        `uvm_create_on(item, seqr)
        start_item(item);
        finish_item(item);
        `uvm_info(get_type_name(), {"do_seq_grab"}, UVM_LOW)
        repeat(2) @(posedge seqr.vif.clk);
      end
      ungrab();
    end
  endtask : body

endclass : smtdv_master_do_grab_seq


`endif // end_of __SMTDV_MASTER_TEST_SEQ_SV__
