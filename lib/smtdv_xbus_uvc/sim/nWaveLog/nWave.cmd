wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvGetSignalClose -win $_nWave1
wvZoom -win $_nWave1 0.000000 55999.312094
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSetCursor -win $_nWave1 5024.645689 -snap {("G2" 0)}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectGroup -win $_nWave1 {G2}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G2" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G2" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G2" 9)}
wvGetSignalClose -win $_nWave1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvResizeWindow -win $_nWave1 54 237 1680 915
wvSetCursor -win $_nWave1 23649.865829 -snap {("G2" 3)}
wvSetCursor -win $_nWave1 14420.649896 -snap {("G2" 7)}
wvResizeWindow -win $_nWave1 54 237 1680 915
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvSetCursor -win $_nWave1 62391.397542 -snap {("G3" 0)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 50345.890733 -snap {("G3" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G2" 9 )} 
wvSetCursor -win $_nWave1 22359.922818 -snap {("G1" 9)}
wvSetOptions -win $_nWave1 -hierName on
wvResizeWindow -win $_nWave1 -5 25 1680 915
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 7 )} 
wvSelectSignal -win $_nWave1 {( "G2" 6 )} 
wvSelectSignal -win $_nWave1 {( "G2" 5 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G2" 6 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 26066.844933 -snap {("G2" 6)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif"
wvSetPosition -win $_nWave1 {("G3" 10)}
wvSetPosition -win $_nWave1 {("G3" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/clk} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/cyc\[63:0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/resetn} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G3" 10)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 1 2 3 4 5 6 7 8 9 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 0)}
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSelectSignal -win $_nWave1 {( "G2" 9 )} 
wvSelectSignal -win $_nWave1 {( "G2" 8 )} 
wvSelectSignal -win $_nWave1 {( "G2" 7 )} 
wvSelectSignal -win $_nWave1 {( "G2" 6 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 5 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 9 )} 
wvSelectSignal -win $_nWave1 {( "G2" 8 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/byten\[3:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G3" 9)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 5 6 7 8 9 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 4)}
wvSelectSignal -win $_nWave1 {( "G3" 1 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSelectSignal -win $_nWave1 {( "G3" 1 )} 
wvSelectSignal -win $_nWave1 {( "G3" 2 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSelectSignal -win $_nWave1 {( "G2" 3 4 5 6 7 8 9 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 3 4 5 6 7 8 9 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 0)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G3" 1 )} 
wvSetCursor -win $_nWave1 27510.991467 -snap {("G4" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G3" 1 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G2" 1 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSetPosition -win $_nWave1 {("G3" 3)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G3" 0)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvZoom -win $_nWave1 722.073267 18701.697611
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G2" 0)}
wvSetPosition -win $_nWave1 {("G2" 1)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G3" 0)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSelectSignal -win $_nWave1 {( "G3" 2 )} 
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G3" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 0)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSetPosition -win $_nWave1 {("G3" 3)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetPosition -win $_nWave1 {("G3" 1)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 1)}
wvSetPosition -win $_nWave1 {("G3" 2)}
wvSetCursor -win $_nWave1 13330.430864 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoom -win $_nWave1 10148.681934 23369.397317
wvSetCursor -win $_nWave1 14434.573648 -snap {("G1" 1)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_xbus_uvc/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 6885.873379 40811.395881
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 3 4 5 )} 
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvSetPosition -win $_nWave1 {("G3" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 3 4 5 )} 
wvSetPosition -win $_nWave1 {("G3" 5)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSetPosition -win $_nWave1 {("G3" 6)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 31262.564605 -snap {("G4" 0)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 6)}
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 4 )} 
wvSelectSignal -win $_nWave1 {( "G3" 3 )} 
wvSelectSignal -win $_nWave1 {( "G3" 5 )} 
wvSelectSignal -win $_nWave1 {( "G3" 6 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvSetPosition -win $_nWave1 {("G3" 7)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 7 )} 
wvSetPosition -win $_nWave1 {("G3" 7)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]/u_xbus_slave"
wvGetSignalSetScope -win $_nWave1 \
           "/top/u_dut_1m1s/S\[0\]/u_xbus_slave/xbus_slave_if_harness"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/M\[0\]/u_xbus_master"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s/S\[0\]"
wvGetSignalSetScope -win $_nWave1 "/top/u_dut_1m1s"
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/w_rdata\[31:0\]} \
{/top/u_dut_1m1s/w_wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 8 9 )} 
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/clk} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/resetn} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/xbus_master_if_harness/vif/master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/clk\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/resetn\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/ack\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/req\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rw\[0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/rdata\[31:0\]} \
{/top/u_dut_1m1s/w_rdata\[31:0\]} \
{/top/u_dut_1m1s/w_wdata\[31:0\]} \
{/top/u_dut_1m1s/M\[0\]/u_xbus_master/addr\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G4" \
}
wvSelectSignal -win $_nWave1 {( "G3" 8 9 )} 
wvSetPosition -win $_nWave1 {("G3" 9)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 8)}
wvSetPosition -win $_nWave1 {("G3" 9)}
wvSetPosition -win $_nWave1 {("G3" 10)}
wvSetPosition -win $_nWave1 {("G4" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G4" 2)}
wvSetPosition -win $_nWave1 {("G4" 2)}
wvExit
