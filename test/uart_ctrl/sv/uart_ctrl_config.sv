

class uart_charlen_cfg #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  `SMTDV_CFG_EVT;

  event_rule maps[string] = '{
    // field name: addr, exp data, visit
    "char_length": '{ `APB_MAS + `LINE_CTRL, 'h0000_0003, 0}
  };

  `uvm_object_param_utils_begin(smtdv_event)
  `uvm_object_utils_end

  function new(string name = "smtdv_event", smtdv_component cmp=null);
    super.new(name);
  endfunction

  virtual task update_cfg();
    cfg.char_length =
  endtask
endclass

class uart_nbstop_cfg #(

)

