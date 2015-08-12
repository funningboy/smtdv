
`ifndef __XBUS_MASTER_SEQS_SV__
`define __XBUS_MASTER_SEQS_SV__

class xbus_master_base_seq #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`XBUS_ITEM);

    `XBUS_ITEM item;

    `uvm_object_utils_begin(`XBUS_MASTER_BASE_SEQ)
    `uvm_object_utils_end

    function new(string name = "xbus_master_base_seq");
      super.new(name);
    endfunction

endclass


class xbus_master_1w1r_seq #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    `XBUS_MASTER_BASE_SEQ;

    `uvm_object_utils_begin(`XBUS_MASTER_1W1R_SEQ)
    `uvm_object_utils_end

    function new(string name = "xbus_master_1w1r_seq");
      super.new(name);
    endfunction

    virtual task body();
      super.body();
      `uvm_info(get_type_name(), {$psprintf("starting seq ... ")}, UVM_MEDIUM)
      item = `XBUS_ITEM::type_id::create("item");
      item.mod_t = MASTER;
      item.trs_t = WR;
      item.run_t = NORMAL;
      item.addr = 32'h000f;
      item.pack_data(32'hffff_ffff);
      item.pack_byten(4'b0001);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      item = `XBUS_ITEM::type_id::create("item");
      item.mod_t = MASTER;
      item.trs_t = RD;
      item.run_t = NORMAL;
      item.addr = 32'h000f;
      // as expected data
      item.pack_data(32'hffff_ffff);
      item.pack_byten(4'b0001);
      `uvm_info(get_type_name(), {$psprintf("\n%s", item.sprint())}, UVM_LOW)
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);
    endtask

  endclass

`endif // end of __XBUS_MASTER_SEQS_SV__
