
`ifndef __AHB_SLAVE_ERR_INJECT_SEQ_SV__
`define __AHB_SLAVE_ERR_INJECT_SEQ_SV__

//typedef class ahb_slave_base_seq;
//typedef class ahb_sequence_item;


class ahb_slave_err_inject_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_slave_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_slave_err_inject_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_err_inject_seq");
    super.new(name);
  endfunction : new

  virtual task mid_do_read_item(item_t item);
    super.mid_do_read_item(item);
    `uvm_info(get_type_name(),
        {$psprintf("GET BEFORE ERR_INJECT ITEM\n%s", item.sprint())}, UVM_LOW)

    foreach(item.data_beat[0][i]) begin
      item.data_beat[0][i] = ~item.data_beat[0][i];
    end

    `uvm_info(get_type_name(),
        {$psprintf("GET AFTER ERR_INJECT ITEM\n%s", item.sprint())}, UVM_LOW)
  endtask : mid_do_read_item

endclass : ahb_slave_err_inject_seq

`endif // __AHB_SLAVE_ERR_INJECT_SEQ_SV__

