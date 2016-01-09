
`ifndef __AHB_DEFINES_SVH__
`define __AHB_DEFINES_SVH__

`define AHB_DEBUG true
`define AHB_ADDR_WIDTH 32
`define AHB_DATA_WIDTH 32

// for DEBUG only, add addr map should be registered to map table
`define AHB_SLAVE_START_ADDR_0 'h1000_0000
`define AHB_SLAVE_END_ADDR_0   'h7fff_ffff
`define AHB_SLAVE_START_ADDR_1 'h8000_0000
`define AHB_SLAVE_END_ADDR_1   'hffff_ffff

bit [`AHB_ADDR_WIDTH-1:0] ahb_start_addr_t[] = {
  `AHB_SLAVE_START_ADDR_0,
  `AHB_SLAVE_START_ADDR_1
};

bit [`AHB_ADDR_WIDTH-1:0] ahb_end_addr_t[] = {
  `AHB_SLAVE_END_ADDR_0,
  `AHB_SLAVE_END_ADDR_1
};

`define AHB_START_ADDR(i) \
  ahb_start_addr_t[i];

`define AHB_END_ADDR(i) \
  ahb_end_addr_t[i];

`define AHBMASTERATTR(i) u_dut_1m1s.M[i].u_ahb_master
`define AHBSLAVEATTR(i) u_dut_1m1s.S[i].u_ahb_slave
`define AHBMASTERVIF(i) `AHBMASTERATTR(i).ahb_master_if_harness.vif
`define AHBSLAVEVIF(i)  `AHBSLAVEATTR(i).ahb_slave_if_harness.vif

`endif // __AHB_DEFINES_SVH__
