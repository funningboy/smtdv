description
-----
try to label some valid transactions and layer packages as event callback to notify the
label handler when the match transaction or package asserted/deasserted at inserted monitor collected

declare payload sequence, simulator and test at smtdv_apb.core
-----
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
ref: lib/smtdv_apb_uvc/vseq/apb_master_stl_vseq.sv

```
    graph = '{
        nodes:
           '{
               '{
                   uuid: 0,
                   seq: seq_stls[0],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "stls[0]")}
               },
               '{
                   uuid: 1,
                   seq: seq_stls[1],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 1, "stls[1]")}
               },
               '{
                    uuid: 2,
                    seq: seq_stop,
                    seqr: vseqr.apb_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", 2, "stop_seqr")}
                }
           },
        edges:
           '{
               '{
                   uuid: 0,
                   sourceid: 0,
                   sinkid: 1,
                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 0, 0, 1)}
               }
           }
     };
```

declare the labelled transcation.
-----


ex:
   record the force vif cfg had asserted at `APB_SLAVE_ADDR_0, if asseted this transaction, then callback to
   update the right pointer cfg.

ref: lib/smtdv_apb_uvc/test/apb_cfg_label_test.sv
     lib/smtdv_common/sv/smtdv_cfg_label.sv
     lib/smtdv_common/sv/smtdv_force_replay_label.sv

set/override cfg label rule at top level
-----
```
  virtual function void set(meta_t meta);
    cfgtb = '{
        ufid: 0,
        desc: {$psprintf("force set cfg.stlid as %d", meta.data)},
        cmp: meta.cmp,
        cfg: meta.cfg,
        rows: '{
            '{
                urid: 0,
                addr: meta.addr,
                data: meta.data,
                trs: meta.trs,
                attr: '{
                    match: FALSE,
                    require: TRUE,
                    clear: TRUE,
                    depends: '{-1},
                    visit: FALSE
                },
                cols: '{
                    '{
                        ucid: 0,
                        left: 5,
                        right: 3,
                        def: 0,
                        val: 0,
                        desc: "stl id, default 0"
                    }
                }
            }
        }
    };
  endfunction : set
```

override test name as "apb_cfg_label_test" at [main] section
-----
ref: lib/smtdv_apb_uvc/sim/smtdv_apb.core

```
[main]
description = "SMTDV APB lib"
root = os.getenv("SMTDV_HOME")
apb = ${main:root}/lib/smtdv_apb_uvc
debug = TRUE
spawn = TRUE
stdout = FALSE
unittest = TRUE
clean = FALSE
simulator = ius
test = apb_cfg_label_test
```

run test
-----
python ../../../script/run.py --file apb_setup_test

simulation report
-----
check PASS/FAIL

_simulation.log for MTI,
irun.log for IUS

post process
-----
to extract raw label info by querying apb_db.db,
system table records the updated reg event when the match trx asserted by the labled monitor
```
% sqlite3 apb_db.db

sqlite> .tables
top.system_table
uvm_test_top.apb_env[0].mst_agts[0].mon
uvm_test_top.apb_env[0].slv_agts[0].mon
uvm_test_top.apb_env[0].slv_agts[0].seqr
uvm_test_top.apb_env[0].slv_agts[1].mon
sqlite> .mode column
sqlite> .headers on
sqlite> SELECT * FROM "top.system_table";
uvm_test_top.apb_env[0].mst_agts[0]  uvm_test_top.apb_env[0].slv_agts[0]  desc                                time
-----------------------------------  -----------------------------------  ----------------------------------  ----------
1                                    0                                    force set cfg.stlid as           7  800
0                                    1                                    force set cfg.stlid as           7  800
sqlite>
```
