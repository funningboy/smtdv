

//`include "busmatrix.v"
//`include "arbiter.v"
//`include "master_if.v"
//`include "multiplexer.v"
//`include "req_register.v"
//`include "slave_if.v"

`timescale 1ns/10ps

module tb_top();

BusMatrix i_BusMatrix(
      .HCLK(),
      .HRESETn(),

      .REMAP(),

// Slave 0  Input port
`ifdef SLAVE0
         .HSELS0(),
         .HADDRS0(),
         .HTRANSS0(),
         .HWRITES0(),
         .HSIZES0(),
         .HBURSTS0(),
         .HPROTS0(),
         .HMASTERS0(),
         .HWDATAS0(),
         .HMASTLOCKS0(),
         .HREADYS0(),
`endif


`ifdef SLAVE1
// Slave 1 Input port
         .HSELS1(),
         .HADDRS1(),
         .HTRANSS1(),
         .HWRITES1(),
         .HSIZES1(),
         .HBURSTS1(),
         .HPROTS1(),
         .HMASTERS1(),
         .HWDATAS1(),
         .HMASTLOCKS1(),
         .HREADYS1(),
`endif

`ifdef SLAVE2
// Slave 2 Input port
         .HSELS2(),
         .HADDRS2(),
         .HTRANSS2(),
         .HWRITES2(),
         .HSIZES2(),
         .HBURSTS2(),
         .HPROTS2(),
         .HMASTERS2(),
         .HWDATAS2(),
         .HMASTLOCKS2(),
         .HREADYS2(),
`endif

`ifdef SLAVE3
// Slave 3 Input port
         .HSELS3(),
         .HADDRS3(),
         .HTRANSS3(),
         .HWRITES3(),
         .HSIZES3(),
         .HBURSTS3(),
         .HPROTS3(),
         .HMASTERS3(),
         .HWDATAS3(),
         .HMASTLOCKS3(),
         .HREADYS3(),
`endif

`ifdef SLAVE4
// Slave 4 Input port
         .HSELS4(),
         .HADDRS4(),
         .HTRANSS4(),
         .HWRITES4(),
         .HSIZES4(),
         .HBURSTS4(),
         .HPROTS4(),
         .HMASTERS4(),
         .HWDATAS4(),
         .HMASTLOCKS4(),
         .HREADYS4(),
`endif

`ifdef SLAVE5
// Slave 5 Input port
         .HSELS5(),
         .HADDRS5(),
         .HTRANSS5(),
         .HWRITES5(),
         .HSIZES5(),
         .HBURSTS5(),
         .HPROTS5(),
         .HMASTERS5(),
         .HWDATAS5(),
         .HMASTLOCKS5(),
         .HREADYS5(),
`endif

`ifdef SLAVE6
// Slave 6 Input port
         .HSELS6(),
         .HADDRS6(),
         .HTRANSS6(),
         .HWRITES6(),
         .HSIZES6(),
         .HBURSTS6(),
         .HPROTS6(),
         .HMASTERS6(),
         .HWDATAS6(),
         .HMASTLOCKS6(),
         .HREADYS6(),
`endif

`ifdef SLAVE7
// Slave 7 Input port
         .HSELS7(),
         .HADDRS7(),
         .HTRANSS7(),
         .HWRITES7(),
         .HSIZES7(),
         .HBURSTS7(),
         .HPROTS7(),
         .HMASTERS7(),
         .HWDATAS7(),
         .HMASTLOCKS7(),
         .HREADYS7(),
`endif

`ifdef SLAVE8
// Slave 8 Input port
         .HSELS8(),
         .HADDRS8(),
         .HTRANSS8(),
         .HWRITES8(),
         .HSIZES8(),
         .HBURSTS8(),
         .HPROTS8(),
         .HMASTERS8(),
         .HWDATAS8(),
         .HMASTLOCKS8(),
         .HREADYS8(),
`endif

`ifdef SLAVE9
// Slave 9 Input port
         .HSELS9(),
         .HADDRS9(),
         .HTRANSS9(),
         .HWRITES9(),
         .HSIZES9(),
         .HBURSTS9(),
         .HPROTS9(),
         .HMASTERS9(),
         .HWDATAS9(),
         .HMASTLOCKS9(),
         .HREADYS9(),
`endif

`ifdef SLAVE10
// Slave 10 Input port
         .HSELS10(),
         .HADDRS10(),
         .HTRANSS10(),
         .HWRITES10(),
         .HSIZES10(),
         .HBURSTS10(),
         .HPROTS10(),
         .HMASTERS10(),
         .HWDATAS10(),
         .HMASTLOCKS10(),
         .HREADYS10(),
