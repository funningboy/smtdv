
`ifndef __AHB_SETUP_TEST_SV__
`define __AHB_SETUP_TEST_SV__

//IUS doesn't support it
//typedef class ahb_base_test;
//typedef class ahb_master_1w1r_vseq;
//typedef class ahb_slave_base_seq;

class ahb_setup_test
  extends
  ahb_base_test;

  typedef ahb_setup_test test_t;
  typedef ahb_master_1w1r_vseq#(ADDR_WIDTH, DATA_WIDTH) m_vseq_t;
  typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_seq_t;

  `uvm_component_utils(ahb_setup_test)

  function new(string name = "ahb_setup_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

   uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*slave_agent[*0]*.seqr.run_phase",
      "default_sequence",
      s_seq_t::type_id::get());

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    master_agent[0].cfg.has_busy = FALSE;

    slave_agent[0].cfg.has_error = FALSE;
    slave_agent[0].cfg.has_retry = FALSE;
    slave_agent[0].cfg.has_split = FALSE;
  endfunction : end_of_elaboration_phase

endclass : ahb_setup_test

`endif // __AHB_SETUP_TEST_SV__
