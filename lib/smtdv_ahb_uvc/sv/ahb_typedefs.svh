`ifndef __AHB_TYPEDEFS_SV__
`define __AHB_TYPEDEFS_SV__

`define AHB_DEBUG true

typedef enum bit [1:0] {IDLE, BUSY, NONSEQ, SEQ } trx_type_t;
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} bst_type_t;
typedef enum bit [2:0] {B8, B16, B32, B64, B128, B256, B512, B1024} trx_size_t;
typedef enum bit [1:0] {OKAY, ERROR, RETRY, SPLIT} trx_rsp_t;
typedef enum bit [3:0] {ST_IDLE, ST_REQBUS, ST_NOSEQ, ST_BUSY, ST_SEQ, ST_ERROR, ST_RETRY, ST_SPLIT, ST_NONE} fsm_state_t;

`define OPCODE_FETCH 4'bxxx0
`define DATA_ACCESS  4'bxxx1
`define USER_ACCESS  4'bxx0x
`define PRIVILEGED_ACCESS 4'bxx1x
`define NOT_BUFFERABLE 4'bx0xx
`define BUFFERABLE 4'bx1xx
`define NOT_CACHEABLE 4'b0xxx
`define CACHEABLE 4'b1xxx

bit[3:0] trx_prt_t[] = {
  `OPCODE_FETCH,
  `DATA_ACCESS,
  `USER_ACCESS,
  `PRIVILEGED_ACCESS,
  `NOT_BUFFERABLE,
  `BUFFERABLE,
  `NOT_CACHEABLE,
  `CACHEABLE
};

`define AHB_ADDR_WIDTH 32
`define AHB_DATA_WIDTH 32
`define AHB_PARAMETER #(ADDR_WIDTH, DATA_WIDTH)
`define AHB_PARAMETER2 #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS)

`define AHB_RST_VIF virtual smtdv_gen_rst_if #("ahb_rst_if", 100, 0)

`define AHB_VIF virtual ahb_if `AHB_PARAMETER
`define AHB_ITEM ahb_item `AHB_PARAMETER

`define AHB_MONITOR ahb_monitor `AHB_PARAMETER

`define AHB_COLLECT_COVER_GROUP ahb_collect_cover_group `AHB_PARAMETER
`define AHB_EXPORT_COLLECTED_ITEMS ahb_export_collected_items `AHB_PARAMETER
`define AHB_COLLECT_STOP_SIGNAL ahb_collect_stop_signal `AHB_PARAMETER
`define AHB_COLLECT_ADDR_ITEMS ahb_collect_addr_items `AHB_PARAMETER
`define AHB_COLLECT_DATA_ITEMS ahb_collect_data_items `AHB_PARAMETER

`define AHB_SLAVE_CFG ahb_slave_cfg
`define AHB_SLAVE_AGENT ahb_slave_agent `AHB_PARAMETER
`define AHB_SLAVE_DRIVER ahb_slave_driver `AHB_PARAMETER
`define AHB_SLAVE_SEQUENCER ahb_slave_sequencer `AHB_PARAMETER

`define AHB_SLAVE_DRIVE_ADDR ahb_slave_drive_addr `AHB_PARAMETER
`define AHB_SLAVE_DRIVE_DATA ahb_slave_drive_data `AHB_PARAMETER

`define AHB_MAP_SLAVE_CFG ahb_map_slave_cfg
`define AHB_MASTER_CFG ahb_master_cfg
`define AHB_MASTER_AGENT ahb_master_agent `AHB_PARAMETER
`define AHB_MASTER_DRIVER ahb_master_driver `AHB_PARAMETER
`define AHB_MASTER_SEQUENCER ahb_master_sequencer `AHB_PARAMETER

`define AHB_MASTER_DRIVE_ADDR ahb_master_drive_addr `AHB_PARAMETER
`define AHB_MASTER_DRIVE_DATA ahb_master_drive_data `AHB_PARAMETER

`define AHB_MASTER_BASE_SEQ ahb_master_base_seq `AHB_PARAMETER
`define AHB_MASTER_UNLOCK_INCR_SEQ ahb_master_unlock_incr_seq `AHB_PARAMETER
`define AHB_MASTER_UNLOCK_WRAP_SEQ ahb_master_unlock_wrap_seq `AHB_PARAMETER
`define AHB_MASTER_LOCK_INCR_SEQ ahb_master_lock_incr_seq `AHB_PARAMETER
`define AHB_MASTER_LOCK_WRAP_SEQ ahb_master_lock_wrap_seq `AHB_PARAMETER
`define AHB_MASTER_LOCK_SWAP_SEQ ahb_master_lock_swap_seq `AHB_PARAMETER
`define AHB_MASTER_STL_SEQ ahb_master_stl_seq `AHB_PARAMETER

`define AHB_SLAVE_BASE_SEQ ahb_slave_base_seq `AHB_PARAMETER

`define AHB_ENV ahb_env
`define AHB_BASE_SCOREBOARD ahb_base_scoreboard `AHB_PARAMETER2

`define AHB_BASE_TEST ahb_base_test
`define AHB_LOCK_INCR_TEST ahb_lock_incr_test
`define AHB_LOCK_INCR_ERROR_TEST ahb_lock_incr_error_test
`define AHB_LOCK_INCR_SPLIT_TEST ahb_lock_incr_split_test
`define AHB_LOCK_INCR_RETRY_TEST ahb_lock_incr_retry_test
`define AHB_LOCK_INCR_BUSY_TEST ahb_lock_incr_busy_test

`define AHB_LOCK_WRAP_TEST ahb_lock_wrap_test
`define AHB_LOCK_SWAP_TEST ahb_lock_swap_test
`define AHB_UNLOCK_INCR_TEST ahb_unlock_incr_test
`define AHB_UNLOCK_WRAP_TEST ahb_unlock_wrap_test
`define AHB_STL_TEST ahb_stl_test

// for DEBUG only
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


`endif
