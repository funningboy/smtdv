
`ifndef __CDN_BUSMATRIX_ENV_SV__
`define __CDN_BUSMATRIX_ENV_SV__

`include "bm_defs.v"

// cluster0 for all master UVC
class cdn_cluster0
  extends
    `AHB_ENV;

  `include "bm_params.v"

  `uvm_component_param_utils_begin(`CDN_CLUSTER0)
  `uvm_component_utils_end

  function new(string name = "cdn_cluster0", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // initiator to bus
    `ifdef SLAVE0 master_cfg.push_back(`CDN_CPU_S0_CFG::type_id::create({$psprintf("m_cfg[%0d]", 0)}, this)); `endif
//    `ifdef SLAVE1 master_cfg.push_back(`CDN_SRAM_S1_CFG::type_id::create({$psprintf("m_cfg[%0d]", 1)}, this)); `endif
//  `ifdef SLAVE2 master_cfg.push_back(`CDN_ROM_S2_CFG::type_id::create({$psprintf("m_cfg[%0d]", 2)}, this)); `endif
//  `ifdef SLAVE3 master_cfg.push_back(`CDN_AHB2APB0_S3_CFG::type_id::create({$psprintf("m_cfg[%0d]", 3)}, this)); `endif
//  `ifdef SLAVE4 master_cfg.push_back(`CDN_SMC_S4_CFG::type_id::create({$psprintf("m_cfg[%0d]", 4)}, this)); `endif
//  `ifdef SLAVE5 master_cfg.push_back(`CDN_DMA_S5_CFG::type_id::create({$psprintf("m_cfg[%0d]", 5)}, this)); `endif
//  `ifdef SLAVE6 master_cfg.push_back(`CDN_AHB2APB1_S6_CFG::type_id::create({$psprintf("m_cfg[%0d]", 6)}, this)); `endif
//  `ifdef SLAVE7 master_cfg.push_back(`CDN_AHB2OCP_S7_CFG::type_id::create($psprintf("m_cfg[%0d]", 7)}, this)); `endif

    foreach(master_cfg[i]) begin
      `SMTDV_RAND_WITH(master_cfg[i], {
        has_force == 1;
        has_coverage == 1;
        has_export == 1;
        has_busy == 1;
      })
      `ifdef SLAVE0 master_cfg[i].add_slave(slave_cfg[0], 0, SLAVE0_START_ADDR, SLAVE0_END_ADDR); `endif
//      `ifdef SLAVE1 master_cfg[i].add_slave(slave_cfg[1], 1, SLAVE1_START_ADDR, SLAVE1_END_ADDR); `endif
//      `ifdef SLAVE2 master_cfg[i].add_slave(slave_cfg[2], 2, SLAVE2_START_ADDR, SALBE2_END_ADDR); `endif
//      `ifdef SLAVE3 master_cfg[i].add_slave(slave_cfg[3], 3, SLAVE3_START_ADDR, SLAVE3_END_ADDR); `endif
//      `ifdef SLAVE4 master_cfg[i].add_slave(slave_cfg[4], 4, SLAVE4_START_ADDR, SLAVE4_END_ADDR); `endif
//      `ifdef SLAVE5 master_cfg[i].add_slave(slave_cfg[5], 5, SLAVE5_START_ADDR, SLAVE5_END_ADDR); `endif
//      `ifdef SLAVE6 master_cfg[i].add_slave(slave_cfg[6], 6, SLAVE6_START_ADDR, SLAVE6_END_ADDR); `endif
//      `ifdef SLAVE7 master_cfg[i].add_slave(slave_cfg[7], 7, SLAVE7_START_ADDR, SLAVE7_END_ADDR); `endif
    end

    `ifdef SLAVE0 master_agent.push_back(`CDN_CPU_S0_AGENT::type_id::create({$psprintf("m_agent[%0d]", 0)}, this)); `endif
//    `ifdef SLAVE1 master_agent.push_back(`CDN_SRAM_S1_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 1)}, this)); `endif
//    `ifdef SLAVE2 master_agent.push_back(`CDN_ROM_S2_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 2)}, this)); `endif
//    `ifdef SLAVE3 master_agent.push_back(`CDN_AHB2APB0_S3_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 3)}, this)); `endif
//    `ifdef SLAVE4 master_agent.push_back(`CDN_SMC_S4_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 4)}, this)); `endif
//    `ifdef SLAVE5 master_agent.push_back(`CDN_DMA_S5_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 5)}, this)); `endif
//    `ifdef SLAVE6 master_agent.push_back(`CDN_AHB2APB1_S6_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 6)}, this)); `endif
//    `ifdef SLAVE7 master_agent.push_back(`CDN_AHB2OCP_S7_AGENT::type_id::crteate({$psprintf("m_agent[%0d]", 7)}, this)); `endif

    foreach(master_agent[i]) begin
      uvm_config_db#(uvm_bitstream_t)::set(null, master_agent[i].get_full_name(), "is_active", UVM_ACTIVE);
      uvm_config_db#(`AHB_MASTER_CFG)::set(null, master_agent[i].get_full_name(), "cfg", master_cfg[i]);
    end

  endfunction

endclass


// cluster1 for all slave uvc
class cdn_cluster1
  extends
    `AHB_ENV;

  `include "bm_params.v"

  `uvm_component_param_utils_begin(`CDN_CLUSTER1)
  `uvm_component_utils_end

  function new(string name = "cdn_cluster1", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // target to bus
    `ifdef MASTER0 slave_cfg.push_back(`CDN_DMA_M0_CFG::type_id::create({$psprintf("s_cfg[%0d]", 0)}, this)); `endif
//    `ifdef MASTER1 slave_cfg.push_back(`CDN_CPU_M1_CFG::type_id::create({$psprintf("s_cfg[%0d]", 1)}, this)); `endif
//    `ifdef MASTER2 slave_cfg.push_back(`CDN_MACB0_M2_CFG::type_id::create({$psprintf("s_cfg[%0d]", 2)}, this)); `endif
//    `ifdef MASTER3 slave_cfg.push_back(`CDN_MACB1_M3_CFG::type_id::create({$psprintf("s_cfg[%0d]", 3)}, this)); `endif
//    `ifdef MASTER4 slave_cfg.push_back(`CDN_MACB2_M4_CFG::type_id::create({$psprintf("s_cfg[%0d]", 4)}, this)); `endif
//    `ifdef MASTER5 slave_cfg.push_back(`CDN_MACB3_M5_CFG::type_id::create({$psprintf("s_cfg[%0d]", 5)}, this)); `endif

    foreach(slave_cfg[i]) begin
      `SMTDV_RAND_WITH(slave_cfg[i], {
          has_force == 1;
          has_coverage == 1;
          has_export == 1;
          has_split == 0;
          has_error == 0;
          has_retry == 1;
      })
    end

    `ifdef MASTER0 slave_agent.push_back(`CDN_DMA_M0_AGENT::type_id::create({$psprintf("s_agent[%0d]", 0)}, this)); `endif
//    `ifdef MASTER1 slave_agent.push_back(`CDN_CPU_M1_AGENT::type_id::create({$psprintf("s_agent[%0d]", 1)}, this)); `endif
//  `ifdef MASTER2 slave_agent.push_back(`CDN_MACB0_M2_AGENT::type_id::create({$psprintf("s_agent[%0d]", 2)}, this)): `endif
//  `ifdef MASTER3 slave_agent.push_back(`CDN_MACB1_M3_AGENT::type_id::create({$psprintf("s_agent[%0d]", 3)}, this)); `endif
//  `ifdef MASTER4 slave_agent.push_back(`CDN_MACB2_M4_AGENT::type_id::create({$psprintf("s_agent[%0d]", 4)}, this)); `endif
//  `ifdef MASTER5 slave_agent.push_back(`CDN_MACB3_M5_AGENT::type_id::create({$psprintf("s_agent[%0d]", 5)}, this)); `endif

    foreach(slave_agent[i]) begin
      uvm_config_db#(uvm_bitstream_t)::set(null, slave_agent[i].get_full_name(), "is_active", UVM_ACTIVE);
      uvm_config_db#(`AHB_SLAVE_CFG)::set(null, slave_agent[i].get_full_name(), "cfg", slave_cfg[i]);
    end

  endfunction

endclass




`endif // __CDN_BUSMATRIX_ENV_SV__
