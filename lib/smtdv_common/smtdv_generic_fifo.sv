// n dimnsion array, like [nxm] : page * block * plane *  die * channel
// ringbuffer circlebuf
//
`ifndef __SMTDV_GENERIC_FIFO_SV__
`define __SMTDV_GENERIC_FIFO_SV__

class smtdv_generic_fifo #(DEEP = 100, DATA_WIDTH = 128)
  extends uvm_object;

  bit[DATA_WIDTH-1:0] fifo[$];
  int unsigned ix = 0;

  bit has_callback = 1;
  smtdv_generic_fifo_cb#(DEEP, DATA_WIDTH) fifo_cb;

  `uvm_object_param_utils_begin(smtdv_generic_fifo#(DATA_WIDTH))
  `uvm_object_utils_end

  function new(string name = "smtdv_generic_fifo");
    super.new(name);
    fifo_cb = new();
  endfunction

  virtual function bit is_full();
    return ix == DEEP;
  endfunction

  virtual function bit is_empty();
    return ix == 0;
  endfunction

  virtual task push_back(bit [DATA_WIDTH-1:0] data, longint cyc);
    if (!is_full()) begin
      fifo.push_back(data);
      ix++;
      if (has_callback) begin void'(fifo_cb.push_cb(data, cyc)); end
    end
  endtask

  virtual task push_front(bit [DATA_WIDTH-1:0] data, longint cyc);
    if (!is_full()) begin
      fifo.push_front(data);
      ix++;
      if (has_callback) begin void'(fifo_cb.push_cb(data, cyc)); end
    end
  endtask

  virtual task pop_back(ref bit [DATA_WIDTH-1:0] data, longint cyc);
    if (!is_empty()) begin
      data = fifo.pop_back();
      ix--;
      if (has_callback) begin void'(fifo_cb.pop_cb(data, cyc)); end
    end
  endtask

  virtual task pop_front(ref bit [DATA_WIDTH-1:0] data, longint cyc);
    if (!is_empty()) begin
      data = fifo.pop_front();
      ix--;
      if (has_callback) begin void'(fifo_cb.pop_cb(data, cyc)); end
    end
  endtask

endclass


// ringbuff
// prioritybuff /sort by order {lifetime, priority, qos...}


`endif // end of __SMTDV_GENERIC_FIFO_SV__
