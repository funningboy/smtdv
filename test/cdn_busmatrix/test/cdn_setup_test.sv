
`ifndef __CDN_SETUP_TEST_SV__
`define __CDN_SETUP_TEST_SV__

//typedef class cdn_base_test;

class cdn_setup_test
  extends
  cdn_base_test;

  typedef cdn_setup_test test_t;
  typedef cdn_master_stl_vseq m_vseq_t;
  typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_seq_t;

  `uvm_component_utils(cdn_setup_test)

  function new(string name = "apb_setup_test", uvm_component parent=null);
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
      s_seq_t::type_id::get());

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*.slv_agts[*1]*.seqr.run_phase",
      "default_sequence",
      s_seq_t::type_id::get());

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    clus0.slv_agts[0].cfg.has_error = FALSE;
    clus0.slv_agts[1].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase

endclass : cdn_setup_test

`endif // __CDN_SETUP_TEST_SV__
