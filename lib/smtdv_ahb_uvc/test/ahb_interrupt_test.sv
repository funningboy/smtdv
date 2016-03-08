`ifndef __AHB_INTERRUPT_TEST_SV__
`define __AHB_INTERRUPT_TEST_SV__

class ahb_interrupt_test
  extends
  ahb_base_test;

  typedef ahb_interrupt_test test_t;
  typedef ahb_master_interrupt_vseq m_vseq_t;
  typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  `uvm_component_utils(ahb_interrupt_test)

  function new(string name = "ahb_stl_test", uvm_component parent=null);
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

  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    cmp_envs[0].slv_agts[0].cfg.has_error = FALSE;
  endfunction : end_of_elaboration_phase

endclass : ahb_interrupt_test

`endif // __AHB_INTERRUPT_TEST_SV__