`endif

`ifdef SLAVE11
// Slave 11 Input port
         .HSELS11(),
         .HADDRS11(),
         .HTRANSS11(),
         .HWRITES11(),
         .HSIZES11(),
         .HBURSTS11(),
         .HPROTS11(),
         .HMASTERS11(),
         .HWDATAS11(),
         .HMASTLOCKS11(),
         .HREADYS11(),
`endif

`ifdef SLAVE12
// Slave 12 Input port
         .HSELS12(),
         .HADDRS12(),
         .HTRANSS12(),
         .HWRITES12(),
         .HSIZES12(),
         .HBURSTS12(),
         .HPROTS12(),
         .HMASTERS12(),
         .HWDATAS12(),
         .HMASTLOCKS12(),
         .HREADYS12(),
`endif

`ifdef SLAVE13
// Slave 13 Input port
         .HSELS13(),
         .HADDRS13(),
         .HTRANSS13(),
         .HWRITES13(),
         .HSIZES13(),
         .HBURSTS13(),
         .HPROTS13(),
         .HMASTERS13(),
         .HWDATAS13(),
         .HMASTLOCKS13(),
         .HREADYS13(),
`endif

`ifdef SLAVE14
// Slave 14 Input port
         .HSELS14(),
         .HADDRS14(),
         .HTRANSS14(),
         .HWRITES14(),
         .HSIZES14(),
         .HBURSTS14(),
         .HPROTS14(),
         .HMASTERS14(),
         .HWDATAS14(),
         .HMASTLOCKS14(),
         .HREADYS14(),
`endif

`ifdef SLAVE15
// Slave 15 Input port
         .HSELS15(),
         .HADDRS15(),
         .HTRANSS15(),
         .HWRITES15(),
         .HSIZES15(),
         .HBURSTS15(),
         .HPROTS15(),
         .HMASTERS15(),
         .HWDATAS15(),
         .HMASTLOCKS15(),
         .HREADYS15(),
`endif


`ifdef MASTER0
// Master 0 Input port
         .HRDATAM0(),
         .HREADYOUTM0(),
         .HRESPM0(),
`endif

`ifdef MASTER1
// Master 1 Input port
         .HRDATAM1(),
         .HREADYOUTM1(),
         .HRESPM1(),
`endif

`ifdef MASTER2
// Master 2 Input port
         .HRDATAM2(),
         .HREADYOUTM2(),
         .HRESPM2(),
`endif

`ifdef MASTER3
// Master 3 Input port
         .HRDATAM3(),
         .HREADYOUTM3(),
         .HRESPM3(),
`endif

`ifdef MASTER4
// Master 4 Input port
         .HRDATAM4(),
         .HREADYOUTM4(),
         .HRESPM4(),
`endif

`ifdef MASTER5
// Master 5 Input port
         .HRDATAM5(),
         .HREADYOUTM5(),
         .HRESPM5(),
`endif

`ifdef MASTER6
// Master 6 Input port
         .HRDATAM6(),
         .HREADYOUTM6(),
         .HRESPM6(),
`endif

`ifdef MASTER7
// Master 7 Input port
         .HRDATAM7(),
         .HREADYOUTM7(),
         .HRESPM7(),
`endif

`ifdef MASTER8
// Master 8 Input port
         .HRDATAM8(),
         .HREADYOUTM8(),
         .HRESPM8(),
`endif

`ifdef MASTER9
// Master 9 Input port
         .HRDATAM9(),
         .HREADYOUTM9(),
         .HRESPM9(),
`endif

`ifdef MASTER10
// Master 10 Input port
         .HRDATAM10(),
         .HREADYOUTM10(),
         .HRESPM10(),
`endif

`ifdef MASTER11
// Master 11 Input port
         .HRDATAM11(),
         .HREADYOUTM11(),
         .HRESPM11(),
`endif

`ifdef MASTER12
// Master 12 Input port
         .HRDATAM12(),
         .HREADYOUTM12(),
         .HRESPM12(),
`endif

`ifdef MASTER13
// Master 13 Input port
         .HRDATAM13(),
         .HREADYOUTM13(),
         .HRESPM13(),
`endif

`ifdef MASTER14
// Master 14 Input port
         .HRDATAM14(),
         .HREADYOUTM14(),
         .HRESPM14(),
`endif

`ifdef MASTER15
// Master 15 Input port
         .HRDATAM15(),
         .HREADYOUTM15(),
         .HRESPM15(),
