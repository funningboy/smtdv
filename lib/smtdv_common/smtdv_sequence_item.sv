
`ifndef __SMTDV_SEQUENCE_ITEM_SV__
`define __SMTDV_SEQUENCE_ITEM_SV__

class smtdv_sequence_item extends uvm_sequence_item;

  rand bit [31:0]     addrs[$];
  rand bit [3:0][7:0] data_beat[$];
  rand bit [3:0][0:0] byten_beat[$];

  bit                 complete = 0;
  bit                 addr_complete = 0;
  bit                 data_complete = 0;

  smtdv_sequence_item next = null;
  smtdv_sequence_item pre = null;
  smtdv_sequence_item parent = null;

  int                 addr_idx = 0;
  int                 data_idx = 0;

  rand mod_type_t    mod_t;  // {MASTER/SLAVE}
  rand trs_type_t    trs_t;  // {RD/WR}
  rand run_type_t    run_t;  // {FORCE/NORMAL/SKIP/ERRORINJECT}

  longint       bg_cyc;
  longint       ed_cyc;
  rand int      life_time = 0;

  constraint c_life_time  {
    life_time inside {[10:20]};
  }

  `uvm_object_param_utils_begin(smtdv_sequence_item)
    `uvm_field_queue_int(addrs, UVM_ALL_ON)
    `uvm_field_queue_int(data_beat, UVM_ALL_ON)
    `uvm_field_queue_int(byten_beat, UVM_ALL_ON)
    `uvm_field_int(complete, UVM_ALL_ON)
    `uvm_field_int(addr_complete, UVM_ALL_ON)
    `uvm_field_int(data_complete, UVM_ALL_ON)
    `uvm_field_object(pre, UVM_DEFAULT)
    `uvm_field_object(next, UVM_DEFAULT)
    `uvm_field_int(addr_idx, UVM_ALL_ON)
    `uvm_field_int(data_idx, UVM_ALL_ON)
    `uvm_field_enum(mod_type_t, mod_t, UVM_ALL_ON)
    `uvm_field_enum(trs_type_t, trs_t, UVM_ALL_ON)
    `uvm_field_enum(run_type_t, run_t, UVM_ALL_ON)
    `uvm_field_int(bg_cyc, UVM_ALL_ON)
    `uvm_field_int(ed_cyc, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_sequence_item");
    super.new(name);
  endfunction

  function bit compare(smtdv_sequence_item cmp);
    // addr cmp
    if (this.addrs.size() != cmp.addrs.size() ) begin
      return FALSE;
    end
    foreach(this.addrs[i]) begin
      if (this.addrs[i] != cmp.addrs[i]) begin
        return FALSE;
      end
    end
    // data_beat cmp
    if (this.data_beat.size() != cmp.data_beat.size() ) begin
        return FALSE;
    end
    foreach(this.data_beat[i]) begin
      if (this.data_beat[i] != cmp.data_beat[i]) begin
        return FALSE;
      end
    end
    // byten cmp
    if (this.byten_beat.size() != cmp.byten_beat.size() ) begin
      return FALSE;
    end
    foreach(this.byten_beat[i]) begin
      if (this.byten_beat[i] != cmp.byten_beat[i]) begin
        return FALSE;
      end
    end
    return TRUE;
  endfunction

endclass : smtdv_sequence_item

`endif // end of __SMTDV_SEQUENCE_ITEM_SV__
