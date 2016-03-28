1. description
try to label some valid transactions and layer packages as event callback to notify the
label handler when the match transaction or package asserted/deasserted at inserted monitor collected

2. declare payload sequence, simulator and test at smtdv_apb.core
2.1 declare the dependency graph as scheduler to handle the sequecne node based on edge correleation,
by default, parallel or muti sequences are no edge dependency.

ex:
  [node0]
     |
  [node1]   [node2]
     |         |
     -----------
          |
        [seqr]

ref: lib/smtdv_apb_uvc/vseq/apb_master_stl_vseq.sv

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


2.2 declare the labelled transcation.
ex:
   record the force vif cfg had asserted at `APB_SLAVE_ADDR_0, if asseted this transaction, then callback to
   update the pointer cfg.

ref: lib/smtdv_apb_uvc/test/apb_cfg_label_test.sv

    cfg_labs[0].set('{
        WR,
        `APB_SLAVE_START_ADDR_0,
        1,
        cmp_envs[0].mst_agts[0],
        cmp_envs[0].mst_agts[0].cfg
    });

    rcv_labs[0].set('{
        WR,
        `APB_SLAVE_START_ADDR_0,
        1,
        cmp_envs[0].slv_agts[0],
        cmp_envs[0].mst_agts[0].cfg
    });



2.3
override test name as "apb_cfg_label_test" at [main] section
ref: lib/smtdv_apb_uvc/sim/smtdv_apb.core

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

3 run test
python ../../../script/run.py --file apb_setup_test

4. simulation report
check PASS/FAIL

_simulation.log for MTI,
irun.log for IUS

5. post process
to extract raw label info by querying apb_db.db
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

