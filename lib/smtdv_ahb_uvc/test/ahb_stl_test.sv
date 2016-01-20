
`ifndef __AHB_STL_TEST_SV__
`define __AHB_STL_TEST_SV__

//IUS doesn't support it
//typedef class ahb_base_test;
//typedef class ahb_master_stl_seq;

class ahb_stl_test
  extends
  ahb_base_test;

  typedef ahb_stl_test test_t;
  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) m_seq_t;
  typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  `uvm_component_utils(ahb_stl_test)

  function new(string name = "ahb_stl_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      m_seq_t::type_id::get());

   uvm_config_db #(uvm_object_wrapper)::set(this,
      "*slave_agent[*0]*.seqr.run_phase",
      "default_sequence",
      s_bseq_t::type_id::get());

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    master_agent[0].cfg.has_busy = FALSE;

    slave_agent[0].cfg.has_error = FALSE;
    slave_agent[0].cfg.has_retry = FALSE;
    slave_agent[0].cfg.has_split = FALSE;
  endfunction : end_of_elaboration_phase

//  check trx with sqlite3 db
endclass : ahb_stl_test

`endif // end of __AHB_STL_TEST_SV__