`endif

          .SCANENABLE(),
          .SCANINHCLK(),

`ifdef MASTER0
// Master 0 Output port
          .HSELM0(),
          .HADDRM0(),
          .HTRANSM0(),
          .HWRITEM0(),
          .HSIZEM0(),
          .HBURSTM0(),
          .HPROTM0(),
          .HMASTERM0(),
          .HWDATAM0(),
          .HMASTLOCKM0(),
          .HREADYMUXM0(),
`endif

`ifdef MASTER1
// Master 1 Output port
          .HSELM1(),
          .HADDRM1(),
          .HTRANSM1(),
          .HWRITEM1(),
          .HSIZEM1(),
          .HBURSTM1(),
          .HPROTM1(),
          .HMASTERM1(),
          .HWDATAM1(),
          .HMASTLOCKM1(),
          .HREADYMUXM1(),
`endif

`ifdef MASTER2
// Master 2 Output port
          .HSELM2(),
          .HADDRM2(),
          .HTRANSM2(),
          .HWRITEM2(),
          .HSIZEM2(),
          .HBURSTM2(),
          .HPROTM2(),
          .HMASTERM2(),
          .HWDATAM2(),
          .HMASTLOCKM2(),
          .HREADYMUXM2(),
`endif

`ifdef MASTER3
// Master 3 Output port
          .HSELM3(),
          .HADDRM3(),
          .HTRANSM3(),
          .HWRITEM3(),
          .HSIZEM3(),
          .HBURSTM3(),
          .HPROTM3(),
          .HMASTERM3(),
          .HWDATAM3(),
          .HMASTLOCKM3(),
          .HREADYMUXM3(),
`endif

`ifdef MASTER4
// Master 4 Output port
          .HSELM4(),
          .HADDRM4(),
          .HTRANSM4(),
          .HWRITEM4(),
          .HSIZEM4(),
          .HBURSTM4(),
          .HPROTM4(),
          .HMASTERM4(),
          .HWDATAM4(),
          .HMASTLOCKM4(),
          .HREADYMUXM4(),
`endif

`ifdef MASTER5
// Master 5 Output port
          .HSELM5(),
          .HADDRM5(),
          .HTRANSM5(),
          .HWRITEM5(),
          .HSIZEM5(),
          .HBURSTM5(),
          .HPROTM5(),
          .HMASTERM5(),
          .HWDATAM5(),
          .HMASTLOCKM5(),
          .HREADYMUXM5(),
`endif

`ifdef MASTER6
// Master 6 Output port
          .HSELM6(),
          .HADDRM6(),
          .HTRANSM6(),
          .HWRITEM6(),
          .HSIZEM6(),
          .HBURSTM6(),
          .HPROTM6(),
          .HMASTERM6(),
          .HWDATAM6(),
          .HMASTLOCKM6(),
          .HREADYMUXM6(),
`endif

`ifdef MASTER7
// Master 7 Output port
          .HSELM7(),
          .HADDRM7(),
          .HTRANSM7(),
          .HWRITEM7(),
          .HSIZEM7(),
          .HBURSTM7(),
          .HPROTM7(),
          .HMASTERM7(),
          .HWDATAM7(),
          .HMASTLOCKM7(),
          .HREADYMUXM7(),
`endif

`ifdef MASTER8
// Master 8 Output port
          .HSELM8(),
          .HADDRM8(),
          .HTRANSM8(),
          .HWRITEM8(),
          .HSIZEM8(),
          .HBURSTM8(),
          .HPROTM8(),
          .HMASTERM8(),
          .HWDATAM8(),
          .HMASTLOCKM8(),
          .HREADYMUXM8(),
`endif

`ifdef MASTER9
// Master 9 Output port
          .HSELM9(),
          .HADDRM9(),
          .HTRANSM9(),
          .HWRITEM9(),
          .HSIZEM9(),
          .HBURSTM9(),
          .HPROTM9(),
          .HMASTERM9(),
          .HWDATAM9(),
          .HMASTLOCKM9(),
          .HREADYMUXM9(),
`endif

`ifdef MASTER10
// Master 10 Output port
          .HSELM10(),
          .HADDRM10(),
          .HTRANSM10(),
          .HWRITEM10(),
          .HSIZEM10(),
          .HBURSTM10(),
          .HPROTM10(),
          .HMASTERM10(),
          .HWDATAM10(),
          .HMASTLOCKM10(),
          .HREADYMUXM10(),
