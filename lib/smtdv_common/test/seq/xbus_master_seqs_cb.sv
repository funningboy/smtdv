
// adaptor: extract from sqlite3 db / or
`ifndef __XBUS_MASTER_SEQS_CB_SV__
`define __XBUS_MASTER_SEQS_CB_SV__

class xbus_master_stl_seq #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    `XBUS_MASTER_BASE_SEQ;

    int unsigned m_id = 0;
    static string m_file = "../stl/000010af.trx";
    chandle m_dpi_mb;
    chandle m_dpi_trx;

    `uvm_object_utils_begin(`XBUS_MASTER_STL_SEQ)
    `uvm_object_utils_end

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
        item.mod_t = MASTER;
        item.run_t = NORMAL;
        item.trs_t  = (dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w")? WR : RD;
        item.addr   = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx));
        item.pack_data(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx)));
        item.pack_byten(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_byten(m_dpi_trx)));

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

`endif // __XBUS_MASTER_SEQS_CB_SV__
