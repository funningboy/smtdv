`ifndef __AHB_TYPEDEFS_SV__
`define __AHB_TYPEDEFS_SV__

typedef enum bit [1:0] {IDLE, BUSY, NONSEQ, SEQ } trx_type_t;
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} bst_type_t;
typedef enum bit [2:0] {B8, B16, B32, B64, B128, B256, B512, B1024} trx_size_t;
typedef enum bit [1:0] {OKAY, ERROR, RETRY, SPLIT} trx_rsp_t;
typedef enum bit [3:0] {ST_IDLE, ST_REQBUS, ST_NOSEQ, ST_BUSY, ST_SEQ, ST_ERROR, ST_RETRY, ST_SPLIT, ST_NONE} fsm_state_t;
typedef enum logic [3:0] { // 4 status x,z,0,1
  OPCODE_FETCH =  4'bxxx0,
  DATA_ACCESS  = 4'bxxx1,
  USER_ACCESS  = 4'bxx0x,
  PRIVILEGED_ACCESS = 4'bxx1x,
  NOT_BUFFERABLE =  4'bx0xx,
  BUFFERABLE = 4'bx1xx,
  NOT_CACHEABLE = 4'b0xxx,
  CACHEABLE = 4'b1xxx
} trx_ptr_t;

`endif // __AHB_TYPEDEFS_SV__
