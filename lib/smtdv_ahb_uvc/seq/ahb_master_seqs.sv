`ifndef __AHB_MASTER_SEQS_SV__
`define __AHB_MASTER_SEQS_SV__

typedef class ahb_master_agent;

class ahb_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`AHB_ITEM);

    `AHB_ITEM item;
    `AHB_MASTER_AGENT agent;

    `uvm_object_utils_begin(`AHB_MASTER_BASE_SEQ)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(`AHB_MASTER_SEQUENCER)

    function new(string name = "ahb_master_base_seq");
      super.new(name);
    endfunction

    virtual task body();
      $cast(agent, p_sequencer.get_parent());
    endtask

endclass


class ahb_master_unlock_incr_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

     mailbox #(`AHB_ITEM) tbox;

    `uvm_object_param_utils_begin(`AHB_MASTER_UNLOCK_INCR_SEQ)
    `uvm_object_utils_end

    function new(string name = "ahb_master_unlock_incr_seq");
      super.new(name);
    endfunction

    virtual task body();
      `AHB_ITEM pitem;
      bit [ADDR_WIDTH-1:0] addrs[$];
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)

      // fill wite trx to mem
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == WR;
          addr == `AHB_START_ADDR(0)
          bst_type inside {INCR4, INCR8, INCR16};
          trx_size == B32;
          hmastlock == 0;
      })
      tbox.put(item);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // read trx back from mem
      tbox.get(pitem);
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
         mod_t == MASTER;
         run_t == FORCE;
         trs_t == RD;
         addr == pitem.addr;
         bst_type == pitem.bst_type;
         trx_size == pitem.trx_size;
         hmastlock == 0;
      })
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass


class ahb_master_unlock_wrap_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

     mailbox #(`AHB_ITEM) tbox;

    `uvm_object_param_utils_begin(`AHB_MASTER_UNLOCK_WRAP_SEQ)
    `uvm_object_utils_end

    function new(string name = "ahb_master_unlock_wrap_seq");
      super.new(name);
    endfunction

    virtual task body();
      `AHB_ITEM pitem;
      bit [ADDR_WIDTH-1:0] addrs[$];
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)

      // fill wite trx to mem
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == WR;
          addr == `AHB_START_ADDR(0)
          bst_type inside {WRAP4, WRAP8, WRAP16};
          trx_size == B32;
          hmastlock == 0;
      })
      tbox.put(item);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // read trx back from mem
      tbox.get(pitem);
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == RD;
          addr == pitem.addr;
          bst_type == pitem.bst_type;
          trx_size == pitem.trx_size;
          hmastlock == 0;
      })
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass


class ahb_master_lock_incr_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

     mailbox #(`AHB_ITEM) tbox;

    `uvm_object_param_utils_begin(`AHB_MASTER_LOCK_INCR_SEQ)
    `uvm_object_utils_end

    function new(string name = "ahb_master_lock_incr_seq");
      super.new(name);
      tbox = new();
    endfunction

    virtual task body();
      `AHB_ITEM pitem;
      bit [ADDR_WIDTH-1:0] addrs[$];
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)

      // fill wite trx to mem
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == WR;
          addr == `AHB_START_ADDR(0)
          bst_type inside {INCR4, INCR8, INCR16};
          trx_size == B32;
          hmastlock == 1;
      })
      tbox.put(item);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // read trx back from mem
       tbox.get(pitem);
       item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == RD;
          addr == pitem.addr;
          bst_type == pitem.bst_type;
          trx_size == pitem.trx_size;
          hmastlock == 1;
      })
      item.pre = pitem;
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass


class ahb_master_lock_wrap_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

     mailbox #(`AHB_ITEM) tbox;

    `uvm_object_param_utils_begin(`AHB_MASTER_LOCK_WRAP_SEQ)
    `uvm_object_utils_end

    function new(string name = "ahb_master_lock_wrap_seq");
      super.new(name);
    endfunction

    virtual task body();
      `AHB_ITEM pitem;
      bit [ADDR_WIDTH-1:0] addrs[$];
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)

      // fill wite trx to mem
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == WR;
          addr == `AHB_START_ADDR(0)
          bst_type inside {WRAP4, WRAP8, WRAP16};
          trx_size == B32;
          hmastlock == 1;
      })
      tbox.put(item);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // read trx back from mem
      tbox.get(pitem);
      item = `AHB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          run_t == FORCE;
          trs_t == RD;
          addr == pitem.addr;
          bst_type == pitem.bst_type;
          trx_size == pitem.trx_size;
          hmastlock == 1;
      })
      item.pre = pitem;
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      // as eq `uvm_do/`uvm_do_with
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass


class ahb_master_lock_swap_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

     mailbox #(`AHB_ITEM) tbox;

    `uvm_object_param_utils_begin(`AHB_MASTER_LOCK_SWAP_SEQ)
    `uvm_object_utils_end

    function new(string name = "ahb_master_lock_swap_seq");
      super.new(name);
    endfunction

    virtual task body();
    endtask

endclass


class ahb_master_stl_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

    int unsigned m_id = 0;
    static string m_file = "../stl/incr8.stl";
    chandle m_dpi_mb;
    chandle m_dpi_trx;

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`AHB_MASTER_STL_SEQ)
   `uvm_object_utils_end

    function new(string name = "ahb_master_stl_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq %s... ", m_file)}, UVM_MEDIUM)

      m_dpi_mb = dpi_smtdv_parse_file(m_file);
      assert(m_dpi_mb!=null);

      m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
      assert(m_dpi_trx!=null);

      while (m_dpi_trx!=null) begin
        item = `AHB_ITEM::type_id::create({$psprintf("item[%0d]", m_id++)});
        // skip bus req phase
        //item.pre = item;

        item.mod_t = MASTER;
        item.run_t = NORMAL;
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

        item.trx_prt =  (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "OPCODE_FETCH")? `OPCODE_FETCH:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "DATA_ACCESS")? `DATA_ACCESS:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "USER_ACCESS")? `USER_ACCESS:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "PRIVILEGED_ACCESS")? `PRIVILEGED_ACCESS:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "NOT_BUFFERABLE")? `NOT_BUFFERABLE:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "BUFFERABLE")? `BUFFERABLE:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "NOT_CACHEABLE")? `NOT_CACHEABLE:
                        (dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "CACHEABLE")? `CACHEABLE: `USER_ACCESS;

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

        `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
        `uvm_create(req);
        req.copy(item);
        start_item(req);
        finish_item(req);

        m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
      end
    endtask


endclass

`endif // end of __AHB_MASTER_SEQS_SV__

