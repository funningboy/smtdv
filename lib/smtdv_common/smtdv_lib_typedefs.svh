
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


`endif // end of __SMTDV_LIB_TYPEDEFS_SVH__
