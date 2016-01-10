`ifndef __APB_BASE_SEQ_SV__
`define __APB_BASE_SEQ_SV__

class apb_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  )extends
    `SMTDV_MASTER_BASE_SEQ(apb, ADDR_WIDTH, DATA_WIDTH);

  `SMTDV_MASTER_AGENT(apb, ADDR_WIDTH, DATA_WIDTH) agent;

  `uvm_object_param_utils_begin(`APB_BASE_SEQ)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(`SMTDV_MASTER_SEQUENCER(apb, ADDR_WIDTH, DATA_WIDTH))

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction

  virtual task pre_body();
    $cast(agent, p_sequencer.get_parent());
  endtask

endclass


`endif // end of __APB_BASE_SEQ_SV__
