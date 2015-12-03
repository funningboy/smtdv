`ifndef __APB_TYPEDEFS_SV__
`define __APB_TYPEDEFS_SV__

`define APB_DEBUG true

typedef enum bit [0:0] {OK, ERR} trx_rsp_t;

`define APB_ADDR_WIDTH 32
`define APB_DATA_WIDTH 32
`define APB_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)
`define APB_PARAMETER2 #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS)

`define APB_RST_VIF virtual interface smtdv_gen_rst_if #("apb_rst_if", 100, 0)

`define APB_VIF virtual interface apb_if `APB_PARAMETER
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
`define APB_SLAVE_BASE_RESP_SEQ apb_slave_base_resp_seq `APB_PARAMETER
`define APB_SLAVE_ERR_INJECT_SEQ apb_slave_err_inject_seq `APB_PARAMETER
`define APB_SLAVE_HIJACK_SEQ apb_slave_hijack_seq `APB_PARAMETER

`define APB_MASTER_BASE_SEQ apb_master_base_seq `APB_PARAMETER
`define APB_MASTER_1W_SEQ apb_master_1w_seq `APB_PARAMETER
`define APB_MASTER_1R_SEQ apb_master_1r_seq `APB_PARAMETER
`define APB_MASTER_1W1R_SEQ apb_master_1w1r_seq `APB_PARAMETER
`define APB_MASTER_RAND_SEQ apb_master_rand_seq `APB_PARAMETER
`define APB_MASTER_STL_SEQ apb_master_stl_seq `APB_PARAMETER

// UVM ref flow define
`define READ_BYTE_SEQ read_byte_seq `APB_PARAMETER
`define WRITE_BYTE_SEQ write_byte_seq `APB_PARAMETER
`define READ_WORD_SEQ read_word_seq `APB_PARAMETER
`define WRITE_WORD_SEQ write_word_seq `APB_PARAMETER
`define READ_DWORD_SEQ read_dword_seq `APB_PARAMETER
`define WRITE_DWORD_SEQ write_dword_seq `APB_PARAMETER
`define READ_AFTER_WRITE_SEQ read_after_write_seq `APB_PARAMETER
`define MULTIPLE_READ_AFTER_WRITE_SEQ multiple_read_after_write_seq `APB_PARAMETER

`define SIMPLE_RESPONSE_SEQ simple_response_seq `APB_PARAMETER
`define MEM_RESPONSE_SEQ mem_response_seq `APB_PARAMETER

`define APB_ENV apb_env
`define APB_BASE_SCOREBOARD apb_base_scoreboard `APB_PARAMETER2
`define APB_MEM_BKDOR_WR_COMP apb_mem_bkdor_wr_comp `APB_PARAMETER2
`define APB_MEM_BKDOR_RD_COMP apb_mem_bkdor_rd_comp `APB_PARAMETER2
`define APB_BUS_BACKDOOR apb_bus_backdoor `APB_PARAMETER
`define APB_MEM_BACKDOOR apb_mem_backdoor `APB_PARAMETER


`define APB_BASE_TEST apb_base_test
`define APB_1W1R_TEST apb_1w1r_test
`define APB_RAND_TEST apb_rand_test
`define APB_CSIM_TEST apb_csim_test
`define APB_STL_TEST apb_stl_test
`define APB_ERR_INJECT_TEST apb_err_inject_test
`define APB_HIJACK_TEST apb_hijack_test

`define APB_REG_ADAPTER apb_reg_adapter

// for DEBUG only, add addr map should be registered to map table
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

`endif
