
`ifndef __APB_MASTER_SEQS_SV__
`define __APB_MASTER_SEQS_SV__

class apb_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`APB_ITEM);

    `APB_ITEM item;

    `uvm_sequence_utils(`APB_MASTER_BASE_SEQ, `APB_MASTER_SEQUENCER)

    function new(string name = "apb_master_base_seq");
      super.new(name);
    endfunction

endclass


class apb_master_1w_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `APB_MASTER_BASE_SEQ;

    `uvm_sequence_utils(`APB_MASTER_1W_SEQ, `APB_MASTER_SEQUENCER)

    function new(string name = "apb_master_1w_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      item = `APB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
        mod_t == MASTER;
        trs_t == WR;
        run_t == NORMAL;
        addr == `APB_START_ADDR(0)
      })
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass

class apb_master_1r_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `APB_MASTER_BASE_SEQ;

    `uvm_sequence_utils(`APB_MASTER_1R_SEQ, `APB_MASTER_SEQUENCER)

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      item = `APB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
        mod_t == MASTER;
        trs_t == RD;
        run_t == NORMAL;
        addr == `APB_START_ADDR(0)
      })
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass


//  Sequential seq
class apb_master_1w1r_seq #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    `APB_MASTER_BASE_SEQ;

    `APB_MASTER_1W_SEQ wseq;
    `APB_MASTER_1R_SEQ rseq;

    `uvm_sequence_utils(`APB_MASTER_1W1R_SEQ, `APB_MASTER_SEQUENCER)

    function new(string name = "apb_master_1w1r_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_do(wseq); // call as wrap child seq
      `uvm_do(rseq);
    endtask

endclass


class apb_master_stl_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `APB_MASTER_BASE_SEQ;

    int unsigned m_id = 0;
    static string m_file = "../stl/incr.stl";
    chandle m_dpi_mb;
    chandle m_dpi_trx;

    `uvm_sequence_utils(`APB_MASTER_STL_SEQ, `APB_MASTER_SEQUENCER)

    function new(string name = "apb_master_stl_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)

      m_dpi_mb = dpi_smtdv_parse_file(m_file);
      assert(m_dpi_mb!=null);

      m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
      assert(m_dpi_trx!=null);

      while (m_dpi_trx!=null) begin
        item = `APB_ITEM::type_id::create({$psprintf("item[%0d]", m_id++)});
        item.mod_t = MASTER;
        item.run_t = NORMAL;
        item.trs_t = (dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w")? WR : RD;
        item.addr  = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx));
        item.pack_data(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 0)));
        item.sel = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_id(m_dpi_trx));
        item.rsp = (dpi_smtdv_get_smtdv_transfer_resp(m_dpi_trx) == "OKAY")? OK: ERR;
        item.bg_cyc = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_begin_cycle(m_dpi_trx));
        item.ed_cyc = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_end_cycle(m_dpi_trx));

        `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
        `uvm_create(req);
        req.copy(item);
        start_item(req);
        finish_item(req);

        m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
      end
    endtask


endclass



`endif // end of __APB_MASTER_SEQS_SV__
