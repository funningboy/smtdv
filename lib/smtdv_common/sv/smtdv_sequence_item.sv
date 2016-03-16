
`ifndef __SMTDV_SEQUENCE_ITEM_SV__
`define __SMTDV_SEQUENCE_ITEM_SV__

/**
* smtdv_base_item
* a lightweight oo item, pre, next, parent
*
* @class smtdv_base_item
*
*/
class smtdv_base_item
  extends
  uvm_sequence_item;

  int initorid = -1;
  int targetid = -1;
  rand int prio;

  typedef uvm_component cmp_t;
  typedef smtdv_base_item bitem_t;

  cmp_t cmp;  // registered cmp
  bitem_t next = null;
  bitem_t pre = null;
  bitem_t parent = null;

  constraint c_prio { prio inside {[-2:10]}; }

  `uvm_object_param_utils_begin(bitem_t)
    `uvm_field_int(prio, UVM_ALL_ON)
    `uvm_field_int(initorid, UVM_ALL_ON)
    `uvm_field_int(targetid, UVM_ALL_ON)
    `uvm_field_object(parent, UVM_DEFAULT)
    `uvm_field_object(pre, UVM_DEFAULT)
    `uvm_field_object(next, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_base_item");
    super.new(name);
  endfunction : new

  virtual function void callback();
  endfunction : callback

endclass : smtdv_base_item

/**
* smtdv_sequence_item
* a parameterize sequence item
*
* extends smtdv_base_item
*
* @class smtdv_base_item
*
*/
class smtdv_sequence_item#(
    ADDR_WIDTH = 14,
    DATA_WIDTH = 32
  ) extends
  smtdv_base_item;

  typedef smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  rand bit [ADDR_WIDTH-1:0]     addr;
  rand bit [ADDR_WIDTH-1:0]     addrs[$];
  rand bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];
  rand bit [(DATA_WIDTH>>3)-1:0][0:0] byten_beat[$];
  rand int            offset = DATA_WIDTH>>3;
  rand int 	          rsp;
  rand int            bst_len;

  bit                 success = FALSE;
  bit                 retry = FALSE;
  bit                 mem_complete = FALSE;
  bit                 fifo_complete = FALSE;
  bit                 addr_complete = FALSE;
  bit                 data_complete = FALSE;
  int                 uuid = 0;
  int                 addr_idx = 0;
  int                 data_idx = 0;

  rand mod_type_t    mod_t;  // {MASTER/SLAVE}
  rand trs_type_t    trs_t;  // {RD/WR}
  rand run_type_t    run_t;  // {FORCE/NORMAL/SKIP/ERRORINJECT/LOCK}

  longint       bg_cyc;
  longint       ed_cyc;
  longint       bg_time;
  longint       ed_time;
  rand int      life_time;

  /**
   * life_time Int Constraint.
   * Constrain item life_time.
   *
   */
  constraint c_life_time  {
    life_time inside {[10:20]};
  }

  `uvm_object_param_utils_begin(item_t)
    `uvm_field_int(uuid, UVM_ALL_ON)
    // virtual field should be imp at top level
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(bst_len, UVM_ALL_ON)
    `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_field_queue_int(addrs, UVM_ALL_ON)
    `uvm_field_queue_int(data_beat, UVM_ALL_ON)
    `uvm_field_queue_int(byten_beat, UVM_ALL_ON)
    `uvm_field_int(offset, UVM_ALL_ON)
    `uvm_field_int(success, UVM_ALL_ON)
    `uvm_field_int(retry, UVM_ALL_ON)

    `uvm_field_int(mem_complete, UVM_ALL_ON)
    `uvm_field_int(fifo_complete, UVM_ALL_ON)
    `uvm_field_int(addr_complete, UVM_ALL_ON)
    `uvm_field_int(data_complete, UVM_ALL_ON)

    `uvm_field_int(addr_idx, UVM_ALL_ON)
    `uvm_field_int(data_idx, UVM_ALL_ON)
    `uvm_field_enum(mod_type_t, mod_t, UVM_ALL_ON)
    `uvm_field_enum(trs_type_t, trs_t, UVM_ALL_ON)
    `uvm_field_enum(run_type_t, run_t, UVM_ALL_ON)

    `uvm_field_int(bg_cyc, UVM_ALL_ON)
    `uvm_field_int(ed_cyc, UVM_ALL_ON)
    `uvm_field_int(bg_time, UVM_ALL_ON)
    `uvm_field_int(ed_time, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_sequence_item");
    super.new(name);
  endfunction : new

  extern virtual function void pack_data(int idx=0, bit [DATA_WIDTH-1:0] idata=0);
  extern virtual function bit[DATA_WIDTH-1:0] unpack_data(int idx=0);
  extern virtual function bit compare(item_t cmp);
  extern virtual function void reset_index();
  extern virtual function void reset_status();

endclass : smtdv_sequence_item

// data stream is [0] = da, [1]...
// stand uvm pack/unpack func
// function void do_pack(uvm_packer packer);
//  super.do_pack(packer);
//  packer.pack_field_int(da, $bits(da));
// endfunction
//
// function void do_unpack(uvm_packer packer);
//  super.do_un_pack(packer);
//  packer.un_pack_field_int)($bits(da))
//endfunction
/**
 *  pack serial data to byte arr data_beat
 *  @return void
 */
function void smtdv_sequence_item::pack_data(int idx=0, bit [DATA_WIDTH-1:0] idata=0);
  int n = (DATA_WIDTH>>3);
  for (int i=0; i<n; i+=1) begin
    data_beat[idx][i] = idata[i*8+:8];
  end
endfunction : pack_data

/**
 *  unpack byte arr data_beat to serial data
 *  @return bit[DATA_WIDTH-1:0]
 */
function bit[smtdv_sequence_item::DATA_WIDTH-1:0] smtdv_sequence_item::unpack_data(int idx=0);
  bit [DATA_WIDTH-1:0] odata;
  int n = (DATA_WIDTH>>3);
  for (int i=0; i<n; i+=1) begin
    odata[i*8+:8] = data_beat[idx][i];
  end
  return odata;
endfunction : unpack_data

/**
 *  compare addrs, data_beat, ... at the same type,
 *  sync to base item while type of item is not match
 *  @return bool
 */
function bit smtdv_sequence_item::compare(smtdv_sequence_item::item_t cmp);
  // addr cmp
  if (addrs.size() != cmp.addrs.size() ) begin
    return FALSE;
  end
  foreach(addrs[i]) begin
    if (addrs[i] != cmp.addrs[i]) begin
      return FALSE;
    end
  end
  // data_beat cmp
  if (data_beat.size() != cmp.data_beat.size() ) begin
    return FALSE;
  end
  foreach(data_beat[i]) begin
    if (data_beat[i] != cmp.data_beat[i]) begin
      return FALSE;
    end
  end
  // byten cmp
  if (byten_beat.size() != cmp.byten_beat.size() ) begin
    return FALSE;
  end
  foreach(byten_beat[i]) begin
    if (byten_beat[i] != cmp.byten_beat[i]) begin
      return FALSE;
    end
  end

  if (initorid!=-1 && cmp.initorid!=-1) begin
    if (initorid != cmp.initorid)
        return FALSE;
  end

  if (targetid!=-1 && cmp.targetid!=-1) begin
    if (targetid != cmp.targetid)
        return FALSE;
  end

  return TRUE;
endfunction : compare

function void smtdv_sequence_item::reset_index();
  addr_idx = 0;
  data_idx = 0;
endfunction : reset_index

function void smtdv_sequence_item::reset_status();
  mem_complete = FALSE;
  fifo_complete = FALSE;
  addr_complete = FALSE;
  data_complete = FALSE;
endfunction : reset_status

`endif // end of __SMTDV_SEQUENCE_ITEM_SV__
