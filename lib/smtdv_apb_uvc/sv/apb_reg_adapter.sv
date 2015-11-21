`ifndef __APB_REG_ADAPTER_SV__
`define __APB_REG_ADAPTER_SV__

class apb_reg_adapter #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_reg_adapter;

  `uvm_object_param_utils_begin(`APB_REG_ADAPTER)
  `uvm_object_utils_end

function new(string name ="apb_reg_adapter");
    super.new(name);
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    `APB_ITEM item = `APB_ITEM::type_id::create("apb_item");
    item.trs_t = (rw.kind == UVM_READ)? RD: WR;
    item.addr = rw.addr;
    item.pack_data(rw.data);
    return item;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    `APB_ITEM item;
    if ($cast(item, bus_item)) begin
      `uvm_fatal("NOAPITEM", "bus item is not apb item");
      return;
    end
    rw.status = UVM_IS_OK;
    rw.kind = (item.trs_t == RD)? UVM_READ: UVM_WRITE;
    rw.addr = item.addr;
    rw.data = item.unpack_data();
  endfunction

endclass


`endif // end of __APB_REG_ADAPTER_SV__
