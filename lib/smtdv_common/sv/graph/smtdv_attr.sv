
`ifndef __SMTDV_ATTR_SV__
`define __SMTDV_ATTR_SV__

typedef struct {
  int weight;       // edge weight
  int delay;        // trx/seq delay
  time start_time;
  time end_time;
} smtdv_attr;


`define SMTDV_DEFAULT_ATTR \
  '{ \
    -1, \
    -1, \
    $time, \
    $time \
  }

`endif // __SMTDV_ATTR_SV__

