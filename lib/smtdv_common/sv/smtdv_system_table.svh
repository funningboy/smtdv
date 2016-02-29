`ifndef __SMTDV_SYSTEM_TABLE_SVH__
`define __SMTDV_SYSTEM_TABLE_SVH__

// define global/local lookup table(router table) as trace recoreder
//
// ex:
//  | s time | CPU |  DMA |  RAM | DDR | description
// =====================================================
//  |        |   0 |    1  |  x   |  x  | => CPU cfg DMA to set blocks of mem to mv
//  |        |   x |    x  |  0   |  1  | => mv Data from RAM to DDR
//  |        |   1 |    0  |  x   |  x  | => interrupt CPU while DMA is completed
//static lookup table
//header
//'{
// puid:
// time:
// nick_names[]
// desc:
//}
//body
//`{
//}


`endif // __SMTDV_SYSTEM_TABLE_SVH__
