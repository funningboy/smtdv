
`ifndef __SMTDV_SETUP_TEST_SV__
`define __SMTDV_SETUP_TEST_SV__

class smtdv_setup_test
  extends
  smtdv_base_test;

  typedef smtdv_master_test_vseq m_vseq_t;
  typedef smtdv_slave_test_seq#(ADDR_WIDTH, DATA_WIDTH) s_seq_t;
  typedef uvm_object obj_t;

  obj_t obj;

  `uvm_component_utils(smtdv_setup_test)

  function new(string name = "smtdv_setup_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void do_test();
    $display("hello test");
  endfunction : do_test

  virtual function void build_phase(uvm_phase phase);
    // override slave base seq to err_inject seq
    //set_type_override_by_type(o_seq_t::get_type(), s_seq_t::get_type());
    super.build_phase(phase);

    // set default seq to seqr
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "vseqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*slv_agts[*0]*.seqr.run_phase",
      "default_sequence",
      s_seq_t::type_id::get());
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    obj = this;
    this.do_test();
  endtask : run_phase

endclass : smtdv_setup_test

`endif // __SMTDV_SETUP_TEST_SV__
