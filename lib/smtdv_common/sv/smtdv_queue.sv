
`ifndef __SMTDV_QUEUE_SV__
`define __SMTDV_QUEUE_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_base_item;

/*
*  extend uvm_queue to item queue
*/
class smtdv_queue#(
 type T = smtdv_sequence_item
 ) extends
  uvm_queue#(T);

  typedef smtdv_queue#(T) cmp_t;
  bit has_lock = FALSE;
  bit has_debug = TRUE;

  T nitem;

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
  extern virtual function void find_all(T item, ref T founds[$]);
  extern virtual function void find_idxs(T item, ref int founds[$]);
  extern virtual function void dump(int remain=10);

  extern virtual task async_push_front(T item, int delay=0);
  extern virtual task async_push_back(T item, int delay=0);
  extern virtual task async_pop_front(int delay=0, ref T item);
  extern virtual task async_pop_back(int delay=0, ref T item);
  extern virtual task async_insert(int idx, T item, int delay=0);
  extern virtual task async_get(int idx, int delay=0, ref T item);
  extern virtual task async_prio_get(int delay=0, ref T item); // Qos
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
  smtdv_base_item sitem;
  // seq_item
  if (!$cast(sitem, item))
    `uvm_error("SMTDV_DCAST_ITEM",
        {$psprintf("DOWN CAST ITEM TO SEQUENCE ITEM FAIL")})

  foreach(this.queue[i]) begin
    if (this.queue[i].compare(item)) return TRUE;
  end
  return FALSE;
endfunction : has_item


function void smtdv_queue::find_all(smtdv_queue::T item, ref smtdv_queue::T founds[$]);
  smtdv_base_item sitem;
  if (!$cast(sitem, item))
    `uvm_error("SMTDV_DCAST_ITEM",
        {$psprintf("DOWN CAST ITEM TO SEQUENCE ITEM FAIL")})

  founds = this.queue.find(it) with ( it.compare(item) == TRUE );
endfunction : find_all


function void smtdv_queue::find_idxs(smtdv_queue::T item, ref int founds[$]);
  smtdv_base_item sitem;
  if (!$cast(sitem, item))
    `uvm_error("SMTDV_DCAST_ITEM",
        {$psprintf("DOWN CAST ITEM TO SEQUENCE ITEM FAIL")})

    founds = this.queue.find_index(it) with ( it.compare(item) == TRUE );
endfunction : find_idxs


function void smtdv_queue::dump(int remain=10);
  int bg_idx = 0;
  int ed_idx = 0;

  if (size()==0) begin
    `uvm_info(get_full_name(),
        {$psprintf("QUEUE IS EMPTY\n")}, UVM_LOW)
    return;
  end

  if (size()>=remain)
    bg_idx = size() - remain;

  ed_idx = size() -1;

  `uvm_info(get_full_name(),
      {$psprintf("START TO DUMP QUEUE")}, UVM_LOW)

  `uvm_info(get_full_name(),
      {$psprintf("--------------------")}, UVM_LOW)

  for(int i=bg_idx; i<=ed_idx; i++)
    `uvm_info(get_full_name(),
        {$psprintf("%s\n", this.queue[i].sprint())}, UVM_LOW)

  `uvm_info(get_full_name(),
      {$psprintf("--------------------")}, UVM_LOW)

endfunction : dump

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


task smtdv_queue::async_prio_get(int delay=0, ref smtdv_queue::T item);
  wait(size()>0);
  wait(!is_lock());
  lock();
  this.queue.sort(it) with (it.prio);
  if (has_debug)
    dump();
  item = pop_front();
  `SMTDV_SWAP(delay)
  unlock();
endtask : async_prio_get


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


/*
* smtdv integer queue
*/
class smtdv_int_queue#(
 type T = int
 ) extends
  uvm_queue#(T);

  typedef smtdv_int_queue#(T) queue_t;

  `uvm_object_param_utils_begin(queue_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_int_queue");
    super.new(name);
  endfunction : new

endclass : smtdv_int_queue


/*
* smtdv physical queue
*/
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
  extern function void shit_right(T item);
  extern function void shit_left(T item);

endclass : smtdv_phy_queue

function bit smtdv_phy_queue::is_full();
  return size() == SIZE;
endfunction : is_full

function bit smtdv_phy_queue::is_empty();
  return size() == 0;
endfunction : is_empty

function void smtdv_phy_queue::shit_right(smtdv_phy_queue::T item);
  T eitem;
  if (is_full()) eitem = pop_back();
  push_front(item);
endfunction : shit_right

function void smtdv_phy_queue::shit_left(smtdv_phy_queue::T item);
  T fitem;
  if (is_full()) fitem = pop_front();
  push_back(item);
endfunction : shit_left


`endif // __SMTDV_QUEUE_SV__
