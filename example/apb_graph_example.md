description
------
using graph theory to handle test sequences by using apb bus.

declare payload sequence, simulator and test at smtdv_apb.core
------
declare the dependency graph as scheduler to handle the sequecne node based on edge correleation,
by default, parallel and muti sequences have no edge dependency.

```
ex:
  [node0]
     |
  [node1]   [node2]
     |         |
     -----------
          |
        [seqr]
```
ref: lib/smtdv_apb_uvc/vseq/apb_master_1w1r_vseq.sv

```
    graph = '{
        nodes:
           '{
               '{
                   // bind apb 1 write seq as node0
                   uuid: 0,
                   seq: seq_1w,
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "seq_1w")}
               },
               '{
                   // bind apb r read seq as node1
                   uuid: 1,
                   seq: seq_1r,
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 1, "seq_1r")}
               },
               '{
                   // bind apb stop seq as background node
                   uuid: 2,
                   seq: seq_stop,
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 2, "seq_stop")}
                }
           },
        edges:
           '{
               '{
                   // create read after write edge correleation
                   uuid: 0,
                   sourceid: 0,
                   sinkid: 1,
                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 0, 0, 1)}
               }
           }
     };
```

