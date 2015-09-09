
  `define AHBMASTERATTR(i) u_dut_1m1s.M[i].u_ahb_master
  `define AHBSLAVEATTR(i) u_dut_1m1s.S[i].u_ahb_slave
  `define AHBMASTERVIF(i) `AHBMASTERATTR(i).ahb_master_if_harness.vif
  `define AHBSLAVEVIF(i)  `AHBSLAVEATTR(i).ahb_slave_if_harness.vif


