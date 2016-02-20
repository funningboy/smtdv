/*
* register all type of seqs for node bind
*/

`ifdef SMTDV_SEQ_32X32
    `SMTDV_MAGIC_SEQ_BIND(smtdv, 32, 32, bseq, node)
`endif

`ifdef SMTDV_SEQ_64X64
    `SMTDV_MAGIC_SEQ_BIND(smtdv, 64, 64, bseq, node)
`endif

`ifdef APB_SEQ_32X32
    `SMTDV_MAGIC_SEQ_BIND(apb, 32, 32, bseq, node)
`endif

`ifdef APB_SEQ_64X64
    `SMTDV_MAGIC_SEQ_BIND(apb, 64, 64, bseq, node)
`endif

`ifdef AHB_SEQ_32X32
    `SMTDV_MAGIC_SEQ_BIND(ahb, 32, 32, bseq, node)
`endif

`ifdef AHB_SEQ_64X64
    `SMTDV_MAGIC_SEQ_BIND(ahb, 64, 64, bseq, node)
`endif


