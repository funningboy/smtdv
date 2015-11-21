
`ifndef __CDN_TYPEDEFS_SV__
`define __CDN_TYPEDEFS_SV__

`include "bm_params.v"

// extend/override local AHB to ahb_pkg
`ifdef AHB_PARAMETER
  `undef AHB_PARAMETER
`endif
`define AHB_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)

`ifdef AHB_SLAVE_AGENT
  `undef AHB_SLAVE_AGENT
`endif
`define AHB_SLAVE_AGENT ahb_pkg::ahb_slave_agent `AHB_PARAMETER

`ifdef AHB_SLAVE_CFG
  `undef AHB_SLAVE_CFG
`endif
`define AHB_SLAVE_CFG   ahb_pkg::ahb_slave_cfg

`ifdef AHB_SLAVE_SEQUENCER
  `undef AHB_SLAVE_SEQUENCER
`endif
`define AHB_SLAVE_SEQUENCER ahb_pkg::ahb_slave_sequencer `AHB_PARAMETER

`ifdef AHB_SLAVE_BASE_SEQ
  `undef AHB_SLAVE_BASE_SEQ
`endif
`define AHB_SLAVE_BASE_SEQ ahb_pkg::ahb_slave_base_seq `AHB_PARAMETER

`ifdef AHB_MASTER_AGENT
  `undef AHB_MASTER_AGENT
`endif
`define AHB_MASTER_AGENT ahb_pkg::ahb_master_agent `AHB_PARAMETER

`ifdef AHB_MASTER_CFG
  `undef AHB_MASTER_CFG
`endif
`define AHB_MASTER_CFG ahb_pkg::ahb_master_cfg

`ifdef AHB_MASTER_SEQUENCER
  `undef AHB_MASTER_SEQUENCER
`endif
`define AHB_MASTER_SEQUENCER ahb_pkg::ahb_master_sequencer `AHB_PARAMETER

`ifdef AHB_MASTER_STL_SEQ
  `undef AHB_MASTER_STL_SEQ
`endif
`define AHB_MASTER_STL_SEQ ahb_pkg::ahb_master_stl_seq `AHB_PARAMETER

`ifdef AHB_COLLECT_COVER_GROUP
  `undef AHB_COLLECT_COVER_GROUP
`endif
`define AHB_COLLECT_COVER_GROUP ahb_pkg::ahb_collect_cover_group `AHB_PARAMETER

`ifdef AHB_ENV
  `undef AHB_ENV
`endif
`define AHB_ENV ahb_pkg::ahb_env

// override ahb_pkg::start_addr and end_addr
`ifdef AHB_ADDR_WIDTH
  `undef AHB_ADDR_WIDTH
`endif
`define AHB_ADDR_WIDTH 32

`ifndef AHB_DATA_WIDTH
  `undef AHB_DATA_WIDTH
`endif
`define AHB_DATA_WIDTH 32

`define APB_ENB apb_pkg::apb_env

`define CDN_AHB_ENV cdn_ahb_env
`define CDN_APB_ENV cdn_apb_env
`define CDN_OCP_ENV cdn_ocp_env
`define CDN_BUSMATRIX_ENV cdn_busmatrix_env

`define CDN_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)

