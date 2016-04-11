description
------
a basic READ after WRITE test by using apb bus.

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

override test name as "apb_setup_test" at [main] section
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
test = apb_setup_test
```

run test
-------
```
python ../../../script/run.py --file smtdv_apb.core
```

simulation report
-----
check PASS/FAIL

```
_simulation.log for MTI,
irun.log for IUS
```

post process
-----
to extract raw apb bus transaction by querying apb_db.db and then compare these are expected to the driven sequences

```
% sqlite3 apb_db.db
sqlite> .tables
top.system_table
uvm_test_top.apb_env[0].mst_agts[0].mon
uvm_test_top.apb_env[0].slv_agts[0].mon
uvm_test_top.apb_env[0].slv_agts[0].seqr
uvm_test_top.apb_env[0].slv_agts[1].mon
sqlite> .headers on
sqlite> .mode column
sqlite> SELECT * FROM "uvm_test_top.apb_env[0].mst_agts[0].mon";
dec_addr    dec_bg_cyc  dec_bg_time  dec_burst   dec_data_000  dec_data_001  dec_data_002  dec_data_003  dec_data_004  dec_data_005  dec_data_006  dec_data_007  dec_data_008  dec_data_009  dec_data_010  dec_data_011  dec_data_012  dec_data_013  dec_data_014  dec_data_015  dec_ed_cyc  dec_ed_time  dec_id      dec_len     dec_lock    dec_prot    dec_resp    dec_rw      dec_size    dec_uuid
----------  ----------  -----------  ----------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ------------  ----------  -----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------  --------------------
268435456   43          42000        0           1547825622    0             0             0             0             0             0             0             0             0             0             0             0             0             0             0             44          43000        1           0           0           0           0           1           0           1.84467440737096e+19
268435456   54          53000        0           1547825622    0             0             0             0             0             0             0             0             0             0             0             0             0             0             0             55          54000        0           0           0           0           0           0           0           1.84467440737096e+19
sqlite>
```


