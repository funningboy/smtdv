
`ifndef __APB_EVENT_THREADS_SV__
`define __APB_EVENT_THREADS_SV__

//force vif apb cfg
class apb_force_vif_cfg_evt #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_cfg_evt #(ADDR_WIDTH, DATA_WIDTH);

  rule maps[string] = '{
    // set seqs
    // field :  match, addr, mask, data, require, depent, visit
    //
    "preload": '{FALSE, 'h0,  'h6,  'h0,  FALSE, "force", FALSE}, //[2:1] preload file id
    "force":  '{FALSE, 'h0,  'h1,  'h0,  FALSE, "",      FALSE}      //[0] force vif
  };

  `uvm_object_param_utils_begin(smtdv_force_vif_cfg#(ADDR_WIDTH,DATA_WIDTH))
  `uvm_object_utils_end

  function new(string name = "smtdv_event", smtdv_cfg cfg=null, smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item=null);
    super.new(name, cfg, item);
  endfunction

  virtual function void update_cfg();
    cfg.has_force = maps["force"].data & maps["force"].mask;
    cfg.preload = maps["preload"].data & maps["preload"].mask;
  endfunction

endclass

`endif // end of __APB_EVENT_THREADS_SV__
