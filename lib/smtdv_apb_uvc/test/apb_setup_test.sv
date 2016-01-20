
`ifndef __APB_SETUP_TEST_SV__
`define __APB_SETUP_TEST_SV__

//IUS doesn't support it
//typedef class apb_base_test;
//typedef class apb_master_1w1r_vseq;
//typedef class apb_slave_base_seq;

class apb_setup_test
  extends
  apb_base_test;

  typedef apb_setup_test test_t;
  typedef apb_master_1w1r_vseq#(ADDR_WIDTH, DATA_WIDTH) m_vseq_t;
  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_seq_t;

  `uvm_component_utils(apb_setup_test)

  function new(string name = "apb_inject_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

   uvm_config_db#(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*slave_agent[*0]*.seqr.run_phase",
      "default_sequence",
      s_seq_t::type_id::get());

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    slave_agent[0].cfg.has_error = FALSE;
    slave_agent[1].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase

endclass : apb_setup_test

`endif // __APB_SETUP_TEST_SV__
