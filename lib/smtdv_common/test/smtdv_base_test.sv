`ifndef __SMTDV_BASE_TEST_SV__
`define __SMTDV_BASE_TEST_SV__

//typedef class smtdv_base_unittest;
//typedef class smtdv_master_test_seq;
//typedef class smtdv_slave_test_seq;

class smtdv_base_test
  extends
  smtdv_base_unittest;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef smtdv_base_test test_t;
  typedef smtdv_master_test_vseq#(ADDR_WIDTH, DATA_WIDTH) m_vseq_t;
  typedef smtdv_slave_test_seq#(ADDR_WIDTH, DATA_WIDTH) s_seq_t;

  `uvm_component_utils(smtdv_base_test)

  function new(string name = "smtdv_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // override slave base seq to err_inject seq
    //set_type_override_by_type(o_seq_t::get_type(), s_seq_t::get_type());

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

endclass : smtdv_base_test


`endif // __SMTDV_BASE_TEST_SV__
