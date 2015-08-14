
`ifndef __APB_MASTER_SEQS_SV__
`define __APB_MASTER_SEQS_SV__

class apb_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`APB_ITEM);

    `APB_ITEM item;

    `uvm_object_utils_begin(`APB_MASTER_BASE_SEQ)
    `uvm_object_utils_end

    function new(string name = "apb_master_base_seq");
      super.new(name);
    endfunction

endclass


class apb_master_1w1r_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `APB_MASTER_BASE_SEQ;

    `uvm_object_utils_begin(`APB_MASTER_1W1R_SEQ)
    `uvm_object_utils_end

    function new(string name = "apb_master_1w1r_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      item = `APB_ITEM::type_id::create("item");
      item.mod_t = MASTER;
      item.trs_t = WR;
      item.run_t = NORMAL;
      item.addr = 32'h000f;
      item.pack_data(32'hffff_ffff);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      item = `APB_ITEM::type_id::create("item");
      item.mod_t = MASTER;
      item.trs_t = RD;
      item.run_t = NORMAL;
      item.addr = 32'h000f;
      // as expected data
      item.pack_data(32'hffff_ffff);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

endclass


class apb_master_rand_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `APB_MASTER_BASE_SEQ;

    `uvm_object_utils_begin(`APB_MASTER_RAND_SEQ)
    `uvm_object_utils_end

    function new(string name = "apb_master_rand_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      item = `APB_ITEM::type_id::create("item");
      void'(item.randomize());
     `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      item = `APB_ITEM::type_id::create("item");
      item.copy(req);
      item.trs_t = RD;
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

  endclass

`endif // end of __APB_MASTER_SEQS_SV__
