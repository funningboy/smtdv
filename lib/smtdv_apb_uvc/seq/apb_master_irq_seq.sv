`ifndef __APB_MASTER_IRQ_SEQ_SV__
`define __APB_MASTER_IRQ_SEQ_SV__

class apb_master_irq_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_irq_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_master_1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_1r_t;

  seq_1r_t seq_1r;

  static const bit [ADDR_WIDTH-1:0] start_addr = `APB_START_ADDR(0)
  bit [ADDR_WIDTH-1:0] cur_addr;

  bit blocking = TRUE;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_irq_seq");
    super.new(name);
  endfunction : new

  virtual task do_listen_irq();
    cur_addr = start_addr;

    forever begin
      @(seqr.vif.pirq);

      grab(seqr);

      `uvm_create_on(seq_1r, seqr)
      `SMTDV_RAND_WITH(seq_1r,
        {
          seq_1r.start_addr == cur_addr;
        })
      seq_1r.start(seqr, this, -1);
      #10;
      ungrab(seqr);
      #10;
    end
  endtask : do_listen_irq

  virtual task body();
    super.body();
    fork
      do_listen_irq();
    join_none
  endtask : body

endclass : apb_master_irq_seq

`endif // __APB_MASTER_IRQ_SEQ_SV__

