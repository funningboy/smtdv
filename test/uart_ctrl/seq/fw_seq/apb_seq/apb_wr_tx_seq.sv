`ifndef __APB_WR_TX_SEQ_SV__
`define __APB_WR_TX_SEQ_SV__

// writes 0-15 data in UART TX FIFO
class apb_wr_tx_seq
  extends
  `APB_BASE_SEQ;

  function new(string name="apb_wr_tx_seq");
    super.new(name);
  endfunction

  // Register sequence with a sequencer
  `uvm_object_utils(`APB_WR_TX_SEQ)

  rand int unsigned num_of_wr;
  constraint num_of_wr_ct { (num_of_wr <= 15); }

  virtual task body();
    start_addr = `APB_START_ADDR(0) + `TX_FIFO_REG;
    for (int i = 0; i < num_of_wr; i++) begin
      // cluster.env.hanvif
      //if (agent.get_parent().get_parent().hanvif) begin
      //end

      item = `APB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          trs_t == WR;
          run_t == NORMAL;
          addr == start_addr;
        })
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
      #200;
    end
  endtask

endclass
