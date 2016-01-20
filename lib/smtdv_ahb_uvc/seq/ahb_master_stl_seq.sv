
`ifndef __AHB_MASTER_STL_SEQ_SV__
`define __AHB_MASTER_STL_SEQ_SV__


// typedef class ahb_master_base_seq;
// typedef class ahb_item;

class ahb_master_stl_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_master_base_seq #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t pool[$];

  static string m_file = "../stl/incr.stl";
  chandle m_dpi_mb;
  chandle m_dpi_trx;

  // register sequence with a sequencer
  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_stl_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    m_dpi_mb = dpi_smtdv_parse_file(m_file);
    assert(m_dpi_mb!=null);

    m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
    assert(m_dpi_trx!=null);

    while (m_dpi_trx!=null) begin
      item = item_t::type_id::create("item");
      // skip bus req phase
      //item.pre = item;
      item.mod_t = MASTER;
      item.run_t = FORCE;
      item.trs_t = (dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w")? WR : RD;
      item.addr  = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx));

      item.bst_type = (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "SINGLE")? SINGLE:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "INCR")? INCR:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "WRAP4")? WRAP4:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "INCR4")? INCR4:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "WRAP8")? WRAP8:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "INCR8")? INCR8:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "WRAP16")? WRAP16:
        (dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "INCR16")? INCR16: SINGLE;
      item.bst_len = item.get_bst_len(item.bst_type);

      item.trx_size = (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B8")? B8:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B16")? B16:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B32")? B32:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B64")? B64:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B128")? B128:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B256")? B256:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B512")? B512:
        (dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B1024")? B1024: B32;

      item.trx_prt =  (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "OPCODE_FETCH")? OPCODE_FETCH:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "DATA_ACCESS")? DATA_ACCESS:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "USER_ACCESS")? USER_ACCESS:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "PRIVILEGED_ACCESS")? PRIVILEGED_ACCESS:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "NOT_BUFFERABLE")? NOT_BUFFERABLE:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "BUFFERABLE")?  BUFFERABLE:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "NOT_CACHEABLE")? NOT_CACHEABLE:
        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "CACHEABLE")? CACHEABLE: USER_ACCESS;

      item.post_addr(item.addr, item.trx_size, item.bst_len, item.bst_type, item.addrs);

      for(int i=0; i <= item.bst_len; i++) begin
        item.pack_data(i, dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, i)));
      end

      item.rsp = (dpi_smtdv_get_smtdv_transfer_resp(m_dpi_trx) == "OKAY")? OKAY:
        (dpi_smtdv_get_smtdv_transfer_resp(m_dpi_trx) == "ERROR")? ERROR:
        (dpi_smtdv_get_smtdv_transfer_resp(m_dpi_trx) == "RETRY")? RETRY:
        (dpi_smtdv_get_smtdv_transfer_resp(m_dpi_trx) == "SPLIT")? SPLIT: OKAY;

      item.hmastlock = dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_lock(m_dpi_trx));

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
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    end
  endtask : body

endclass : ahb_master_stl_seq

`endif // __AHB_MASTER_STL_SEQ_SV__
