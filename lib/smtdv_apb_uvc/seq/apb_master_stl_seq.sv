
`ifndef __APB_MASTER_STL_SEQ_SV__
`define __APB_MASTER_STL_SEQ_SV__

//typedef class apb_master_base_seq;
//typedef class apb_sequence_item;

class apb_master_stl_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t pool[$];

  string m_file = "../stl/incr.stl";
  chandle m_dpi_mb;
  chandle m_dpi_trx;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_stl_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    m_dpi_mb = dpi_smtdv_parse_file(m_file);
    assert(m_dpi_mb!=null);

    m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
    assert(m_dpi_trx!=null);

    while (m_dpi_trx!=null) begin
      //`uvm_create(), `uvm_create_on()
      item = item_t::type_id::create("item");
      item.mod_t = MASTER;
      item.run_t = FORCE;
      item.trs_t = (dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w")? WR : RD;
      item.addr  = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx));
      item.pack_data(0, dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 0)));
      item.sel = 1 << dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_id(m_dpi_trx));
      item.rsp = (dpi_smtdv_get_smtdv_transfer_resp(m_dpi_trx) == "OK")? OK: ERR;
      item.bg_cyc = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_begin_cycle(m_dpi_trx));
      item.ed_cyc = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_end_cycle(m_dpi_trx));
      m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
      pool.push_back(item);
    end
  endtask : pre_body

  virtual task body();
    super.body();

    foreach(pool[i]) begin
      item = pool[i];
      `uvm_create(req)
      req.copy(item);
      start_item(req);
      finish_item(req);
    end
  endtask : body

endclass : apb_master_stl_seq

`endif // __APB_MASTER_STL_SEQ_SV__
