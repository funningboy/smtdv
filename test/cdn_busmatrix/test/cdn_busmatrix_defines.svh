`ifndef __CDN_BUSMATRIX_DEFINES_SV__
`define __CDN_BUSMATRIX_DEFINES_SV__

`include "ahb_if.sv"
`include "bm_params.v"

bit [`AHB_ADDR_WIDTH-1:0] cdn_start_addr_t[] = {
  SLAVE0_START_ADDR,
  SLAVE1_START_ADDR
};

bit [`AHB_ADDR_WIDTH-1:0] cdn_end_addr_t[] = {
  SLAVE0_END_ADDR,
  SLAVE1_END_ADDR
};

`define CDN_START_ADDR(i) \
  cdn_start_addr_t[i];

`define CDN_END_ADDR(i) \
  cdn_end_addr_t[i];



`define CDNBUSMATRIX u_tb_top.i_BusMatrix
`define CDNBUSPORT(inst, port, i) inst.port``i
`define CDNBUSPORTL(inst, port) inst.port

`ifdef AHB_VIF
  `undef AHB_VIF
`endif
`define AHB_VIF virtual interface ahb_if #(ADDR_WIDTH, DATA_WIDTH)

// drive from Master uvc vif to CDN bus slave
`define CDNBUS_SLAVE_VIF(i) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, tie_hi_1bit,      `CDNBUSPORT(`CDNBUSMATRIX, HSELS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.haddr,   `CDNBUSPORT(`CDNBUSMATRIX, HADDRS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.htrans,  `CDNBUSPORT(`CDNBUSMATRIX, HTRANSS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hwrite,  `CDNBUSPORT(`CDNBUSMATRIX, HWRITES, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hsize,   `CDNBUSPORT(`CDNBUSMATRIX, HSIZES, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hburst,  `CDNBUSPORT(`CDNBUSMATRIX, HBURSTS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hprot,   `CDNBUSPORT(`CDNBUSMATRIX, HPROTS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, tie_lo_4bit,      `CDNBUSPORT(`CDNBUSMATRIX, HMASTERS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hwdata,  `CDNBUSPORT(`CDNBUSMATRIX, HWDATAS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hmastlock,`CDNBUSPORT(`CDNBUSMATRIX, HMASTLOCKS, ``i)) \
    `SMTDV_VIF2PORT(S[``i].vif.has_force, clk, S[``i].vif.hready,  `CDNBUSPORT(`CDNBUSMATRIX, HREADYS, ``i)) \
    // floating \
    //`SMTDV_VIF2PORT(1, clk, vif_m[i].hbusreq, `CDNBUSMATRIX(i).HBUSREQS``i) \
    `SMTDV_PORT2VIF(S[``i].vif.has_force, clk, tie_hi_1bit,                  S[``i].vif.hgrant) \
    `SMTDV_PORT2VIF(S[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HRDATAS, ``i),     S[``i].vif.hrdata) \
    `SMTDV_PORT2VIF(S[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HREADYOUTS, ``i),  S[``i].vif.hready) \
    `SMTDV_PORT2VIF(S[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HRESPS, ``i),      S[``i].vif.hresp)

// receive from CDN bus master to slave uvc vif
`define CDNBUS_MASTER_VIF(i) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HSELM, ``i),     M[``i].vif.hsel) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HADDRM, ``i),    M[``i].vif.haddr) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HTRANSM, ``i),   M[``i].vif.htrans) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HWRITEM, ``i),   M[``i].vif.hwrite) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HSIZEM, ``i),    M[``i].vif.hsize) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HBURSTM, ``i),   M[``i].vif.hburst) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HPROTM, ``i),    M[``i].vif.hprot) \
    // floating HMASTER \
    //HMASTR = 4'b0; \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HWDATAM, ``i),     M[``i].vif.hwdata) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HMASTLOCKM, ``i),  M[``i].vif.hmastlock) \
    `SMTDV_PORT2VIF(M[``i].vif.has_force, clk, `CDNBUSPORT(`CDNBUSMATRIX, HREADYMUXM, ``i),  M[``i].vif.hready) \
    `SMTDV_VIF2PORT(M[``i].vif.has_force, clk, M[``i].vif.hrdata,    `CDNBUSPORT(`CDNBUSMATRIX, HRDATAM, ``i)) \
    `SMTDV_VIF2PORT(M[``i].vif.has_force, clk, M[``i].vif.hreadyout, `CDNBUSPORT(`CDNBUSMATRIX, HREADYOUTM, ``i)) \
    `SMTDV_VIF2PORT(M[``i].vif.has_force, clk, M[``i].vif.hresp,     `CDNBUSPORT(`CDNBUSMATRIX, HRESPM, ``i))

