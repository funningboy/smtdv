// n dimnsion array, like [nxm] : page * block * plane *  die * channel
// ringbuffer circlebuf
//
`ifndef __SMTDV_GENERIC_FIFO_SV__
`define __SMTDV_GENERIC_FIFO_SV__

typedef class smtdv_generic_fifo_cb;

/**
* smtdv_generic_fifo
* as basic fifo
*
* @class smtdv_generic_fifo#(DEEP, DATA_WIDTH)
*
*/
class smtdv_generic_fifo #(
  DEEP = 100,
  DATA_WIDTH = 128
  )extends
  uvm_object;

  typedef smtdv_generic_fifo#(DEEP, DATA_WIDTH) fifo_t;
  typedef smtdv_generic_fifo_cb#(DEEP, DATA_WIDTH) fifo_cb_t;

  bit[DATA_WIDTH-1:0] fifo[$];
  int unsigned ix = 0;

  bit has_callback = TRUE;
  fifo_cb_t fifo_cb;

  `uvm_object_param_utils_begin(fifo_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_generic_fifo");
    super.new(name);
    fifo_cb = new();
  endfunction

  extern virtual function bit is_full();
  extern virtual function bit is_empty();
  extern virtual task push_back(bit [DATA_WIDTH-1:0] data, longint cyc);
  extern virtual task push_front(bit [DATA_WIDTH-1:0] data, longint cyc);
  extern virtual task pop_back(ref bit [DATA_WIDTH-1:0] data, longint cyc);
  extern virtual task pop_front(ref bit [DATA_WIDTH-1:0] data, longint cyc);

endclass : smtdv_generic_fifo

function bit smtdv_generic_fifo::is_full();
  return ix == DEEP;
endfunction : is_full

function bit smtdv_generic_fifo::is_empty();
  return ix == 0;
endfunction : is_empty

task smtdv_generic_fifo::push_back(bit [DATA_WIDTH-1:0] data, longint cyc);
  if (!is_full()) begin
    fifo.push_back(data);
    ix++;
    if (has_callback) begin void'(fifo_cb.push_cb(data, cyc)); end
  end
endtask : push_back

task smtdv_generic_fifo::push_front(bit [DATA_WIDTH-1:0] data, longint cyc);
  if (!is_full()) begin
    fifo.push_front(data);
    ix++;
    if (has_callback) begin void'(fifo_cb.push_cb(data, cyc)); end
  end
endtask : push_front

task smtdv_generic_fifo::pop_back(ref bit [DATA_WIDTH-1:0] data, longint cyc);
  if (!is_empty()) begin
    data = fifo.pop_back();
    ix--;
    if (has_callback) begin void'(fifo_cb.pop_cb(data, cyc)); end
  end
endtask : pop_back

task smtdv_generic_fifo::pop_front(ref bit [DATA_WIDTH-1:0] data, longint cyc);
  if (!is_empty()) begin
    data = fifo.pop_front();
    ix--;
    if (has_callback) begin void'(fifo_cb.pop_cb(data, cyc)); end
  end
endtask : pop_front


// ringbuff
// prioritybuff /sort by order {lifetime, priority, qos...}


`endif // end of __SMTDV_GENERIC_FIFO_SV__
