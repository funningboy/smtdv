`ifndef __APB_REG_ADAPTER_SV__
`define __APB_REG_ADAPTER_SV__

class apb_reg_adapter#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_reg_adapter;

  typedef apb_reg_adapter reg_t;
  typedef apb_item item_t;

  item_t item;

  `uvm_object_param_utils_begin(reg_t)
  `uvm_object_utils_end

  function new(string name ="apb_reg_adapter");
    super.new(name);
  endfunction : new

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    item = item_t::type_id::create("apb_item");
    item.trs_t = (rw.kind == UVM_READ)? RD: WR;
    item.addr = rw.addr;
    item.pack_data(0, rw.data);
    return item;
  endfunction : reg2bus

  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    if ($cast(item, bus_item)) begin
      `uvm_fatal("APB_ITEM_ERR", "BUS ITEM IS NOT APB ITEM");
      return;
    end
    rw.status = UVM_IS_OK;
    rw.kind = (item.trs_t == RD)? UVM_READ: UVM_WRITE;
    rw.addr = item.addr;
    rw.data = item.unpack_data(0);
  endfunction : bus2reg

endclass : apb_reg_adapter


`endif // end of __APB_REG_ADAPTER_SV__
