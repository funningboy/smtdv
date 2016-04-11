description
------
try to replay/clone bus behavior by using stl sequence.
that will get more easiler for tester who does not need to have create a new sequence again.

declare payload sequence, simulator and test at smtdv_apb.core
-----
declare the dependency graph as scheduler to handle the sequecne node based on edge correleation,
by default, parallel and muti sequences have edge dependency.

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

# declare the payload sequence and format,
ref: /lib/smtdb_apb_uvc/stl/preload0.stl
```
  # ordering sequence items are depend on the cycle and time.

# apb_monitor
# begin_cycle,        end_cycle,       begin_time,         end_time,    id, r/w, resp,  addr,  data,
0000000000000002, 0000000000000004, 0000000000000019, 000000000000002d,  0, w,    OK,  10000000, 000000ff,
0000000000000002, 0000000000000004, 0000000000000019, 000000000000002d,  0, r,    OK,  10000000, 000000ff,
```


```
  stls_t stls = '{
    q:
        '{
            {getenv("SMTDV_HOME"), "/lib/smtdv_apb_uvc/stl/preload1.stl"},
            {getenv("SMTDV_HOME"), "/lib/smtdv_apb_uvc/stl/preload0.stl"}
        }
  };

  # bind sequence as graph node, and create directed edge to reschedule graph's behavior

    graph = '{
        nodes:
           '{
               '{
                   // bind seq_stl[0](preload1.stl) as node[0]
                   uuid: 0,
                   seq: seq_stls[0],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "stls[0]")}
               },
               '{
                   // bind seq_stl[1](preload0.stl) as node[1]
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


override test name as "apb_stl_test" at [main] section
---
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
test = apb_stl_test
```
run test
----
```
python ../../../script/run.py --file smtdv_apb.core
```

simulation report
-----

check PASS/FAIL

_simulation.log for MTI,
irun.log for IUS


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
268455936   38          37000        0           65535         0             0             0             0             0             0             0             0             0             0             0             0             0             0             0             39          38000        1           0           0           0           0           1           0           1.84467440737096e+19
268455936   41          40000        0           65535         0             0             0             0             0             0             0             0             0             0             0             0
```
