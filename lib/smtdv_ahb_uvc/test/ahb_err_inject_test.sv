`ifndef __AHB_ERR_INJECT_TEST_SV__
`define __AHB_ERR_INJECT_TEST_SV__

//IUS doesn't support it
//typedef class ahb_base_test;
//typedef class ahb_slave_err_inject_seq;
//typedef class ahb_slave_base_seq;
//typedef class ahb_master_stl_seq;


class ahb_err_inject_test
  extends
  ahb_base_test;

  typedef ahb_err_inject_test test_t;
  typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;
  typedef ahb_slave_err_inject_seq#(ADDR_WIDTH, DATA_WIDTH) s_cseq_t;
  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) m_seq_t;

  `uvm_component_utils(ahb_err_inject_test)

  function new(string name = "ahb_inject_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // override slave base seq to err_inject seq
    //set_type_override_by_type(s_bseq_t::get_type(), s_cseq_t::get_type());

    super.build_phase(phase);

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      m_seq_t::type_id::get());

   uvm_config_db #(uvm_object_wrapper)::set(this,
      "*slave_agent[*0]*.seqr.run_phase",
      "default_sequence",
      s_cseq_t::type_id::get());

    // override err to warning
    foreach(master_scb[i]) begin
      uvm_top.set_report_severity_id_override(UVM_ERROR, master_scb[i].get_full_name(), UVM_WARNING);
      uvm_top.set_report_severity_id_override(UVM_ERROR, "SMTDV_BKDOR_CMP", UVM_WARNING);
    end

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    slave_agent[0].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase

endclass : ahb_err_inject_test

`endif // end of __AHB_ERR_INJECT_TEST_SV__
