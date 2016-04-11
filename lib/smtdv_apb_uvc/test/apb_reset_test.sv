`ifndef __APB_RESET_TEST_SV__
`define __APB_RESET_TEST_SV__

//typedef class apb_base_test;
//typedef class apb_master_stl_seq;

class apb_reset_test
  extends
  apb_base_test;

  typedef apb_reset_test test_t;
  typedef apb_master_reset_vseq m_vseq_t;
  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  `uvm_component_utils(apb_reset_test)

  function new(string name = "apb_reset_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "vseqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

   uvm_config_db#(uvm_object_wrapper)::set(this,
      "*slv_agts[*0]*.seqr.run_phase",
      "default_sequence",
      s_bseq_t::type_id::get());

    uvm_top.set_timeout(1000ns);
    uvm_top.set_report_severity_id_override(UVM_FATAL, "PH_TIMEOUT", UVM_WARNING);

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
  endfunction : end_of_elaboration_phase

//  check trx with sqlite3 db
endclass : apb_reset_test


`endif // __APB_RESET_TEST_SV__

