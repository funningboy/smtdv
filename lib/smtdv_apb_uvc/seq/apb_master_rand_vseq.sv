`ifndef __APB_MASTER_RAND_VSEQ_SV__
`define __APB_MASTER_RAND_VSEQ_SV__

//typedef class apb_master_base_seq;

// bind physical seqs to virtual seqs
class apb_master_rand_vseq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_vseq #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_rand_vseq#(ADDR_WIDTH, DATA_WIDTH) vseq_t;
  typedef apb_master_1w_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1w_t;
  typedef apb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;

  seq_1w_t seq_1w;
  seq_1r_t seq_1r;

  static const bit [ADDR_WIDTH-1:0] start_wr_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] start_rd_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] incr_wr_addr = 'h100;
  static const bit [ADDR_WIDTH-1:0] incr_rd_addr = 'h100;
  bit [ADDR_WIDTH-1:0] cur_wr_addr;
  bit [ADDR_WIDTH-1:0] cur_rd_addr;

  rand int cnt;
  rand int wr_cyc, rd_cyc;

  constraint c_cnt { cnt inside {[10:20]}; }
  constraint c_wr_cyc { wr_cyc inside {[0:10]}; }
  constraint c_rd_cyc { rd_cyc inside {[0:10]}; }

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_rand_seq");
    super.new(name);
  endfunction : new

  virtual task do_rand_wr_seq();
    cur_wr_addr = start_wr_addr;

    for(int i=0; i<cnt; i++) begin
      `uvm_create_on(seq_1w, seqr)
      `SMTDV_RAND_WITH(seq_1w,
        {
          seq_1w.start_addr == cur_wr_addr;
        })
      seq_1w.start(seqr, this, -1);
      repeat(wr_cyc) @(posedge seqr.vif.clk);
      cur_wr_addr += incr_wr_addr;
    end
  endtask : do_rand_wr_seq

  virtual task do_rand_rd_seq();
    cur_rd_addr = start_rd_addr;

    for(int i=0; i<cnt; i++) begin
     `uvm_create_on(seq_1r, seqr)
     `SMTDV_RAND_WITH(seq_1r,
       {
        seq_1r.start_addr == cur_rd_addr;
      })
     seq_1r.start(seqr, this, 0);
     repeat(rd_cyc) @(posedge seqr.vif.clk);
     cur_rd_addr += incr_rd_addr;
    end
  endtask : do_rand_rd_seq

  virtual task body();
    super.body();

    fork
      fork
        do_rand_wr_seq();
        do_rand_rd_seq();
      join
    join
    disable fork;
  endtask : body

endclass : apb_master_rand_vseq

`endif // __APB_MASTER_RAND_VSEQ_SV__
