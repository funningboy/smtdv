
`ifndef __AHB_MASTER_1W1R_VSEQ_SV__
`define __AHB_MASTER_1W1R_VSEQ_SV__

class ahb_master_1w1r_vseq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_master_base_vseq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_master_1w1r_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef ahb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef ahb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;

  seq_1w_t seq_1w;
  seq_1r_t seq_1r;

  static const bit [ADDR_WIDTH-1:0] start_addr = `AHB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_addr = 'h1000;
  bit [ADDR_WIDTH-1:0] cur_addr;

  rand bst_type_t           bst_type;
  rand trx_size_t           trx_size;
  rand int cnt;

  constraint c_cnt { cnt inside {[10:20]}; }
  constraint c_trx_size { trx_size inside {B32}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_1w1r_seq");
    super.new(name);
  endfunction : new

  // read after write
  virtual task body();
    super.body();

    cur_addr = start_addr;

    for(int i=0; i<cnt; i++) begin
      `SMTDV_RAND_VAR_WITH(bst_type, {
          bst_type inside {SINGLE, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16};
      })
      `uvm_create_on(seq_1w, seqr)
      seq_1w.start_addr = cur_addr;
      seq_1w.bst_type = bst_type;
      seq_1w.trx_size = trx_size;
      seq_1w.start(seqr, this, 0);

      `uvm_create_on(seq_1r, seqr)
      seq_1r.start_addr = cur_addr;
      seq_1r.bst_type = bst_type;
      seq_1r.trx_size = trx_size;
      seq_1r.start(seqr, this, 0);

      cur_addr += incr_addr;
    end
  endtask : body

endclass : ahb_master_1w1r_vseq


`endif // __AHB_MASTER_1W1R_VSEQ_SV__
