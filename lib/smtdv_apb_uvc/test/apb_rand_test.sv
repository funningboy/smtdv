
`ifndef __APB_RAND_TEST_SV__
`define __APB_RAND_TEST_SV__

//IUS doesn't support it
//typedef class apb_base_test;
//typedef class apb_master_rand_vseq;
//typedef class apb_slave_base_seq;


class apb_rand_test
  extends
  apb_base_test;

  typedef apb_rand_test test_t;
  typedef apb_master_rand_vseq#(ADDR_WIDTH, DATA_WIDTH) m_vseq_t;
  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  `uvm_component_utils(apb_rand_test)

  function new(string name = "apb_rand_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

   uvm_config_db #(uvm_object_wrapper)::set(this,
      "*slave_agent[*0]*.seqr.run_phase",
      "default_sequence",
      s_bseq_t::type_id::get());
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    slave_agent[0].cfg.has_error = FALSE;
    slave_agent[1].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase

//  check trx with sqlite3 db
endclass : apb_rand_test


`endif // end of __APB_RAND_TEST_SV__
