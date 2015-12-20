
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

  bit                 debug = TRUE;
  int                 uuid = 0;

  smtdv_base_item next = null;
  smtdv_base_item pre = null;
  smtdv_base_item parent = null;

  `uvm_object_param_utils_begin(smtdv_base_item)
    if (debug) begin
      `uvm_field_int(uuid, UVM_ALL_ON)
      `uvm_field_object(pre, UVM_DEFAULT)
      `uvm_field_object(next, UVM_DEFAULT)
    end
  `uvm_object_utils_end

  function new(string name = "smtdv_base_item");
    super.new(name);
  endfunction

endclass

/**
* smtdv_sequence_item
* a parameterize sequence item
*
* extends smtdv_base_item
*
* @class smtdv_base_item
*
*/
class smtdv_sequence_item #(
    ADDR_WIDTH = 14,
    DATA_WIDTH = 32
  ) extends
  smtdv_base_item;

  bit                 debug = TRUE;
  rand bit [ADDR_WIDTH-1:0]     addr;
  rand bit [ADDR_WIDTH-1:0]     addrs[$];
  rand bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];
  rand bit [(DATA_WIDTH>>3)-1:0][0:0] byten_beat[$];
  rand int            offset = DATA_WIDTH>>3;

  bit                 success = FALSE;
  bit                 retry = FALSE;
  bit                 mem_complete = FALSE;
  bit                 fifo_complete = FALSE;
  bit                 addr_complete = FALSE;
  bit                 data_complete = FALSE;
  int                 id = 0;
  int 	              rsp = 0;
  int                 bst_len = 0;

  int                 addr_idx = 0;
  int                 data_idx = 0;

  rand mod_type_t    mod_t;  // {MASTER/SLAVE}
  rand trs_type_t    trs_t;  // {RD/WR}
  rand run_type_t    run_t;  // {FORCE/NORMAL/SKIP/ERRORINJECT}

  longint       bg_cyc;
  longint       ed_cyc;
  longint       bg_time;
  longint       ed_time;
  rand int      life_time = 0;

  /**
   * life_time Int Constraint.
   * Constrain item life_time.
   *
   */
  constraint c_life_time  {
    life_time inside {[10:20]};
  }

  `uvm_object_param_utils_begin(smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
    `uvm_field_int(id, UVM_ALL_ON)
    // virtual field should be imp at top level
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(bst_len, UVM_ALL_ON)
    `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_field_queue_int(addrs, UVM_ALL_ON)
    `uvm_field_queue_int(data_beat, UVM_ALL_ON)
    `uvm_field_queue_int(byten_beat, UVM_ALL_ON)
    // hiden info
    if (debug) begin
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
    end
  `uvm_object_utils_end

  function new(string name = "smtdv_sequence_item");
    super.new(name);
  endfunction

  extern virtual function void pack_data(int idx=0, bit [DATA_WIDTH-1:0] idata=0);
  extern virtual function bit[DATA_WIDTH-1:0] unpack_data(int idx=0);
  extern virtual function bit compare(smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) cmp);

endclass : smtdv_sequence_item

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
 *  compare addrs, data_beat, ...
 *  @return bool
 */
function bit smtdv_sequence_item::compare(smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) cmp);
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
  return TRUE;
endfunction : compare


`endif // end of __SMTDV_SEQUENCE_ITEM_SV__
