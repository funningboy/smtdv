
/*
*  declare all type of seqs
*/

`ifdef SMTDV_SEQ_32X32
    `SMTDV_MAGIC_SEQ_DEC(smtdv, 32, 32)
`endif

`ifdef SMTDV_SEQ_64X64
    `SMTDV_MAGIC_SEQ_DEC(smtdv, 64, 64)
`endif

`ifdef APB_SEQ_32X32
    `SMTDV_MAGIC_SEQ_DEC(apb, 32, 32)
`endif

`ifdef APB_SEQ_64X64
    `SMTDV_MAGIC_SEQ_DEC(apb, 64, 64)
`endif

`ifdef AHB_SEQ_32X32
    `SMTDV_MAGIC_SEQ_DEC(ahb, 32, 32)
`endif

`ifdef AHB_SEQ_64X64
    `SMTDV_MAGIC_SEQ_DEC(ahb, 64, 64)
`endif
