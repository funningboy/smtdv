
`ifndef __CDN_TYPEDEFS_SV__
`define __CDN_TYPEDEFS_SV__

`include "bm_params.v"
`include "override_typedefs.svh"

`define CDN_AHB_ENV cdn_ahb_env
`define CDN_APB_ENV cdn_apb_env
`define CDN_OCP_ENV cdn_ocp_env
`define CDN_BUSMATRIX_ENV cdn_busmatrix_env

`define CDN_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)

`define CDN_RST_VIF virtual interface smtdv_gen_rst_if #("cdn_rst_if", 100, 0)

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
