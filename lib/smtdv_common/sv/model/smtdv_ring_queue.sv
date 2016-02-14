
`ifndef __SMTDV_RING_QUEUE_SV__
`define __SMTDV_RING_QUEUE_SV__

typedef class smtdv_phy_queue;


class smtdv_ring_queue#(
  integer SIZE = 10,
  type T1 = uvm_sequence_item
  ) extends
    smtdv_phy_queue#(SIZE, T1);

  typedef smtdv_ring_queue#(SIZE, T1) cmp_t;

  typedef struct {
    int tail;
    int header;
  } ptr_t;

  ptr_t ptr;

  `uvm_object_param_utils_begin(cmp_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_ring_queue");
    super.new(name);
    ptr.tail = 0;
    ptr.header = 0;
  endfunction : new

  extern function bit is_full();
  extern function bit is_empty();

  extern virtual task async_put_header(T1 item, int delay=0);
  extern virtual task async_put_tail(T1 item, int delay=0);
  extern virtual task async_get_header(int delay=0, ref T1 item);
  extern virtual task async_get_tail(int delay=0, ref T1 item);

endclass : smtdv_ring_queue


function bit smtdv_ring_queue::is_empty();
  return ptr.header == ptr.tail;
endfunction : is_empty


function bit smtdv_ring_queue::is_full();
  return ptr.header == (ptr.tail+1) % SIZE;
endfunction : is_full


task smtdv_ring_queue::async_put_header(smtdv_ring_queue::T1 item, int delay=0);
  wait(!is_full() && !is_lock());
  lock();
  insert(ptr.header, item);
  ptr.header++;
  if (ptr.header == SIZE) ptr.header = 0;
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_put_header


task smtdv_ring_queue::async_put_tail(smtdv_ring_queue::T1 item, int delay=0);
  wait(!is_full() && !is_lock());
  lock();
  insert(ptr.tail, item);
  ptr.tail++;
  if (ptr.tail == SIZE) ptr.tail = 0;
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_put_tail


task smtdv_ring_queue::async_get_header(int delay =0,ref smtdv_ring_queue::T1 item);
  wait(!is_empty() && !is_lock());
  lock();
  item = get(ptr.header);
  ptr.header--;
  if (ptr.header == 0) ptr.header = SIZE;
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_get_header


task smtdv_ring_queue::async_get_tail(int delay =0, ref smtdv_ring_queue::T1 item);
  wait(!is_empty() && !is_lock());
  lock();
  item = get(ptr.tail);
  ptr.tail--;
  if (ptr.tail == 0) ptr.tail = SIZE;
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_get_tail


`endif // __SMTDV_RING_QUEUE_SV__
