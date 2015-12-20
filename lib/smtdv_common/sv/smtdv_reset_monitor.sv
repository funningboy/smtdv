
`ifndef __SMTDV_RESET_MONITOR_SV__
`define __SMTDV_RESET_MONITOR_SV__

/**
* smtdv_reset_monitor
* parameterize reset monitor while resetn assert
*
* @class smtdv_reset_monitor#(ADDR_WIDTH, DATA_WIDTH, VIF)
*
*/
class smtdv_reset_monitor #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_gen_rst_if)
  extends
    smtdv_monitor#(
      ADDR_WIDTH,
      DATA_WIDTH,
      VIF);

  typedef smtdv_reset_monitor#(ADDR_WIDTH, DATA_WIDTH, VIF) rst_mon_t;
  typedef smtdv_reset_model #(ADDR_WIDTH, DATA_WIDTH, VIF) rst_model_t;

  rst_model_t rst_model;

  `uvm_component_param_utils_begin(rst_mon_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_reset_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern virtual function void set_rst_model(rst_model_t rst_model);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset_phase(uvm_phase phase);

endclass

/**
 *  set rst_model to reset monitor
 */
function void smtdv_reset_monitor::set_rst_model(rst_model_t rst_model);
  this.rst_model= rst_model;
endfunction : set_rst_model

/**
 * check rst_model is already set
 */
function void  smtdv_reset_monitor::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  if(rst_model == null) begin
    if(!uvm_config_db#(rst_model_t)::get(this, "", "rst_model", rst_model))
      `uvm_fatal("NO_RST_MODEL", {"a reset model should be set for: ", get_full_name(), ".rst_model"});
    end
endfunction : end_of_elaboration_phase

/**
 * do reset while resetn assert, support HW_RST, SW_RST,
 */
task smtdv_reset_monitor::run_phase(uvm_phase phase);
  smtdv_reset_comp_group rst_grp;

  fork
    super.run_phase(phase);
    join_none

  if((vif.POLARITY && !vif.rst) || (!vif.POLARITY && vif.rst)) begin
    if(vif.POLARITY)
      @(posedge vif.rst);
    else
      @(negedge vif.rst);

    if(rst_model.rst_typ inside {HW_RST, ALL_RST}) begin
      rst_grp= rst_model.get_rst_grp(rst_model.get_name(), HW_RST);
      rst_grp.hw_reset();
      end
    else begin
      rst_grp= rst_model.get_rst_grp(rst_model.get_name(), SW_RST);
      rst_grp.sw_reset();
      end
    end
  `uvm_info(get_full_name(), "wating for PWR RESET deasserted ...", UVM_LOW)
  @(posedge pwrst_done);
  `uvm_info(get_full_name(), "Detect PWR RESET deasserted ...", UVM_LOW)
endtask : run_phase

/**
 * do reset assert/deassert
 */
task smtdv_reset_monitor::reset_phase(uvm_phase phase);
  fork
    super.reset_phase(phase);
    join_none

  phase.raise_objection(this);
  if((!vif.POLARITY && !vif.rst) || (vif.POLARITY && vif.rst)) begin
    `uvm_info(get_full_name(), "Detect RESET asserted ...", UVM_LOW)

    if(vif.POLARITY)
      @(negedge vif.rst);
    else
      @(posedge vif.rst);

    `uvm_info(get_full_name(), "Detect RESET deasserted ...", UVM_LOW)
    end
  phase.drop_objection(this);
endtask : reset_phase


`endif // end of __SMTDV_RESET_MONITOR_SV__
