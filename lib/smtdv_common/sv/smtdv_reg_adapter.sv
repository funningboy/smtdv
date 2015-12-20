`ifndef __SMTDV_REG_ADAPTER_SV__
`define __SMTDV_REG_ADAPTER_SV__

/**
* smtdv_reg_adapter
*
* @class smtdv_reg_adapter
*
*/
class smtdv_reg_adapter extends uvm_reg_adapter;

  `uvm_object_utils(smtdv_reg_adapter)

  function new(string name ="smtdv_reg_adapter");
    super.new(name);
  endfunction

  extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
  extern virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

endclass : smtdv_reg_adapter

function uvm_sequence_item smtdv_reg_adapter::reg2bus(const ref uvm_reg_bus_op rw);
endfunction

function void smtdv_reg_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
endfunction


`endif // enf of __SMTDV_REG_ADAPTER_SV__
