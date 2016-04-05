
`ifndef __APB_MASTER_RESET_SEQ_SV__
`define __APB_MASTER_RESET_SEQ_SV__


class apb_master_reset_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_reset_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef virtual interface smtdv_gen_rst_if#("apb_rst_if", 100, 0) rst_t;
  typedef smtdv_reset_model#(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;

  rst_mod_t rst_model;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_reset_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    if(!rst_model)
      `uvm_fatal("SMTDV_NO_RSTMODEL",{"RSTMODEL MUST BE SET ",get_full_name(),".rst_model"});

  endtask : pre_body

  virtual task do_reset();
    #10;
    rst_model.do_hw_reset(100);
  endtask : do_reset

  virtual task body();
    super.body();
    fork
      do_reset();
    join_none

    rst_model.wait_hw_reset_done();
  endtask : body

endclass : apb_master_reset_seq

`endif // __APB_MASTER_RESET_SEQ_SV__
