`ifndef __APB_HIJACK_TEST_SV__
`define __APB_HIJACK_TEST_SV__

//IUS doesn't support it
//typedef class apb_base_test;
//typedef class apb_slave_base_seq;
//typedef class apb_slave_hijack_seq;

// check force method can been relased while slave is running into normal behavior
// mode
class apb_hijack_test
  extends
  apb_base_test;

  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;
  typedef apb_slave_hijack_seq#(ADDR_WIDTH, DATA_WIDTH) s_cseq_t;
  typedef apb_master_stl_vseq m_vseq_t;

  `uvm_component_utils(apb_hijack_test)

  function new(string name = "apb_hijack_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // override slave base seq to err_inject seq
    //set_type_override_by_type(s_bseq_t::get_type(), s_cseq_t::get_type());

    super.build_phase(phase);

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "vseqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*slv_agts[*0]*.seqr.run_phase",
      "default_sequence",
      s_cseq_t::type_id::get());

    // override err to warning, while relase the forcing vif driven
    foreach(cmp_envs[i]) begin
      foreach(cmp_envs[i].mst_scbs[j]) begin
        uvm_top.set_report_severity_id_override(UVM_ERROR, cmp_envs[i].mst_scbs[j].get_full_name(), UVM_WARNING);
      end
    end

    uvm_top.set_report_severity_id_override(UVM_ERROR, "SMTDV_BKDOR_CMP", UVM_WARNING);
    uvm_top.set_report_severity_id_override(UVM_ERROR, "SMTDV_SCB_RD_COMP", UVM_WARNING);
    uvm_top.set_report_severity_id_override(UVM_ERROR, "SMTDV_SCB_WR_COMP", UVM_WARNING);
    uvm_top.set_report_severity_id_override(UVM_ERROR, "SMTDV_SCB_RD_NOT", UVM_WARNING);
    uvm_top.set_report_severity_id_override(UVM_ERROR, "SMTDV_SCB_WR_NOT", UVM_WARNING);

    uvm_top.set_timeout(1000ns);
    uvm_top.set_report_severity_id_override(UVM_FATAL, "PH_TIMEOUT", UVM_WARNING);

  endfunction : build_phase


  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    cmp_envs[0].slv_agts[0].cfg.has_error = FALSE;
    cmp_envs[0].slv_agts[1].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase


endclass : apb_hijack_test

`endif // end of __APB_HIJACK_TEST_SV__
