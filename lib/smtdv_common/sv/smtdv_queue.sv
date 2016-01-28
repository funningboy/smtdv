
`ifndef __SMTDV_QUEUE_SV__
`define __SMTDV_QUEUE_SV__

typedef class smtdv_sequence_item;

// as eq uvm_queue

class smtdv_queue#(
 type T = smtdv_sequence_item
 ) extends
  uvm_queue#(T);

  typedef smtdv_queue#(T) cmp_t;
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
  extern virtual task async_get(int idx, int delay=0, ref T item);
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
  T tarr[$];
  tarr = this.queue.find(it) with ( it.compare(item) == TRUE );
  founds = new[tarr.size()];
  foreach(tarr[i]) founds[i] = tarr[i];
  tarr.delete();
endfunction : find_all


function void smtdv_queue::find_idxs(smtdv_queue::T item, ref int founds[]);
  int tarr[$];
  tarr = this.queue.find_index(it) with ( it.compare(item) == TRUE );
  founds = new[tarr.size()];
  foreach(tarr[i]) founds[i] = tarr[i];
  tarr.delete();
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


task smtdv_queue::async_get(int idx, int delay=0, ref smtdv_queue::T item);
  wait(size()>0);
  wait(!is_lock());
  lock();
  item = get(idx);
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_get


task smtdv_queue::async_delete(int idx, int delay=0);
  wait(!is_lock());
  lock();
  delete(idx);
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_delete


class smtdv_phy_queue#(
 integer SIZE = 10,
 type T = smtdv_sequence_item
 ) extends
  smtdv_queue#(T);

  typedef smtdv_phy_queue#(SIZE, T) cmp_t;

  `uvm_object_param_utils_begin(cmp_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_phy_queue");
    super.new(name);
  endfunction : new

  extern function bit is_full();
  extern function bit is_empty();

endclass : smtdv_phy_queue

function bit smtdv_phy_queue::is_full();
  return size() == SIZE;
endfunction : is_full

function bit smtdv_phy_queue::is_empty();
  return size() == 0;
endfunction : is_empty

`endif // __SMTDV_QUEUE_SV__
