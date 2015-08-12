
`ifndef __SMTDV_SCOREBOARD_SV__
`define __SMTDV_SCOREBOARD_SV__

class smtdv_scoreboard #(type T1 = uvm_object, type T2 = T1) extends smtdv_component#(uvm_scoreboard);

  `uvm_component_param_utils(smtdv_scoreboard#(T1, T2))

  function new(string name = "smtdv_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : smtdv_scoreboard

`endif // end of __SMTDV_SCOREBOARD_SV__
