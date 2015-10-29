
`ifndef __CDN_BASE_TEST_SV__
`define __CDN_BASE_TEST_SV__

`include "bm_defs.v"

class cdn_base_test
  extends
  smtdv_test;

  `include "bm_params.v"

  parameter ADDR_WIDTH = `AHB_ADDR_WIDTH;
  parameter DATA_WIDTH = `AHB_DATA_WIDTH;

  `CDN_RST_VIF cdn_rst_vif;
  smtdv_reset_model #(`CDN_RST_VIF) cdn_rst_model;

  `AHB_SLAVE_AGENT s_agent[$];
  `AHB_SLAVE_CFG s_cfg[$];

  `AHB_MASTER_AGENT m_agent[$];
  `AHB_MASTER_CFG m_cfg[$];

  `uvm_component_param_utils_begin(`CDN_BASE_TEST)
  `uvm_component_utils_end

  function new(string name = "cdn_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // target to bus
    `ifdef MASTER0 s_cfg.push_back(`CDN_DMA_M0_CFG::type_id::create({$psprintf("s_cfg[%0d]", 0)}, this)); `endif
    `ifdef MASTER0 s_cfg.push_back(`CDN_DMA_M0_CFG::type_id::create({$psprintf("s_cfg[%0d]", 0)}, this));  `endif
    `ifdef MASTER1 s_cfg.push_back(`CDN_CPU_M1_CFG::type_id::create({$psprintf("s_cfg[%0d]", 1)}, this)); `endif
    `ifdef MASTER2 s_cfg.push_back(`CDN_MACB0_M2_CFG::type_id::create({$psprintf("s_cfg[%0d]", 2)}, this)); `endif
    `ifdef MASTER3 s_cfg.push_back(`CDN_MACB1_M3_CFG::type_id::create({$psprintf("s_cfg[%0d]", 3)}, this)); `endif
    `ifdef MASTER4 s_cfg.push_back(`CDN_MACB2_M4_CFG::type_id::create({$psprintf("s_cfg[%0d]", 4)}, this)); `endif
    `ifdef MASTER5 s_cfg.push_back(`CDN_MACB3_M5_CFG::type_id::create({$psprintf("s_cfg[%0d]", 5)}, this)); `endif

    foreach(s_cfg[i]) begin
      `SMTDV_RAND_WITH(s_cfg[i], {
          has_force == 1;
          has_coverage == 1;
          has_export == 1;
          has_split == 0;
          has_error == 0;
          has_retry == 1;
      })
    end

    `ifdef MASTER0 s_agent.push_back(`CDN_DMA_M0_AGENT::type_id::create({$psprintf("s_agent[%0d]", 0)}, this)); `endif
//    `ifdef MASTER1 s_agent.push_back(`CDN_CPU_M1_AGENT::type_id::create({$psprintf("s_agent[%0d]", 1)}, this)); `endif
//  `ifdef MASTER2 s_agent.push_back(`CDN_MACB0_M2_AGENT::type_id::create({$psprintf("s_agent[%0d]", 2)}, this)): `endif
//  `ifdef MASTER3 s_agent.push_back(`CDN_MACB1_M3_AGENT::type_id::create({$psprintf("s_agent[%0d]", 3)}, this)); `endif
//  `ifdef MASTER4 s_agent.push_back(`CDN_MACB2_M4_AGENT::type_id::create({$psprintf("s_agent[%0d]", 4)}, this)); `endif
//  `ifdef MASTER5 s_agent.push_back(`CDN_MACB3_M5_AGENT::type_id::create({$psprintf("s_agent[%0d]", 5)}, this)); `endif

    foreach(s_agent[i]) begin
      uvm_config_db#(uvm_bitstream_t)::set(null, s_agent[i].get_full_name(), "is_active", UVM_ACTIVE);
      uvm_config_db#(`AHB_SLAVE_CFG)::set(null, s_agent[i].get_full_name(), "cfg", s_cfg[i]);
    end

    // initiator to bus
    `ifdef SLAVE0 m_cfg.push_back(`CDN_CPU_S0_CFG::type_id::create({$psprintf("m_cfg[%0d]", 0)}, this)); `endif
//  `ifdef SLAVE1 m_cfg.push_back(`CDN_SRAM_S1_CFG::type_id::create({$psprintf("m_cfg[%0d]", 1)}, this)); `endif
//  `ifdef SLAVE2 m_cfg.push_back(`CDN_ROM_S2_CFG::type_id::create({$psprintf("m_cfg[%0d]", 2)}, this)); `endif
//  `ifdef SLAVE3 m_cfg.push_back(`CDN_AHB2APB0_S3_CFG::type_id::create({$psprintf("m_cfg[%0d]", 3)}, this)); `endif
//  `ifdef SLAVE4 m_cfg.push_back(`CDN_SMC_S4_CFG::type_id::create({$psprintf("m_cfg[%0d]", 4)}, this)); `endif
//  `ifdef SLAVE5 m_cfg.push_back(`CDN_DMA_S5_CFG::type_id::create({$psprintf("m_cfg[%0d]", 5)}, this)); `endif
//  `ifdef SLAVE6 m_cfg.push_back(`CDN_AHB2APB1_S6_CFG::type_id::create({$psprintf("m_cfg[%0d]", 6)}, this)); `endif
//  `ifdef SLAVE7 m_cfg.push_back(`CDN_AHB2OCP_S7_CFG::type_id::create($psprintf("m_cfg[%0d]", 7)}, this)); `endif

    foreach(m_cfg[i]) begin
      `SMTDV_RAND_WITH(m_cfg[i], {
        has_force == 1;
        has_coverage == 1;
        has_export == 1;
        has_busy == 1;
      })
      `ifdef SLAVE0 m_cfg[i].add_slave(s_cfg[0], 0, SLAVE0_START_ADDR, SLAVE0_END_ADDR); `endif
      `ifdef SLAVE1 m_cfg[i].add_slave(s_cfg[1], 1, SLAVE1_START_ADDR, SLAVE1_END_ADDR); `endif
      `ifdef SLAVE2 m_cfg[i].add_slave(s_cfg[2], 2, SLAVE2_START_ADDR, SALBE2_END_ADDR); `endif
      `ifdef SLAVE3 m_cfg[i].add_slave(s_cfg[3], 3, SLAVE3_START_ADDR, SLAVE3_END_ADDR); `endif
      `ifdef SLAVE4 m_cfg[i].add_slave(s_cfg[4], 4, SLAVE4_START_ADDR, SLAVE4_END_ADDR); `endif
      `ifdef SLAVE5 m_cfg[i].add_slave(s_cfg[5], 5, SLAVE5_START_ADDR, SLAVE5_END_ADDR); `endif
      `ifdef SLAVE6 m_cfg[i].add_slave(s_cfg[6], 6, SLAVE6_START_ADDR, SLAVE6_END_ADDR); `endif
      `ifdef SLAVE7 m_cfg[i].add_slave(s_cfg[7], 7, SLAVE7_START_ADDR, SLAVE7_END_ADDR); `endif
    end

    `ifdef SLAVE0 m_agent.push_back(`CDN_CPU_S0_AGENT::type_id::create({$psprintf("m_agent[%0d]", 0)}, this)); `endif
    `ifdef SLAVE1 m_agent.push_back(`CDN_SRAM_S1_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 1)}, this)); `endif
    `ifdef SLAVE2 m_agent.push_back(`CDN_ROM_S2_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 2)}, this)); `endif
    `ifdef SLAVE3 m_agent.push_back(`CDN_AHB2APB0_S3_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 3)}, this)); `endif
    `ifdef SLAVE4 m_agent.push_back(`CDN_SMC_S4_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 4)}, this)); `endif
    `ifdef SLAVE5 m_agent.push_back(`CDN_DMA_S5_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 5)}, this)); `endif
    `ifdef SLAVE6 m_agent.push_back(`CDN_AHB2APB1_S6_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 6)}, this)); `endif
    `ifdef SLAVE7 m_agent.push_back(`CDN_AHB2OCP_S7_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 7)}, this)); `endif

    foreach(m_agent[i]) begin
      uvm_config_db#(uvm_bitstream_t)::set(null, m_agent[i].get_full_name(), "is_active", UVM_ACTIVE);
      uvm_config_db#(`AHB_MASTER_CFG)::set(null, m_agent[i].get_full_name(), "cfg", m_cfg[i]);
    end

    // resetn
    cdn_rst_model = smtdv_reset_model#(`CDN_RST_VIF)::type_id::create("cdn_rst_model");
    if(!uvm_config_db#(`CDN_RST_VIF)::get(this, "", "cdn_rst_vif", cdn_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".cdn_rst_vif"});
    cdn_rst_model.create_rst_monitor(cdn_rst_vif);

    //sqlite3
    smtdv_sqlite3::delete_db("cdn_busmatrix.db");
    smtdv_sqlite3::new_db("cdn_busmatrix.db");
  endfunction

 virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    cdn_rst_model.add_component(this);
    cdn_rst_model.set_rst_type(ALL_RST);
    cdn_rst_model.show_components(0);
  endfunction

endclass


`endif // __CDN_BASE_TEST_SV__
