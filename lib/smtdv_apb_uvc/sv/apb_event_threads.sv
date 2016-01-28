
`ifndef __APB_FORCE_PRELOAD_SV__
`define __APB_FORCE_PRELOAD_SV__

typedef class apb_item;
typedef class apb_master_cfg;

/*
* using FW ctl to preloading img/seq to DUT
*/
class apb_force_preload_label#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = apb_item#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = apb_master_cfg,
  type CMP = apb_master#(ADDR_WIDTH, DATA_WIDTH)
) extends
  smtdv_cfg_label#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(T1),
      .CFG(CFG),
      .CMP(CMP)
  );

  typedef apb_force_preload_label#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, CMP) label_t;
  typedef enum = [STOP_ALL, LOCK,] ..
  label_t label[string] = '{
    // using FW ctl as default vseqer to handle seqs
    // field :  match, addr, mask, data, require, depent, visit
    //
    "STOP_ALL" // bit[0]: stop all seqs and interrupt
    "LOCK":       '{} // bit[1]: try to lock dut
    "FORCE_VIF":  '{FALSE, 'h0,  'h1,  'h0,  FALSE, "",          FALSE},  cfg.has_force, //bit[0]: switch to preloading mode by force vif
    "SET_STL_ID": '{FALSE, 'h0,  'h6,  'h0,  FALSE, "force_vif", FALSE}, //bit[2:1]: set stl id for preloading stl file
    "START TO_LOAD"
    "WAIT_UNTIL_DONE" // interrupt when preload seq is done
    "FREE_VIF":
    "BACK_TO_NORMAL":
    "UNLOCK": //
  };

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "apb_force_preload_label", CMP parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void update_cfg();
    cfg.has_force = maps["force_vif"].data & maps["force_vif"].mask;
    cfg.preload = maps["preload"].data & maps["load_stl_id"].mask;
  endfunction : update_cfg

endclass : apb_force_preload_label

`endif // end of __APB_FORCE_PRELOAD_SV__
