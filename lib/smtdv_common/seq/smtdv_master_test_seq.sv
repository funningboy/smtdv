`ifndef __SMTDV_MASTER_TEST_SEQ_SV__
`define __SMTDV_MASTER_TEST_SEQ_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_master_cfg;

class smtdv_master_test_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, CFG, T1)
  ) extends
    smtdv_sequence#(T1);

    typedef smtdv_master_test_seq#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, SEQR) seq_t;
    typedef virtual interface smtdv_if vv_t;
    typedef smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH, vv_t) mst_agt_t;

    T1 item;
    CFG cfg;
    mst_agt_t agent;

    `uvm_object_param_utils_begin(seq_t)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(SEQR)

    function new(string name = "smtdv_master_test_seq");
      super.new(name);
    endfunction

    virtual task pre_do(bit is_item);
      $cast(agent, p_sequencer.get_parent());
    endtask : pre_do

    extern virtual task body();

endclass : smtdv_master_test_seq

task smtdv_master_test_seq::body();
  fork
    fork
      //
      begin
        $cast(agent, p_sequencer.get_parent());
        repeat(30) @(posedge agent.vif.clk);
      end

      // test on uvm_do
      begin
        `uvm_do(item)
      end

      // test on uvm_do_on_with
      begin
        `uvm_do_on_with(item,
          p_sequencer,
          {
            addr == 0;
          })
      end

      // test on uvm_do_on_pri_with
      begin
        `uvm_do_on_pri_with(item,
          p_sequencer,
          0,
          {
            addr == 0;
          })
      end

    join
  join
  disable fork;

  p_sequencer.finish = TRUE;
endtask : body

`endif // end_of __SMTDV_MASTER_TEST_SEQ_SV__
