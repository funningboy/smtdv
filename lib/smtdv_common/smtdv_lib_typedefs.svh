
`ifndef __SMTDV_LIB_TYPEDEFS_SVH__
`define __SMTDV_LIB_TYPEDEFS_SVH__

typedef enum bit [0:0] {FALSE, TRUE} bool_type_t;
typedef enum bit [2:0] {NOT_VALID, HW_RST, SW_RST, ALL_RST, PWR_RST} rst_type_t;
typedef enum bit [0:0] {MASTER, SLAVE} mod_type_t;
typedef enum bit [0:0] {RD, WR} trs_type_t;
typedef enum bit [1:0] {FORCE, NORMAL, SKIP} run_type_t;

typedef enum bit [4:0] {
  SMTDV_ALL_ON       = 5'b11111,
  SMTDV_FILENAME     = 5'b10000,
  SMTDV_NO_FILENAME  = 5'b01111,
  SMTDV_LINE         = 5'b01000,
  SMTDV_NO_LINE      = 5'b10111,
  SMTDV_TIME         = 5'b00100,
  SMTDV_NO_TIME      = 5'b11011,
  SMTDV_NAME         = 5'b00010,
  SMTDV_NO_NAME      = 5'b11101,
  SMTDV_ID           = 5'b00001,
  SMTDV_NO_ID        = 5'b11110
} smtdv_print_mask_t;

typedef enum bit [3:0] {
  SMTDV_CB_UUID,
  SMTDV_CB_ID,
  SMTDV_CB_ADDR,
  SMTDV_CB_RW,
  SMTDV_CB_LEN,
  SMTDV_CB_BURST,
  SMTDV_CB_SIZE,
  SMTDV_CB_LOCK,
  SMTDV_CB_PROT,
  SMTDV_CB_DATA,
  SMTDV_CB_RESP,
  SMTDV_CB_BG_CYC,
  SMTDV_CB_ED_CYC,
  SMTDV_CB_BG_TIME,
  SMTDV_CB_ED_TIME
} smtdv_backdoor_event_t;


`define SMTDV_PARAMETER #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG)
`define SMTDV_SCOREBOARD smtdv_scoreboard `SMTDV_PARAMETER
`define SMTDV_SCOREBOARD_BASE_THREAD smtdv_scoreboard_base_thread `SMTDV_PARAMETER
`define SMTDV_BACKDOOR smtdv_backdoor #(ADDR_WIDTH, DATA_WIDTH, T1)
`define SMTDV_SLAVE_BASE_SEQ
`define SMTDV_SLAVE_MEM_SEQ
`define SMTDV_SLAVE_FIFO_SEQ
`define SMTDV_BACKDOOR_BASE_THREAD smtdv_backdoor_base_thread `SMTDV_PARAMETER

`define SMTDV_WATCH_WR_LIFETIME smtdv_watch_wr_lifetime `SMTDV_PARAMETER
`define SMTDV_WATCH_RD_LIFETIME smtdv_watch_rd_lifetime `SMTDV_PARAMETER
`define SMTDV_MEM_BKDOR_RD_COMP smtdv_mem_bkdor_rd_comp `SMTDV_PARAMETER
`define SMTDV_MEM_BKDOR_WR_COMP smtdv_mem_bkdor_wr_comp `SMTDV_PARAMETER

`endif // end of __SMTDV_LIB_TYPEDEFS_SVH__
