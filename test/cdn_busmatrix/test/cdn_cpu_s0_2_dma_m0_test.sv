`ifndef __CDN_CPU_S0_2_DMA_M0_TEST_SV__
`define __CDN_CPU_S0_2_DMA_M0_TEST_SV__

class cdn_cpu_s0_2_dma_m0_test
  extends
  `CDN_BASE_TEST;

  `uvm_component_utils(`CDN_CPU_S0_2_DMA_M0_TEST)

  // top seqr
  function new(string name = "cdn_cpu_s0_2_dma_m0_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // set type override
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*m_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `CDN_CPU_S0_STL_SEQ::type_id::get());

//    uvm_config_db #(uvm_object_wrapper)::set(this,
//      "m_agent[*1]*.seqr.run_phase",
//      "default_sequence",
//      `CDM_SRAM_S1_STL_SEQ::type_id::get());

  endfunction

endclass

`endif // __CDN_CPU_S0_2_DMA_M0_TEST_SV__

