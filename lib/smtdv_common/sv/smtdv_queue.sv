
`ifndef __SMTDV_QUEUE_SV__
`define __SMTDV_QUEUE_SV__

// as eq uvm_queue

class smtdv_queue#(
 ADDR_WIDTH = 14,
 DATA_WIDTH = 32,
 type T = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
 extends
  uvm_queue#(T);

  typedef smtdv_queue#(ADDR_WIDTH, DATA_WIDTH, T) cmp_t;
  bit has_lock = FALSE;

  `uvm_object_param_utils_begin(cmp_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_queue");
    super.new(name);
  endfunction : new

  extern virtual function bit is_lock();
  extern virtual function void lock();
  extern virtual function void unlock();
  extern virtual function void sort();
  extern virtual function bit has_item(T item);
  extern virtual function void find_all(T item, ref T founds[]);
  extern virtual function void find_idxs(T item, ref int founds[]);

  extern virtual task async_push_front(T item, int delay=0);
  extern virtual task async_push_back(T item, int delay=0);
  extern virtual task async_pop_front(int delay=0, ref T item);
  extern virtual task async_pop_back(int delay=0, ref T item);
  extern virtual task async_insert(int idx, T item, int delay=0);
  extern virtual task async_delete(int idx, int delay=0);

endclass : smtdv_queue


function void smtdv_queue::lock();
  assert(is_lock()==FALSE);
  has_lock = TRUE;
endfunction : lock


function void smtdv_queue::unlock();
  assert(is_lock()==TRUE);
  has_lock = FALSE;
endfunction : unlock


function bit smtdv_queue::is_lock();
  return has_lock == TRUE;
endfunction : is_lock


function bit smtdv_queue::has_item(smtdv_queue::T item);
  foreach(this.queue[i]) begin
    if (this.queue[i].compare(item))
      return TRUE;
  end
  return FALSE;
endfunction : has_item


function void smtdv_queue::find_all(smtdv_queue::T item, ref smtdv_queue::T founds[]);
  smtdv_queue::T arr[$];
  arr = this.queue.find(it) with ( it.compare(item) == TRUE );
  founds = new[arr.size()];
  foreach(arr[i]) begin
     founds[i] = arr[i];
  end
endfunction : find_all


function void smtdv_queue::find_idxs(smtdv_queue::T item, ref int founds[]);
  int arr[$];
  arr = this.queue.find_index(it) with ( it.compare(item) == TRUE );
  founds = new[arr.size()];
  foreach(arr[i]) begin
     founds[i] = arr[i];
  end
endfunction : find_idxs


// TODO::quick sort, heap sort, merge sort...
function void smtdv_queue::sort();
endfunction : sort


task smtdv_queue::async_push_front(smtdv_queue::T item, int delay=0);
  wait(!is_lock());
  lock();
  push_front(item);
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_push_front


task smtdv_queue::async_push_back(smtdv_queue::T item, int delay=0);
  wait(!is_lock());
  lock();
  push_back(item);
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_push_back


task smtdv_queue::async_pop_front(int delay=0, ref smtdv_queue::T item);
  wait(size()>0);
  wait(!is_lock());
  lock();
  item = pop_front();
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_pop_front


task smtdv_queue::async_pop_back(int delay=0, ref smtdv_queue::T item);
  wait(size()>0);
  wait(!is_lock());
  lock();
  item = pop_back();
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_pop_back


task smtdv_queue::async_insert(int idx, smtdv_queue::T item, int delay=0);
  wait(!is_lock());
  lock();
  insert(idx, item);
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_insert


task smtdv_queue::async_delete(int idx, int delay=0);
  wait(!is_lock());
  lock();
  delete(idx);
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_delete

`endif // __SMTDV_QUEUE_SV__
