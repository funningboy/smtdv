`ifndef __APB_RETRY_TEST_SV__
`define __APB_RETRY_TEST_SV__

//IUS doesn't support it
//typedef class apb_base_test;
//typedef class apb_master_retry_vseq;

class apb_retry_test
  extends
  apb_base_test;

  typedef apb_retry_test test_t;
  typedef apb_master_retry_vseq#(ADDR_WIDTH, DATA_WIDTH) m_vseq_t;
  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  `uvm_component_utils(apb_retry_test)

  function new(string name = "apb_retry_test", uvm_component parent=null);
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
      s_bseq_t::type_id::get());

  endfunction : build_phase

endclass : apb_retry_test


`endif // end of __APB_RETRY_TEST_SV__
