
// test for port declear
`define XBUSPORT(m, i) input SELE``m``i

`define XBUSMASTERATTR(i) u_dut_1m1s.M[i].u_xbus_master
`define XBUSSLAVEATTR(i)  u_dut_1m1s.S[i].u_xbus_slave
`define XBUSMASTERVIF(i)  `XBUSMASTERATTR(i).xbus_master_if_harness.vif
`define XBUSSLAVEVIF(i)   `XBUSSLAVEATTR(i).xbus_slave_if_harness.vif
