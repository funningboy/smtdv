`ifndef __APB_MASTER_FW_CTL_VSEQ_SV__
`define __APB_MASTER_FW_CTL_VSEQ_SV__

class apb_master_fw_ctl_vseq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_vseq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_fw_ctl_vseq #(ADDR_WIDTH, DATA_WIDTH) vseq_t;

endclass : apb_master_fw_ctl_vseq

`endif // __APB_MASTER_FW_CTL_VSEQ_SV__
