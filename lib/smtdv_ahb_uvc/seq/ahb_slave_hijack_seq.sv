`ifndef __AHB_SLAVE_HIJACK_SEQ_SV__
`define __AHB_SLAVE_HIJACK_SEQ_SV__

//typedef class ahb_slave_base_seq;

class ahb_slave_hijack_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  ahb_slave_base_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_slave_hijack_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  int rd_idx = 0;
  int rd_max = 1;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_hijack_seq");
    super.new(name);
  endfunction : new

  //phase 1, release force while slave is running into normal behavior
  virtual task mid_do_read_item(item_t item);
    super.mid_do_read_item(item);
    if (rd_idx >= rd_max) begin
      seqr.cfg.has_force = FALSE;

      `uvm_info(get_type_name(),
          {"GET AFTER RELEASE FORCE\n"}, UVM_LOW)
    end
    rd_idx++;
  endtask : mid_do_read_item

  //phase 2. goback to force behavior
//  virtual task
//  endtask :

endclass : ahb_slave_hijack_seq

`endif // __AHB_SLAVE_HIJACK_SEQ_SV__