`endif

`ifdef MASTER11
// Master 11 Output port
          .HSELM11(),
          .HADDRM11(),
          .HTRANSM11(),
          .HWRITEM11(),
          .HSIZEM11(),
          .HBURSTM11(),
          .HPROTM11(),
          .HMASTERM11(),
          .HWDATAM11(),
          .HMASTLOCKM11(),
          .HREADYMUXM11(),
`endif

`ifdef MASTER12
// Master 12 Output port
          .HSELM12(),
          .HADDRM12(),
          .HTRANSM12(),
          .HWRITEM12(),
          .HSIZEM12(),
          .HBURSTM12(),
          .HPROTM12(),
          .HMASTERM12(),
          .HWDATAM12(),
          .HMASTLOCKM12(),
          .HREADYMUXM12(),
`endif

`ifdef MASTER13
// Master 13 Output port
          .HSELM13(),
          .HADDRM13(),
          .HTRANSM13(),
          .HWRITEM13(),
          .HSIZEM13(),
          .HBURSTM13(),
          .HPROTM13(),
          .HMASTERM13(),
          .HWDATAM13(),
          .HMASTLOCKM13(),
          .HREADYMUXM13(),
`endif

`ifdef MASTER14
// Master 14 Output port
          .HSELM14(),
          .HADDRM14(),
          .HTRANSM14(),
          .HWRITEM14(),
          .HSIZEM14(),
          .HBURSTM14(),
          .HPROTM14(),
          .HMASTERM14(),
          .HWDATAM14(),
          .HMASTLOCKM14(),
          .HREADYMUXM14(),
`endif

`ifdef MASTER15
// Master 15 Output port
          .HSELM15(),
          .HADDRM15(),
          .HTRANSM15(),
          .HWRITEM15(),
          .HSIZEM15(),
          .HBURSTM15(),
          .HPROTM15(),
          .HMASTERM15(),
          .HWDATAM15(),
          .HMASTLOCKM15(),
          .HREADYMUXM15(),
`endif


`ifdef SLAVE0
// Slave 0 Output port
         .HRDATAS0(),
         .HREADYOUTS0(),
         .HRESPS0(),
`endif

`ifdef SLAVE1
// Slave 1 Output port
         .HRDATAS1(),
         .HREADYOUTS1(),
         .HRESPS1(),
`endif

`ifdef SLAVE2
// Slave 2 Output port
         .HRDATAS2(),
         .HREADYOUTS2(),
         .HRESPS2(),
`endif

`ifdef SLAVE3
// Slave 3 Output port
         .HRDATAS3(),
         .HREADYOUTS3(),
         .HRESPS3(),
`endif

`ifdef SLAVE4
// Slave 4 Output port
         .HRDATAS4(),
         .HREADYOUTS4(),
         .HRESPS4(),
`endif

`ifdef SLAVE5
// Slave 5 Output port
         .HRDATAS5(),
         .HREADYOUTS5(),
         .HRESPS5(),
`endif

`ifdef SLAVE6
// Slave 6 Output port
         .HRDATAS6(),
         .HREADYOUTS6(),
         .HRESPS6(),
`endif

`ifdef SLAVE7
// Slave 7 Output port
         .HRDATAS7(),
         .HREADYOUTS7(),
         .HRESPS7(),
`endif

`ifdef SLAVE8
// Slave 8 Output port
         .HRDATAS8(),
         .HREADYOUTS8(),
         .HRESPS8(),
`endif

`ifdef SLAVE9
// Slave 9 Output port
         .HRDATAS9(),
         .HREADYOUTS9(),
         .HRESPS9(),
`endif

`ifdef SLAVE10
// Slave 10 Output port
         .HRDATAS10(),
         .HREADYOUTS10(),
         .HRESPS10(),
`endif

`ifdef SLAVE11
// Slave 11 Output port
         .HRDATAS11(),
         .HREADYOUTS11(),
         .HRESPS11(),
`endif

`ifdef SLAVE12
// Slave 12 Output port
         .HRDATAS12(),
         .HREADYOUTS12(),
         .HRESPS12(),
`endif

`ifdef SLAVE13
// Slave 13 Output port
         .HRDATAS13(),
         .HREADYOUTS13(),
         .HRESPS13(),
`endif

`ifdef SLAVE14
// Slave 14 Output port
         .HRDATAS14(),
         .HREADYOUTS14(),
         .HRESPS14(),
`endif

`ifdef SLAVE15
// Slave 15 Output port
         .HRDATAS15(),
         .HREADYOUTS15(),
         .HRESPS15(),
`endif


         .SCANOUTHCLK()
);

endmodule
