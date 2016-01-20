
`ifndef __XBUS_MASTER_SEQS_SV__
`define __XBUS_MASTER_SEQS_SV__

class xbus_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`XBUS_ITEM);

    `XBUS_ITEM item;

    `uvm_sequence_utils(`XBUS_MASTER_BASE_SEQ, `XBUS_MASTER_SEQUENCER)

    function new(string name = "xbus_master_base_seq");
      super.new(name);
    endfunction

endclass


// as init reg set seq and register to Master sequencer
class xbus_master_1w_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `XBUS_MASTER_BASE_SEQ;

    `uvm_sequence_utils(`XBUS_MASTER_1W_SEQ, `XBUS_MASTER_SEQUENCER)

    function new(string name = "xbus_master_1w_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      item = `XBUS_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
        mod_t == smtdv_common_pkg::MASTER;
        trs_t == smtdv_common_pkg::WR;
        run_t == smtdv_common_pkg::NORMAL;
        addr == `XBUS_START_ADDR(0)
      })
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass

// as init reg polling seq
class xbus_master_1r_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `XBUS_MASTER_BASE_SEQ;

    `uvm_sequence_utils(`XBUS_MASTER_1R_SEQ, `XBUS_MASTER_SEQUENCER)

    function new(string name = "xbus_master_1r_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      item = `XBUS_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
        mod_t == smtdv_common_pkg::MASTER;
        trs_t == smtdv_common_pkg::RD;
        run_t == smtdv_common_pkg::NORMAL;
        addr == `XBUS_START_ADDR(0)
      })
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass

class xbus_master_stl_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `XBUS_MASTER_BASE_SEQ;

    int unsigned m_id = 0;
    static string m_file = "../stl/000010af.trx";
    chandle m_dpi_mb;
    chandle m_dpi_trx;

    `uvm_sequence_utils(`XBUS_MASTER_STL_SEQ, `XBUS_MASTER_SEQUENCER)

    function new(string name = "xbus_master_stl_seq");
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
        item = `XBUS_ITEM::type_id::create({$psprintf("item[%0d]", m_id++)});
        item.mod_t = smtdv_common_pkg::MASTER;
        item.run_t = smtdv_common_pkg::NORMAL;
        item.trs_t  = (dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w")? smtdv_common_pkg::WR : smtdv_common_pkg::RD;
        item.addr   = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx));
        item.pack_data(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 0)));
        item.pack_byten(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_byten(m_dpi_trx, 0)));

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


class xbus_master_1w1r_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `XBUS_MASTER_BASE_SEQ;

    `XBUS_MASTER_1W_SEQ wseq;
    `XBUS_MASTER_1R_SEQ rseq;

    `uvm_sequence_utils(`XBUS_MASTER_1W1R_SEQ, `XBUS_MASTER_SEQUENCER)

    function new(string name = "xbus_master_1w1r_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      wseq = `XBUS_MASTER_1W_SEQ::type_id::create("wseq");
      rseq = `XBUS_MASTER_1R_SEQ::type_id::create("rseq");
      `uvm_do(wseq); // call as wrap child seq via uvm_do or uvm_do_with
      `uvm_do(rseq);
    endtask

endclass

`endif // end of __XBUS_MASTER_SEQS_SV__
