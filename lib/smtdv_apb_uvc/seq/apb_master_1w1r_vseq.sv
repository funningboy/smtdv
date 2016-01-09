
`ifndef __APB_MASTER_1W1R_VSEQ_SV__
`define __APB_MASTER_1W1R_VSEQ_SV__

class apb_master_1w1r_vseq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_vseq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_1w1r_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef apb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef apb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;

  seq_1w_t seq_1w;
  seq_1r_t seq_1r;

  static const bit [ADDR_WIDTH-1:0] start_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_addr = 'h100;
  bit [ADDR_WIDTH-1:0] cur_addr;

  rand int cnt;

  constraint c_cnt { cnt inside {[10:20]}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_1w1r_seq");
    super.new(name);
  endfunction : new

  // read after write
  virtual task body();
    super.body();

    cur_addr = start_addr;

    for(int i=0; i<cnt; i++) begin
      `uvm_create_on(seq_1w, seqr)
      `SMTDV_RAND_WITH(seq_1w,
        {
          seq_1w.start_addr == cur_addr;
        })
      seq_1w.start(seqr, this, 0);

      `uvm_create_on(seq_1r, seqr)
      `SMTDV_RAND_WITH(seq_1r,
        {
          seq_1r.start_addr == cur_addr;
        })
      seq_1r.start(seqr, this, 0);

      cur_addr += incr_addr;
    end
  endtask : body

endclass : apb_master_1w1r_vseq

`endif // __APB_MASTER_1W1R_VSEQ_SV__


