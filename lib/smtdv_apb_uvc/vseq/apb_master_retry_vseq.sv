
`ifndef __APB_MASTER_RETRY_VSEQ_SV__
`define __APB_MASTER_RETRY_VSEQ_SV__

//typedef class apb_master_1w_seq;
//typedef class smtdv_master_base_seq;

// retry seq while err rsp received
class apb_master_retry_vseq
  extends
  apb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  typedef apb_master_retry_vseq vseq_t;
  typedef apb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef apb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;
  typedef apb_master_retry_seq#(ADDR_WIDTH, DATA_WIDTH) seq_rty_t;

  seq_1w_t seq_1w;
  seq_1r_t seq_1r;
  seq_rty_t seq_rty;

  // constraint random gen doesn't work at static const type,
  // that need to cast as default R/W value
  static const bit [ADDR_WIDTH-1:0] start_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] end_addr = `APB_END_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_addr = 'h100;
  static const int outstanding = 2;

  bit [ADDR_WIDTH-1:0] cur_addr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_retry_vseq");
    super.new(name);
  endfunction : new

  virtual task do_outstanding_wr_seq();
    seq_rty.set_watch_window(WR, outstanding);
    assert(seq_rty.is_ready_to_watch(WR));
    cur_addr = start_addr;

    repeat(outstanding) begin
      `uvm_create_on(seq_1w, vseqr.apb_magts[0].seqr)
      `SMTDV_RAND_WITH(seq_1w,
      {
        start_addr == cur_addr;
      })
      seq_1w.start(vseqr.apb_magts[0].seqr, this, 0);
      cur_addr += incr_addr;
    end

    wait(seq_rty.is_finish_to_watch(WR));
  endtask : do_outstanding_wr_seq

  virtual task do_outstanding_rd_seq();
    seq_rty.set_watch_window(RD, outstanding);
    assert(seq_rty.is_ready_to_watch(RD));
    cur_addr = start_addr;

    repeat(outstanding) begin
      `uvm_create_on(seq_1r, vseqr.apb_magts[0].seqr)
      `SMTDV_RAND_WITH(seq_1r,
      {
          start_addr == cur_addr;
      })
      seq_1r.start(vseqr.apb_magts[0].seqr, this, 0);
      cur_addr += incr_addr;
    end

    wait(seq_rty.is_finish_to_watch(RD));
  endtask : do_outstanding_rd_seq

  virtual task do_retry_seq();
    seq_rty.start(vseqr.apb_magts[0].seqr, this, -1);
  endtask : do_retry_seq

  virtual task pre_body();
    super.pre_body();
    `uvm_create_on(seq_rty, vseqr.apb_magts[0].seqr)
    `SMTDV_RAND(seq_rty)
    seq_rty.register_watch_table(start_addr, end_addr);
  endtask : pre_body

  virtual task body();
    super.body();

    fork
      do_retry_seq();
    join_none

    do_outstanding_wr_seq();
    do_outstanding_rd_seq();

    vseqr.apb_magts[0].seqr.finish = TRUE;
  endtask : body

endclass : apb_master_retry_vseq

`endif // __APB_MASTER_RETRY_VSEQ_SV__
