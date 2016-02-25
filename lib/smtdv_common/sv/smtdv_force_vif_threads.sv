`ifndef __SMTDV_FORCE_VIF_THREADS_SV__
`define __SMTDV_FORCE_VIF_THREADS_SV__

typedef class smtdv_driver;

/**
* smtdv_force_vif
* as backend task to update vif when driver.cfg.has_force has updated
 register to driver module
*
* @class smtdv_force_vif#(CMP)
*
*/
class smtdv_force_vif#(
  type CMP = smtdv_driver
  ) extends
  smtdv_run_thread#(CMP);

  typedef smtdv_force_vif#(CMP) force_vif_t;

  `uvm_object_param_utils_begin(force_vif_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_force_if", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual task run();

endclass : smtdv_force_vif

task smtdv_force_vif::run();
  fork
    forever begin
      @(negedge this.cmp.vif.clk);
      this.cmp.vif.has_force = this.cmp.cfg.has_force;

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  join_none
endtask : run

`endif // end of __SMTDV_FORCE_VIF_THREADS_SV__
