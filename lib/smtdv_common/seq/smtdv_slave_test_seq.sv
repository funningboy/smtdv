`ifndef __SMTDV_SLAVE_TEST_SEQ_SV__
`define __SMTDV_SLAVE_TEST_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_slave_base_seq;
//typedef class smtdv_slave_cfg;
//typedef class smtdv_sequencer;

class smtdv_slave_test_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_base_seq #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface smtdv_if),
      .CFG(smtdv_slave_cfg),
      .SEQR(smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, virtual interface smtdv_if, smtdv_slave_cfg, smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef smtdv_slave_test_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_slave_test_seq");
    super.new(name);
  endfunction : new

  extern virtual task body();

endclass : smtdv_slave_test_seq

task smtdv_slave_test_seq::body();
  fork
    fork
      begin
        repeat(30) @(posedge seqr.vif.clk);
      end
    join
  join
  disable fork;

  seqr.finish = TRUE;
endtask : body

`endif // end_of __SMTDV_SLAVE_TEST_SEQ_SV__
