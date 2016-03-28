
`ifndef __SMTDV_TOP_MACROS_SVH__
`define __SMTDV_TOP_MACROS_SVH__


`define SMTDV_MAGIC_SEQ_DEC(LIB, ADDR_WIDTH, DATA_WIDTH) \
    smtdv_sequence#(``LIB``_sequence_item#(ADDR_WIDTH, DATA_WIDTH)) ``LIB``_seq_``ADDR_WIDTH``X``DATA_WIDTH``; \

`define SMTDV_MAGIC_SEQ_BIND(LIB, ADDR_WIDTH, DATA_WIDTH, SEQ, NODE) \
    if ($cast(``LIB``_seq_``ADDR_WIDTH``X``DATA_WIDTH``, ``SEQ``)) \
        ``LIB``_seq_``ADDR_WIDTH``X``DATA_WIDTH``.set(``NODE``);

//TODO:
//`define SMTDV_MAGIC_SEQR_DEC
//`define SMTDV_MAGIC_SEQR_BIND
//`define SMTDV_MAGIC_AGENT_DEC
//`define SMTDV_MAGIC_AGENT_BIND
//`define SMTDV_MAGIC_MONITOR_DEC
//`define SMTDV_MAGIC_MONITOR_BIND

`endif // __SMTDV_TOP_MACROS_SVH__


