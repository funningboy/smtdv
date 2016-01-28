
`ifndef __SMTDV_HASH_SV__
`define __SMTDV_HASH_SV__

typedef smtdv_queue;
typedef smtdv_node;
typedef smtdv_cmp_node;
typedef smtdv_seq_node;

// as eq sv associate array
//
class smtdv_hash#(
  type KEY = int,
  type VAL = int
  ) extends
  uvm_object;

  typedef smtdv_hash#(KEY, VAL) hash_t;

  VAL hash[KEY];
  bit has_finalize = FALSE;

  `uvm_object_param_utils_begin(hash_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_hash");
    super.new(name);
  endfunction : new

  extern function void finalize();
  extern function bit exists(KEY key);
  extern function void set(KEY key, VAL val);
  extern function VAL get(KEY key);
  extern function void delete(KEY key);
  extern function void keys(ref KEY keys[]);
  extern function void values(ref VAL vals[]);

endclass : smtdv_hash

function void smtdv_hash::finalize();
  has_finalize = TRUE;
endfunction : finalize

function bit smtdv_hash::exists(KEY key);
  return hash.exists(key);
endfunction : exists

function void smtdv_hash::set(KEY key, VAL val);
  if (has_finalize) return;
  hash[key] = val;
endfunction : set

function smtdv_hash::VAL smtdv_hash::get(KEY key);
  if (!exists(key)) return null;
  return hash[key];
endfunction : get

function void smtdv_hash::delete(KEY key);
  uvm_object pkey;
  if (has_finalize) return;
  if ($cast(pkey, key)) begin
    if (pkey == null) hash.delete();
  end
  else begin
    if (key==-1) hash.delete();
  end
  hash.delete(key);
endfunction : delete

function void smtdv_hash::keys(ref KEY keys[]);
  KEY tkeys[$], key;
  if (hash.first(key)) begin
    do begin
        tkeys.push_back(key);
    end
    while (hash.next(key) );
  end
  keys = new[tkeys.size()];
  foreach(tkeys[i]) keys[i] = tkeys[i];
  tkeys.delete();
endfunction : keys

function void smtdv_hash::values(ref VAL vals[]);
  VAL tvals[$], val;
  KEY key;
  if (hash.first(key)) begin
    do begin
        tvals.push_back(hash[key]);
    end
    while (hash.next(key) );
  end
  vals = new[tvals.size()];
  foreach(tvals[i]) vals[i] = tvals[i];
  tvals.delete();
endfunction : values

/*
* wrapper as node hash
*/
class smtdv_node_hash#(
  type KEY = int,
  type VAL = smtdv_node
  ) extends
  smtdv_hash#(
    .KEY(KEY),
    .VAL(VAL)
  );

  typedef smtdv_node_hash#(KEY, VAL) hash_t;

  `uvm_object_param_utils_begin(hash_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_node_hash");
    super.new(name);
  endfunction : new

endclass : smtdv_node_hash

`endif // __SMTDV_HASH_SV__
