`ifndef __XBUS_TYPEDEFS_SV__
`define __XBUS_TYPEDEFS_SV__

`define DEBUG true

`define XBUS_ADDR_WIDTH 32
`define XBUS_DATA_WIDTH 32
`define XBUS_BYTEN_WIDTH 4
`define XBUS_PARAMETER #(ADDR_WIDTH, BYTEN_WIDTH, DATA_WIDTH)

`define XBUS_RST_VIF virtual smtdv_gen_rst_if #("xbus_rst_if", 100, 0)

`define XBUS_VIF virtual xbus_if `XBUS_PARAMETER
`define XBUS_ITEM xbus_item `XBUS_PARAMETER

`define XBUS_MONITOR xbus_monitor `XBUS_PARAMETER

`define XBUS_COLLECT_WRITE_ITEMS xbus_collect_write_items `XBUS_PARAMETER
`define XBUS_COLLECT_READ_ITEMS xbus_collect_read_items `XBUS_PARAMETER
`define XBUS_COLLECT_STOP_SIGNAL xbus_collect_stop_signal `XBUS_PARAMETER
`define XBUS_COLLECT_COVER_GROUP xbus_collect_cover_group `XBUS_PARAMETER
`define XBUS_EXPORT_COLLECTED_ITEMS xbus_export_collected_items `XBUS_PARAMETER

`define XBUS_DRIVE_WRITE_ITEMS xbus_drive_write_items `XBUS_PARAMETER
`define XBUS_DRIVE_READ_ITEMS xbus_drive_read_items `XBUS_PARAMETER

`define XBUS_SLAVE_DRIVE_ITEMS xbus_slave_drive_items `XBUS_PARAMETER
`define XBUS_SLAVE_DRIVE_ACK xbus_slave_drive_ack `XBUS_PARAMETER
`define XBUS_MASTER_DRIVE_ITEMS xbus_master_drive_items `XBUS_PARAMETER

`define XBUS_SLAVE_CFG xbus_slave_cfg
`define XBUS_SLAVE_AGENT xbus_slave_agent `XBUS_PARAMETER
`define XBUS_SLAVE_DRIVER xbus_slave_driver `XBUS_PARAMETER
`define XBUS_SLAVE_SEQUENCER xbus_slave_sequencer `XBUS_PARAMETER

`define XBUS_MASTER_CFG xbus_master_cfg
`define XBUS_MASTER_AGENT xbus_master_agent `XBUS_PARAMETER
`define XBUS_MASTER_DRIVER xbus_master_driver `XBUS_PARAMETER
`define XBUS_MASTER_SEQUENCER xbus_master_sequencer `XBUS_PARAMETER

`define XBUS_SLAVE_BASE_SEQ xbus_slave_base_seq `XBUS_PARAMETER

`define XBUS_MASTER_BASE_SEQ xbus_master_base_seq `XBUS_PARAMETER
`define XBUS_MASTER_1W_SEQ xbus_master_1w_seq `XBUS_PARAMETER
`define XBUS_MASTER_1R_SEQ xbus_master_1r_seq `XBUS_PARAMETER
`define XBUS_MASTER_1W1R_SEQ xbus_master_1w1r_seq `XBUS_PARAMETER
`define XBUS_MASTER_RAND_SEQ xbus_master_rand_seq `XBUS_PARAMETER
`define XBUS_MASTER_STL_SEQ xbus_master_stl_seq `XBUS_PARAMETER

`define XBUS_BASE_TEST xbus_base_test
`define XBUS_1W1R_TEST xbus_1w1r_test
`define XBUS_RAND_TEST xbus_rand_test
`define XBUS_CSIM_TEST xbus_csim_test
`define XBUS_STL_TEST xbus_stl_test

// for DEBUG only, add addr map should be registered to map table
`define XBUS_SLAVE_START_ADDR_0 'h1000_0000
`define XBUS_SLAVE_END_ADDR_0   'h7fff_ffff
`define XBUS_SLAVE_START_ADDR_1 'h8000_0000
`define XBUS_SLAVE_END_ADDR_1   'hffff_ffff

bit [`XBUS_ADDR_WIDTH-1:0] xbus_start_addr_t[] = {
  `XBUS_SLAVE_START_ADDR_0,
  `XBUS_SLAVE_START_ADDR_1
};

bit [`XBUS_ADDR_WIDTH-1:0] xbus_end_addr_t[] = {
  `XBUS_SLAVE_END_ADDR_0,
  `XBUS_SLAVE_END_ADDR_1
};

`define XBUS_START_ADDR(i) \
  xbus_start_addr_t[i];

`define XBUS_END_ADDR(i) \
  xbus_end_addr_t[i];

`endif