// bind Master UVC vif to cdn slave port
`define CDNBUS_SLAVE_ASSIGN_VIF(i) \
    uvm_config_db#(`AHB_VIF)::set(uvm_root::get(), {$psprintf("*.mst_agts[%0d]*",``i)}, "vif", `CDNBUSMATRIX.cdn_busmatrix_if_harness.S[``i].vif); \

// bind Slave UVC vif to cdn master port
`define CDNBUS_MASTER_ASSIGN_VIF(i) \
    uvm_config_db#(`AHB_VIF)::set(uvm_root::get(), {$psprintf("*.slv_agts[%0d]*", ``i)}, "vif", `CDNBUSMATRIX.cdn_busmatrix_if_harness.M[``i].vif); \

`define CDNBUS_SLAVE_CONNT(i) \
    .HSELS``i(`CDNBUSMATRIX.HSELS``i), \
    .HADDRS``i(`CDNBUSMATRIX.HADDRS``i), \
    .HTRANSS``i(`CDNBUSMATRIX.HTRANSS``i), \
    .HWRITES``i(`CDNBUSMATRIX.HWRITES``i), \
    .HSIZES``i(`CDNBUSMATRIX.HSIZES``i), \
    .HBURSTS``i(`CDNBUSMATRIX.HBURSTS``i),\
    .HPROTS``i(`CDNBUSMATRIX.HPROTS``i), \
    .HMASTERS``i(`CDNBUSMATRIX.HMASTERS``i), \
    .HWDATAS``i(`CDNBUSMATRIX.HWDATAS``i), \
    .HMASTLOCKS``i(`CDNBUSMATRIX.HMASTLOCKS``i), \
    .HREADYS``i(`CDNBUSMATRIX.HREADYS``i), \
    .HRDATAS``i(`CDNBUSMATRIX.HRDATAS``i), \
    .HREADYOUTS``i(`CDNBUSMATRIX.HREADYOUTS``i), \
    .HRESPS``i(`CDNBUSMATRIX.HRESPS``i),

`define CDNBUS_MASTER_CONNT(i) \
    .HRDATAM``i(`CDNBUSMATRIX.HRDATAM``i), \
    .HREADYOUTM``i(`CDNBUSMATRIX.HREADYOUTM``i), \
    .HRESPM``i(`CDNBUSMATRIX.HRESPM``i), \
    .HSELM``i(`CDNBUSMATRIX.HSELM``i), \
    .HADDRM``i(`CDNBUSMATRIX.HADDRM``i), \
    .HTRANSM``i(`CDNBUSMATRIX.HTRANSM``i), \
    .HWRITEM``i(`CDNBUSMATRIX.HWRITEM``i), \
    .HSIZEM``i(`CDNBUSMATRIX.HSIZEM``i), \
    .HBURSTM``i(`CDNBUSMATRIX.HBURSTM``i), \
    .HPROTM``i(`CDNBUSMATRIX.HPROTM``i), \
    .HMASTERM``i(`CDNBUSMATRIX.HMASTERM``i), \
    .HWDATAM``i(`CDNBUSMATRIX.HWDATAM``i), \
    .HMASTLOCKM``i(`CDNBUSMATRIX.HMASTLOCKM``i), \
    .HREADYMUXM``i(`CDNBUSMATRIX.HREADYMUXM``i),

`define CDNBUS_SLAVE_PORT(i) \
    logic    HSELS``i, \
    logic  [`AHB_ADDR_WIDTH - 1 : 0]  HADDRS``i, \
    logic  [1 : 0]  HTRANSS``i, \
    logic    HWRITES``i, \
    logic [2:0]   HSIZES``i, \
    logic [2 : 0]   HBURSTS``i, \
    logic [3 : 0]   HPROTS``i, \
    logic [3 : 0]   HMASTERS``i, \
    logic [`AHB_DATA_WIDTH - 1 : 0]   HWDATAS``i, \
    logic    HMASTLOCKS``i, \
    logic    HREADYS``i, \
    logic  [`AHB_DATA_WIDTH - 1 : 0]  HRDATAS``i, \
    logic    HREADYOUTS``i, \
    logic  [1 : 0]  HRESPS``i,

`define CDNBUS_MASTER_PORT(i) \
    logic     HSELM``i, \
    logic  [`AHB_ADDR_WIDTH - 1 : 0]   HADDRM``i, \
    logic  [1 : 0]   HTRANSM``i, \
    logic     HWRITEM``i, \
    logic  [2 : 0]   HSIZEM``i, \
    logic  [2 : 0]   HBURSTM``i, \
    logic  [3 : 0]   HPROTM``i, \
    logic  [3 : 0]   HMASTERM``i, \
    logic  [`AHB_DATA_WIDTH - 1 : 0]   HWDATAM``i, \
    logic     HMASTLOCKM``i, \
    logic     HREADYMUXM``i, \
    logic [`AHB_DATA_WIDTH - 1 : 0]   HRDATAM``i, \
    logic    HREADYOUTM``i, \
    logic [1 : 0]   HRESPM``i,

`endif // __CDN_BUSMATRIX_DEFINES_SV__

