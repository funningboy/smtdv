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
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

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
      @(posedge seqr.vif.dummy);
      grab(seqr);
      seqr.cfg.has_block = TRUE;
      #100;

      // put item at front of the arbitration queue
      item = item_t::type_id::create("item");
      `SMTDV_RAND_WITH(item,
        {
        mod_t == MASTER;
        trs_t == RD;
        run_t == FORCE;
        addr == cur_addr;
        prio == -1;
        })

      `uvm_create(req)
      req.copy(item);
      start_item(req);
      finish_item(req);

      `uvm_info(get_type_name(),
        {$psprintf("GET IRQ READ \n%s", item.sprint())}, UVM_LOW)

      seqr.cfg.has_block = FALSE;
      ungrab(seqr);
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