`define CDN_RST_VIF virtual smtdv_gen_rst_if #("cdn_rst_if", 100, 0)

`define CDN_DMA_M0_CFG cdn_dma_m0_cfg
`define CDN_CPU_M1_CFG cdn_cpu_m1_cfg
`define CDN_MACB0_M2_CFG cdn_macb0_m2_cfg
`define CDN_MACB1_M3_CFG cdn_macb1_m3_cfg
`define CDN_MACB2_M4_CFG cdn_macb2_m4_cfg
`define CDN_MACB3_M5_CFG cdn_macb3_m5_cfg

`define CDN_DMA_M0_AGENT cdn_dma_m0_agent `CDN_PARAMETER
`define CDN_CPU_M1_AGENT cdn_cpu_m1_agent `CDN_PARAMETER
`define CDN_MACB0_M2_AGENT cdn_macb0_m2_agent `CDN_PARAMETER
`define CDN_MACB1_M3_AGENT cdn_macb1_m3_agent `CDN_PARAMETER
`define CDN_MACB2_M4_AGENT cdn_macb2_m4_agnet `CDN_PARAMETER
`define CDN_MACB3_M5_AGENT cdn_macb3_m5_agent `CDN_PARAMETER

`define CDN_DMA_M0_COVER_GROUP cdn_dma_m0_cover_group `CDN_PARAMETER
`define CDN_CPU_M1_COVER_GROUP cdn_cpu_m1_cover_group `CDN_PARAMETER
`define CDN_MACB0_M2_COVER_GROUP cdn_cpu_m2_cover_group `CDN_PARAMETER
`define CDN_MACB1_M3_COVER_GROUP cdn_macb1_m3_cover_group `CDN_PARAMETER
`define CDN_MACB2_M4_COVER_GROUP cdn_macb2_m4_cover_group `CDN_PARAMETER
`define CDN_MACB3_M5_COVER_GROUP cdn_macb3_m5_cover_group `CDN_PARAMETER

`define CDN_DMA_M0_BASIC_SEQ cdn_dma_m0_basic_seq `CDN_PARAMETER
`define CDN_CPU_M1_BASIC_SEQ cdn_cpu_m1_basic_seq `CDN_PARAMETER

`define CDN_CPU_S0_CFG cdn_cpu_s0_cfg
`define CDN_SRAM_S1_CFG cdn_sram_s1_cfg
`define CDN_ROM_S2_CFG cdn_rom_s2_cfg
`define CDN_AHB2APB0_S3_CFG cdn_ahb2pab0_s3_cfg
`define CDN_SMC_S4_CFG cdn_smc_s4_cfg
`define CDN_DMA_S5_CFG cdn_dma_s5_cfg
`define CDN_AHB2APB1_S6_CFG cdn_ahb2apb1_s6_cfg
// s7??
`define CDN_AHB2OCP_S8_CFG cdn_ahb2ocp_s8_cfg

`define CDN_CPU_S0_AGENT cdn_cpu_s0_agent `CDN_PARAMETER
`define CDN_SRAM_S1_AGENT cdn_sram_s1_agent `CDN_PARAMETER
`define CDN_ROM_S2_AGENT cdn_rom_s2_agent `CDN_PARAMETER
`define CDN_AHB2APB0_S3_AGENT cdn_ahb2apb0_s3_agent `CDN_PARAMETER
`define CDN_SMC_S4_AGENT cdn_smc_s4_agent `CDN_PARAMETER
`define CDN_DMA_S5_AGENT cdn_dma_s5_agent `CDN_PARAMETER
`define CDN_AHB2APB1_S6_AGENT cdn_ahb2apb1_s6_agent `CDN_PARAMETER
// s7 ???
`define CDN_AHB2OCP_S8_AGENT cdn_ahb2ocp_s8_agent `CDN_PARAMETER

`define CDN_CPU_S0_COVER_GROUP cdn_cpu_s0_cover_group `CDN_PARAMETER
`define CDN_SRAM_S1_COVER_GROUP cdn_sram_s1_cover_group `CDN_PARAMETER
`define CDN_ROM_S2_COVER_GROUP cdn_rom_s2_cover_group `CDN_PARAMETER
`define CDN_AHB2APB0_S3_COVER_GROUP cdn_ahb2apb0_s3_cover_group `CDN_PARAMETER
`define CDN_SMC_S4_COVER_GROUP cdn_smc_s4_cover_group `CDN_PARAMETER
`define CDN_DMA_S5_COVER_GROUP cdn_dma_s5_cover_group `CDN_PARAMETER
`define CDN_AHB2APB1_S6_AGENT cdn_ahb2apb1_s6_agent `CDN_PARAMETER
// s7 ???
`define CDN_AHB2OCP_S8_AGENT cdn_ahb2ocp_s8_agent `CDN_PARAMETER

`define CDN_CPU_S0_STL_SEQ cdn_cpu_s0_stl_seq `CDN_PARAMETER
`define CDN_SRAM_S1_STL_SEQ cdn_sram_s1_stl_seq `CDN_PARAMETER

`define CDN_BASE_TEST cdn_base_test
`define CDN_CPU_S0_2_DMA_M0_TEST cdn_cpu_s0_2_dma_m0_test

`define CDN_CLUSTER0 cdn_cluster0
`define CDN_CLUSTER1 cdn_cluster1

`endif
