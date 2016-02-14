

`ifndef __APB_POLLING_TEST_SV__
`define __APB_POLLING_TEST_SV__

//typedef class apb_base_test;
//typedef class apb_master_polling_vseq;

class apb_polling_test
  extends
  apb_base_test;

  typedef apb_polling_test test_t;
  typedef apb_master_polling_vseq m_vseq_t;
  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  `uvm_component_utils(apb_polling_test)

  function new(string name = "apb_polling_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "vseqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

   uvm_config_db #(uvm_object_wrapper)::set(this,
      "*slv_agts[*0]*.seqr.run_phase",
      "default_sequence",
      s_bseq_t::type_id::get());

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    cmp_envs[0].slv_agts[0].cfg.has_error = FALSE;
    cmp_envs[0].slv_agts[1].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase

//  check trx with sqlite3 db
endclass : apb_polling_test


`endif // __APB_POLLING_TEST_SV__
