`ifndef __SMTDV_FORCE_VIF_THREADS_SV__
`define __SMTDV_FORCE_VIF_THREADS_SV__

typedef class smtdv_driver;

// as backend task to update vif when driver.cfg.has_force has updated
// register to driver module
class smtdv_force_vif#(
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_cfg,
  type REQ = uvm_sequence_item,
  type RSP = REQ
  ) extends
  smtdv_run_thread;

  smtdv_driver #(VIF, CFG, REQ, RSP) cmp;

  `uvm_object_param_utils_begin(smtdv_force_vif#(VIF,CFG,REQ,RSP))
  `uvm_object_utils_end

  function new(string name = "auto_update_if", smtdv_component parent=null);
    super.new(name, parent);
  endfunction

  virtual task run();
    fork
      forever begin
        @(negedge this.cmp.vif.clk);
        this.cmp.vif.has_force = this.cmp.cfg.has_force;
      end
    join_none
  endtask

endclass


`endif // end of __SMTDV_FORCE_VIF_THREADS_SV__
