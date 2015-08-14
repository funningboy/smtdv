`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32
`define APB_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)

`define APB_RST_VIF virtual smtdv_gen_rst_if #("apb_rst_if", 5000, 0)

`define APB_VIF virtual apb_if `APB_PARAMETER
`define APB_ITEM apb_item `APB_PARAMETER

`define APB_MONITOR apb_monitor `APB_PARAMETER

`define APB_COLLECT_WRITE_ITEMS apb_collect_write_items `APB_PARAMETER
`define APB_COLLECT_READ_ITEMS apb_collect_read_items `APB_PARAMETER
`define APB_COLLECT_STOP_SIGNAL apb_collect_stop_signal `APB_PARAMETER
`define APB_COLLECT_COVER_GROUP apb_collect_cover_group `APB_PARAMETER
`define APB_EXPORT_COLLECTED_ITEMS apb_export_collected_items `APB_PARAMETER

`define APB_DRIVE_WRITE_ITEMS apb_drive_write_items `APB_PARAMETER
`define APB_DRIVE_READ_ITEMS apb_drive_read_items `APB_PARAMETER

`define APB_SLAVE_DRIVE_ITEMS apb_slave_drive_items `APB_PARAMETER
`define APB_SLAVE_DRIVE_ACK apb_slave_drive_ack `APB_PARAMETER
`define APB_MASTER_DRIVE_ITEMS apb_master_drive_items `APB_PARAMETER

`define APB_SLAVE_CFG apb_slave_cfg
`define APB_SLAVE_AGENT apb_slave_agent `APB_PARAMETER
`define APB_SLAVE_DRIVER apb_slave_driver `APB_PARAMETER
`define APB_SLAVE_SEQUENCER apb_slave_sequencer `APB_PARAMETER

`define APB_MAP_SLAVE_CFG apb_map_slave_cfg
`define APB_MASTER_CFG apb_master_cfg
`define APB_MASTER_AGENT apb_master_agent `APB_PARAMETER
`define APB_MASTER_DRIVER apb_master_driver `APB_PARAMETER
`define APB_MASTER_SEQUENCER apb_master_sequencer `APB_PARAMETER

`define APB_SLAVE_BASE_SEQ apb_slave_base_seq `APB_PARAMETER

`define APB_MASTER_BASE_SEQ apb_master_base_seq `APB_PARAMETER
`define APB_MASTER_1W1R_SEQ apb_master_1w1r_seq `APB_PARAMETER
`define APB_MASTER_RAND_SEQ apb_master_rand_seq `APB_PARAMETER

`define APB_BASE_TEST apb_base_test
`define APB_1W1R_TEST apb_1w1r_test
`define APB_RAND_TEST apb_rand_test
`define APB_CSIM_TEST apb_csim_test
