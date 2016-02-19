// define global/local lookup table(router table) as trace recoreder
//
// ex:
//  | path | s time | e time | CPU |  DMA |  RAM | DDR | description
// =====================================================================
//    0    |        |        |   0 |    1  |  x   |  x  | => CPU cfg DMA to set blocks of mem to mv
//    1    |        |        |   x |    x  |  0   |  1  | => mv Data from RAM to DDR
//    2    |        |        |   1 |    0  |  x   |  x  | => interrupt CPU while DMA is completed
//static lookup table
