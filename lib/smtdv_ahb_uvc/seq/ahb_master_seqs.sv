`ifndef __AHB_MASTER_SEQS_SV__
`define __AHB_MASTER_SEQS_SV__

class ahb_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`AHB_ITEM);

    `AHB_ITEM item;

    `uvm_sequence_utils(`AHB_MASTER_BASE_SEQ, `AHB_MASTER_SEQUENCER)

    function new(string name = "ahb_master_base_seq");
      super.new(name);
    endfunction

endclass


class ahb_master_unlock_incr_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_BASE_SEQ;

     mailbox #(`AHB_ITEM) tbox;

    `uvm_sequence_utils(`AHB_MASTER_UNLOCK_INCR_SEQ, `AHB_MASTER_SEQUENCER)

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

    `uvm_sequence_utils(`AHB_MASTER_UNLOCK_WRAP_SEQ, `AHB_MASTER_SEQUENCER)

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

    `uvm_sequence_utils(`AHB_MASTER_LOCK_INCR_SEQ, `AHB_MASTER_SEQUENCER)

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

    `uvm_sequence_utils(`AHB_MASTER_LOCK_WRAP_SEQ, `AHB_MASTER_SEQUENCER)

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

    `uvm_sequence_utils(`AHB_MASTER_LOCK_SWAP_SEQ, `AHB_MASTER_SEQUENCER)

    function new(string name = "ahb_master_lock_swap_seq");
      super.new(name);
    endfunction

    virtual task body();
    endtask

endclass

`endif // end of __AHB_MASTER_SEQS_SV__

