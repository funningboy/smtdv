
// for DEBUG only, add addr map should be registered to map table
`define APB_DEBUG true
`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32

`define APB_SLAVE_START_ADDR_0 'h1000_0000
`define APB_SLAVE_END_ADDR_0   'h7fff_ffff
`define APB_SLAVE_START_ADDR_1 'h8000_0000
`define APB_SLAVE_END_ADDR_1   'hffff_ffff

bit [`APB_ADDR_WIDTH-1:0] apb_start_addr_t[] = {
  `APB_SLAVE_START_ADDR_0,
  `APB_SLAVE_START_ADDR_1
};

bit [`APB_ADDR_WIDTH-1:0] apb_end_addr_t[] = {
  `APB_SLAVE_END_ADDR_0,
  `APB_SLAVE_END_ADDR_1
};

`define APB_START_ADDR(i) \
  apb_start_addr_t[i];

`define APB_END_ADDR(i) \
  apb_end_addr_t[i];

`define APB_VIF virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)
`define APB_RST_VIF virtual interface smtdv_gen_rst_if#("apb_rst_if", 100, 0)
`define APBMASTERATTR(i) u_dut_1m2s.M[i].u_apb_master
`define APBSLAVEATTR(i)  u_dut_1m2s.S[i].u_apb_slave
`define APBMASTERIVF(i)  `APBMASTERATTR(i).apb_master_if_harness.vif
`define APBSLAVEVIF(i)   `APBSLAVEATTR(i).apb_slave_if_harness.vif


