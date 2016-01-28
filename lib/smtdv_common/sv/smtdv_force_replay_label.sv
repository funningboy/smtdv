

/*
* using FW ctl to replaying img/seq to DUT
*/
class smtdv_force_replay_label#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_item#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_master_cfg,
  type CMP = smtdv_master#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
  smtdv_cfg_label#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .T1(T1),
    .CFG(CFG),
    .CMP(CMP)
  );

  typedef smtdv_force_replay_label#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, CMP) label_t;

  label_t label[string] = '{
    // using FW ctl as default vseqer to handle seqs
    // field :  match, addr, mask, data, require, depent, visit
    //
    "STOP_ALL" // bit[0]: stop all seqs and clear all interrupts
    "LOCK":       '{} // bit[1]: try to lock dut
    "FORCE_VIF":  '{FALSE, 'h0,  'h1,  'h0,  FALSE, "",          FALSE}, //bit[0]: switch to replaying mode by force vif
    "SET_STL_ID": '{FALSE, 'h0,  'h6,  'h0,  FALSE, "force_vif", FALSE}, //bit[2:1]: set stl id for replaying stl file
    "START TO_LOAD"
    "WAIT_UNTIL_DONE" // interrupt when replay seq is done
    "FREE_VIF":
    "BACK_TO_NORMAL":
    "UNLOCK": //
  };

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_force_replay_label", CMP parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void update_cfg();
  endfunction : update_cfg

endclass : smtdv_force_replay_label

`endif // end of __smtdv_FORCE_replay_SV__
