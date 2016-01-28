
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

/* FW CTL preloading seq steps */
typedef enum bit[3:0] {
  FW_STOP_ALL,
  FW_RESET_ALL,
  FW_TRY_LOCK,
  FW_FORCE_VIF,
  FW_SET_STL_ID,
  FW_START_LOAD,
  FW_START_REPLAY,
  FW_WAIT_COMPLETE,
  FW_FREE_VIF,
  FW_BACK_NORMAL,
  FW_TRY_UNLOCK
} smtdv_fw_ctl_event_t;

`endif // end of __SMTDV_LIB_TYPEDEFS_SVH__
