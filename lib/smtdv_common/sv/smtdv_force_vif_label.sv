

`ifndef __SMTDV_FORCE_VIF_LABEL_SV__
`define __SMTDV_FORCE_VIF_LABEL_SV__

/*
*
*/
class smtdv_force_vif_label#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_cfg,
  type CMP = smtdv_component
 ) extends
  smtdv_cfg_label#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .T1(T1),
    .CFG(CFG),
    .CMP(CMP)
  );

endclass : smtdv_force_vif_label

`endif //

