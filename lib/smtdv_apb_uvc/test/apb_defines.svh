
`define APBMASTERATTR(i) u_dut_1m2s.M[i].u_apb_master
`define APBSLAVEATTR(i)  u_dut_1m2s.S[i].u_apb_slave
`define APBMASTERIVF(i)  `APBMASTERATTR(i).apb_master_if_harness.vif
`define APBSLAVEVIF(i)   `APBSLAVEATTR(i).apb_slave_if_harness.vif


