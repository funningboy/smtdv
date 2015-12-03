
`ifndef __SMTDV_RESET_MONITOR_SV__
`define __SMTDV_RESET_MONITOR_SV__

class smtdv_reset_monitor #(type VIF = virtual interface smtdv_gen_rst_if) extends smtdv_monitor#(VIF);

  smtdv_reset_model #(VIF) rst_model;

  `uvm_component_param_utils_begin(smtdv_reset_monitor#(VIF))
  `uvm_component_utils_end

  function new(string name = "smtdv_reset_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  extern virtual function void set_rst_model(smtdv_reset_model#(VIF) rst_model);

  extern virtual function void end_of_elaboration_phase(uvm_phase phase);

  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset_phase(uvm_phase phase);

endclass


function void smtdv_reset_monitor::set_rst_model(smtdv_reset_model#(VIF) rst_model);
  this.rst_model= rst_model;
endfunction


function void  smtdv_reset_monitor::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  if(rst_model == null) begin
    if(!uvm_config_db#(smtdv_reset_model #(VIF))::get(this, "", "rst_model", rst_model))
      `uvm_fatal("NO_RST_MODEL", {"a reset model should be set for: ", get_full_name(), ".rst_model"});
    end
endfunction


task smtdv_reset_monitor::run_phase(uvm_phase phase);
  reset_comp_group rst_grp;

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
endtask


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
endtask


`endif // end of __SMTDV_RESET_MONITOR_SV__
