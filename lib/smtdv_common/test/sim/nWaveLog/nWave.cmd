wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_if_0"
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_if_0"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_rst_if"
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
{/top/xbus_rst_if/rst} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
{/top/xbus_rst_if/rst} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvGetSignalClose -win $_nWave1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvScrollDown -win $_nWave1 0
wvSetCursor -win $_nWave1 287137.147103 -snap {("G1" 6)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 166237.295691 -snap {("G1" 7)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvCloseFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvTpfCloseForm -win $_nWave1
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_if_0"
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvSetCursor -win $_nWave1 16208.023774 -snap {("G1" 3)}
wvResizeWindow -win $_nWave1 54 237 1616 462
wvSetCursor -win $_nWave1 9499.623777 -snap {("G1" 6)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 7447.705041 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 3951.843491 -snap {("G1" 7)}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomAll -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetCursor -win $_nWave1 531.978932 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 1367.945824 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 1671.933785 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 379.984951 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 2279.909707 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 3419.864560 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 227.990971 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 303.987961 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 46510.158014 -snap {("G1" 4)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSetCursor -win $_nWave1 504506.019564 -snap {("G1" 6)}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvZoom -win $_nWave1 475611.583898 519182.558315
wvZoom -win $_nWave1 497151.185246 505216.241458
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvLastView -win $_nWave1
wvZoom -win $_nWave1 0.000000 609535.000000
wvSetCursor -win $_nWave1 223358.574116 -snap {("G1" 8)}
wvLastView -win $_nWave1
wvZoom -win $_nWave1 0.000000 609535.000000
wvSetCursor -win $_nWave1 239869.680211 -snap {("G1" 6)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvZoom -win $_nWave1 456348.626787 558625.756208
wvSetCursor -win $_nWave1 503369.940614 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 504524.310020 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 499445.084632 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvZoom -win $_nWave1 499919.601204 516889.349135
wvSetCursor -win $_nWave1 504452.528605 -snap {("G1" 4)}
wvGetSignalOpen -win $_nWave1
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 503571.480744 -snap {("G1" 3)}
wvSetCursor -win $_nWave1 503456.561457 -snap {("G1" 4)}
wvZoom -win $_nWave1 501720.003355 504720.673606
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 502502.345147 -snap {("G1" 5)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 471483.807374 538445.515425
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 505493.704240 -snap {("G1" 4)}
wvZoom -win $_nWave1 499951.350676 512245.298580
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 462769.612491 562753.532731
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 251794.367946 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 0.000000 10025392.234763
wvZoom -win $_nWave1 181045.457964 1704844.729162
wvZoom -win $_nWave1 400041.440506 523871.629588
wvSetCursor -win $_nWave1 502907.150624 -snap {("G1" 6)}
wvSetCursor -win $_nWave1 439454.660959 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 437404.800793 -snap {("G1" 7)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 441970.398434 -snap {("G1" 9)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 0.000000 33543.166343
wvSetCursor -win $_nWave1 11357.731267 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 490653.990751 530633.204812
wvSetCursor -win $_nWave1 506417.051825 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 505664.997385 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 506537.380536 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 507349.599332 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 508492.722081 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 500400.616301 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvGoToTime -win $_nWave1 505000
wvSetCursor -win $_nWave1 497073.346196 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSetCursor -win $_nWave1 448265.013002 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 456286.470186 629559.813295
wvGoToTime -win $_nWave1 510500
wvSetCursor -win $_nWave1 462194.677485 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 64407.096686 -snap {("G1" 5)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 482922.846405 562193.119249
wvSetCursor -win $_nWave1 512030.365703 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 468343.611738 1990460.349887
wvZoom -win $_nWave1 479796.709843 590891.761461
wvZoom -win $_nWave1 490496.609472 522596.308360
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 346261.311700 1545809.427234
wvZoom -win $_nWave1 444644.114253 664877.176849
wvSetCursor -win $_nWave1 89485.217308 -snap {("G1" 9)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_if_0"
wvSetPosition -win $_nWave1 {("G1" 10)}
wvSetPosition -win $_nWave1 {("G1" 10)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/top/xbus_if_0/ack\[0:0\]} \
{/top/xbus_if_0/addr\[31:0\]} \
{/top/xbus_if_0/byten\[3:0\]} \
{/top/xbus_if_0/clk} \
{/top/xbus_if_0/cyc\[63:0\]} \
{/top/xbus_if_0/rdata\[31:0\]} \
{/top/xbus_if_0/req\[0:0\]} \
{/top/xbus_if_0/resetn} \
{/top/xbus_if_0/rw\[0:0\]} \
{/top/xbus_if_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave1 {("G1" 10)}
wvGetSignalClose -win $_nWave1
wvZoom -win $_nWave1 383352.225734 687778.993228
wvZoom -win $_nWave1 457798.199726 548278.691193
wvSetCursor -win $_nWave1 504842.608758 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 505795.751633 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 506680.812874 -snap {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvZoom -win $_nWave1 488707.261521 521386.445799
wvZoom -win $_nWave1 500165.876926 514944.048296
wvSetCursor -win $_nWave1 504591.544500 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 505470.006154 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 506481.905021 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 505981.515471 -snap {("G1" 4)}
wvSetCursor -win $_nWave1 505470.006154 -snap {("G1" 4)}
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSetCursor -win $_nWave1 504513.706125 -snap {("G1" 4)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSelectGroup -win $_nWave1 {G1}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 2 )} 
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetCursor -win $_nWave1 505492.245689 -snap {("G1" 3)}
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 2)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 6)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 502061.797331 512558.858109
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSetPosition -win $_nWave1 {("G1" 9)}
wvSetPosition -win $_nWave1 {("G1" 8)}
wvSetPosition -win $_nWave1 {("G1" 7)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 5)}
wvSetPosition -win $_nWave1 {("G1" 6)}
wvGoToTime -win $_nWave1 507000
wvGoToTime -win $_nWave1 507000
wvGoToTime -win $_nWave1 505500
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvSelectSignal -win $_nWave1 {( "G1" 1 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 477720.518528 -snap {("G1" 7)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvGoToTime -win $_nWave1 505500
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 6)}
wvSetPosition -win $_nWave1 {("G1" 5)}
wvGoToTime -win $_nWave1 506000
wvSetCursor -win $_nWave1 505168.086273 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 505379.846131 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 506347.891195 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 505561.354580 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 506468.896828 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 505470.600356 -snap {("G1" 2)}
wvZoom -win $_nWave1 504048.784168 508828.506671
wvSetCursor -win $_nWave1 506656.232486 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 147311.838768 1767742.065218
wvZoom -win $_nWave1 378976.054739 625271.694877
wvZoom -win $_nWave1 467004.970514 539281.343467
wvZoom -win $_nWave1 495447.817056 538791.887216
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 518701.633477 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 514331.351008 -snap {("G1" 4)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 98216.230248 3437568.058691
wvZoom -win $_nWave1 173596.632696 1291739.269007
wvZoom -win $_nWave1 427681.716342 663257.290584
wvZoom -win $_nWave1 487240.326534 540063.141526
wvSetCursor -win $_nWave1 504529.961238 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 505404.379545 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 504768.438958 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 501231.019444 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 500952.795437 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 506994.231012 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomAll -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 0.000000 20767052.682468
wvSetCursor -win $_nWave1 796929.786912 -snap {("G1" 4)}
wvZoom -win $_nWave1 0.000000 1234459.866001
wvZoom -win $_nWave1 0.000000 47372.049034
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 423176.046751 568036.849816
wvZoom -win $_nWave1 477893.972363 519095.916350
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 508282.343692 -snap {("G1" 2)}
wvZoom -win $_nWave1 497307.559515 520125.189894
wvSetCursor -win $_nWave1 507402.944513 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 507900.846154 -snap {("G1" 2)}
wvGoToTime -win $_nWave1 503500
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvGoToTime -win $_nWave1 507000
wvZoom -win $_nWave1 498793.207433 522898.514471
wvSetCursor -win $_nWave1 507989.137206 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 508950.447419 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 508025.413063 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvGoToTime -win $_nWave1 508000
wvSetCursor -win $_nWave1 503891.759184 -snap {("G1" 8)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 507555.620751 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 507900.241393 -snap {("G1" 2)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 494287.726019 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoom -win $_nWave1 518229.791700 518665.101985
wvSetCursor -win $_nWave1 518403.391738 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 507378.970431 -snap {("G1" 9)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 2774498.087119 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 987442.259245 -snap {("G1" 1)}
wvSetCursor -win $_nWave1 971342.657192 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 821079.704699 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 3654609.666011 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoom -win $_nWave1 354191.245164 1212836.687986
wvZoom -win $_nWave1 492453.190058 590011.852109
wvSelectSignal -win $_nWave1 {( "G1" 9 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvZoom -win $_nWave1 502069.581878 511465.750984
wvSetCursor -win $_nWave1 504466.347361 -snap {("G1" 2)}
wvSetCursor -win $_nWave1 505965.209551 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 483310.726019 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 479125.841833 -snap {("G1" 8)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvResizeWindow -win $_nWave1 54 42 1305 462
wvSetCursor -win $_nWave1 503749.392795 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 44157.414625 -snap {("G1" 7)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
wvUnknownSaveResult -win $_nWave1 -clear
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G2" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/clk} \
{/top/resetn} \
{/top/w_ack\[0\]} \
{/top/w_addr\[31:0\]} \
{/top/w_byten\[3:0\]} \
{/top/w_rdata\[31:0\]} \
{/top/w_req\[0\]} \
{/top/w_rw\[0\]} \
{/top/w_wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G2" 9)}
wvSetPosition -win $_nWave1 {("G2" 9)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/clk} \
{/top/resetn} \
{/top/w_ack\[0\]} \
{/top/w_addr\[31:0\]} \
{/top/w_byten\[3:0\]} \
{/top/w_rdata\[31:0\]} \
{/top/w_req\[0\]} \
{/top/w_rw\[0\]} \
{/top/w_wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 9 )} 
wvSetPosition -win $_nWave1 {("G2" 9)}
wvGetSignalClose -win $_nWave1
wvZoomAll -win $_nWave1
wvZoom -win $_nWave1 490003.781925 517595.235756
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 5 )} 
wvSelectSignal -win $_nWave1 {( "G2" 6 )} 
wvSelectSignal -win $_nWave1 {( "G2" 7 )} 
wvSelectSignal -win $_nWave1 {( "G2" 8 )} 
wvSelectSignal -win $_nWave1 {( "G2" 9 )} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_if_0"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_slave_if_harness_0"
wvSetPosition -win $_nWave1 {("G2" 18)}
wvSetPosition -win $_nWave1 {("G2" 18)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/clk} \
{/top/resetn} \
{/top/w_ack\[0\]} \
{/top/w_addr\[31:0\]} \
{/top/w_byten\[3:0\]} \
{/top/w_rdata\[31:0\]} \
{/top/w_req\[0\]} \
{/top/w_rw\[0\]} \
{/top/w_wdata\[31:0\]} \
{/top/xbus_slave_if_harness_0/ack\[0\]} \
{/top/xbus_slave_if_harness_0/addr\[31:0\]} \
{/top/xbus_slave_if_harness_0/byten\[3:0\]} \
{/top/xbus_slave_if_harness_0/has_force} \
{/top/xbus_slave_if_harness_0/rdata\[31:0\]} \
{/top/xbus_slave_if_harness_0/req\[0\]} \
{/top/xbus_slave_if_harness_0/resetn} \
{/top/xbus_slave_if_harness_0/rw\[0\]} \
{/top/xbus_slave_if_harness_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 10 11 12 13 14 15 16 17 18 )} 
wvSetPosition -win $_nWave1 {("G2" 18)}
wvSetPosition -win $_nWave1 {("G2" 18)}
wvSetPosition -win $_nWave1 {("G2" 18)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/clk} \
{/top/resetn} \
{/top/w_ack\[0\]} \
{/top/w_addr\[31:0\]} \
{/top/w_byten\[3:0\]} \
{/top/w_rdata\[31:0\]} \
{/top/w_req\[0\]} \
{/top/w_rw\[0\]} \
{/top/w_wdata\[31:0\]} \
{/top/xbus_slave_if_harness_0/ack\[0\]} \
{/top/xbus_slave_if_harness_0/addr\[31:0\]} \
{/top/xbus_slave_if_harness_0/byten\[3:0\]} \
{/top/xbus_slave_if_harness_0/has_force} \
{/top/xbus_slave_if_harness_0/rdata\[31:0\]} \
{/top/xbus_slave_if_harness_0/req\[0\]} \
{/top/xbus_slave_if_harness_0/resetn} \
{/top/xbus_slave_if_harness_0/rw\[0\]} \
{/top/xbus_slave_if_harness_0/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 10 11 12 13 14 15 16 17 18 )} 
wvSetPosition -win $_nWave1 {("G2" 18)}
wvGetSignalClose -win $_nWave1
wvScrollDown -win $_nWave1 4
wvScrollUp -win $_nWave1 3
wvScrollDown -win $_nWave1 4
wvSelectSignal -win $_nWave1 {( "G2" 15 16 17 18 )} 
wvScrollUp -win $_nWave1 5
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_slave_if_harness_0"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_slave_if_harness_0/vif"
wvSetPosition -win $_nWave1 {("G2" 8)}
wvSetPosition -win $_nWave1 {("G2" 8)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/xbus_slave_if_harness_0/vif/ack\[0:0\]} \
{/top/xbus_slave_if_harness_0/vif/addr\[31:0\]} \
{/top/xbus_slave_if_harness_0/vif/byten\[3:0\]} \
{/top/xbus_slave_if_harness_0/vif/clk} \
{/top/xbus_slave_if_harness_0/vif/rdata\[31:0\]} \
{/top/xbus_slave_if_harness_0/vif/req\[0:0\]} \
{/top/xbus_slave_if_harness_0/vif/rw\[0:0\]} \
{/top/xbus_slave_if_harness_0/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 )} 
wvSetPosition -win $_nWave1 {("G2" 8)}
wvSetPosition -win $_nWave1 {("G2" 8)}
wvSetPosition -win $_nWave1 {("G2" 8)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/top/xbus_slave_if_harness_0/vif/ack\[0:0\]} \
{/top/xbus_slave_if_harness_0/vif/addr\[31:0\]} \
{/top/xbus_slave_if_harness_0/vif/byten\[3:0\]} \
{/top/xbus_slave_if_harness_0/vif/clk} \
{/top/xbus_slave_if_harness_0/vif/rdata\[31:0\]} \
{/top/xbus_slave_if_harness_0/vif/req\[0:0\]} \
{/top/xbus_slave_if_harness_0/vif/rw\[0:0\]} \
{/top/xbus_slave_if_harness_0/vif/wdata\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 )} 
wvSetPosition -win $_nWave1 {("G2" 8)}
wvGetSignalClose -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/top"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_slave_if_harness_0"
wvGetSignalSetScope -win $_nWave1 "/top/xbus_slave_if_harness_0/vif"
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 494665.599272 -snap {("G2" 8)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvConvertFile -win $_nWave1 -o \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd.fsdb" \
           "/stec/tw/users/schen/prj/smartdv/lib/smtdv_common/test/sim/test_xbus.vcd"
wvReloadFile -win $_nWave1
