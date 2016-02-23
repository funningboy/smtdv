
`ifndef __CDN_BUSMATRIX_ENV_SV__
`define __CDN_BUSMATRIX_ENV_SV__

`include "bm_defs.v"



// cluster0 for 2x1 test env
class cdn_cluster0#(
  ADDR_WIDTH = 32,
  DATA_WIDTH = 32,
  type VIF = virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH),
  type MCFG = ahb_master_cfg,
  type MAGT = ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH),
  type SCFG = ahb_slave_cfg,
  type SAGT = ahb_slave_agent#(ADDR_WIDTH, DATA_WIDTH),
  type T1 = ahb_item#(ADDR_WIDTH, DATA_WIDTH))
  extends
  smtdv_cmp_env#(
    .MCFG(MCFG),
    .MAGT(MAGT),
    .SCFG(SCFG),
    .SAGT(SAGT),
    .T1(T1)
  );

  `include "bm_params.v"

  parameter NUM_OF_MASTERS = 2;
  parameter NUM_OF_SLAVES = 2;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = NUM_OF_SLAVES;

  typedef cdn_cluster0#(ADDR_WIDTH, DATA_WIDTH, VIF, MCFG, MAGT, SCFG, SAGT, T1) clu0_t;
  typedef ahb_base_scoreboard#(
    ADDR_WIDTH,
    DATA_WIDTH,
    NUM_OF_INITOR,
    NUM_OF_TARGETS
  ) mst_scb_t;
  mst_scb_t mst_scbs[$];

  typedef MAGT mst_agt_t;
  typedef MCFG mst_cfg_t;
  typedef SAGT slv_agt_t;
  typedef SCFG slv_cfg_t;

  typedef cdn_dma_m0_agent#(ADDR_WIDTH, DATA_WIDTH) m0_agt_t;
  typedef cdn_cpu_m1_agent#(ADDR_WIDTH, DATA_WIDTH) m1_agt_t;
  typedef cdn_tcm_s0_agent#(ADDR_WIDTH, DATA_WIDTH) s0_agt_t;
  typedef cdn_sram_s1_agent#(ADDR_WIDTH, DATA_WIDTH) s1_agt_t;

  typedef cdn_dma_m0_cfg m0_cfg_t;
  typedef cdn_dma_m1_cfg m1_cfg_t;
  typedef cdn_tcm_s0_cfg s0_cfg_t;
  typedef cdn_sram_s1_cfg s1_cfg_t;

  m0_agt_t m0_agt;
  m1_agt_t m1_agt;
  s0_agt_t s0_agt;
  s1_agt_t s1_agt;

  m0_cfg_t m0_cfg;
  m1_cfg_t m1_cfg;
  s0_cfg_t s0_cfg;
  s1_cfg_t s1_cfg;

  `uvm_component_param_utils_begin(clu0_t)
  `uvm_component_utils_end

  function new(string name = "cdn_cluster0", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `ifdef SLAVE0 `CDN_SLAVE_CREATE(s0_cfg, s0_agt, 0)`endif
    `ifdef SLAVE1 `CDN_SLAVE_CREATE(s1_cfg, s1_agt, 1) `endif
    if (NUM_OF_SLAVES != slv_agts.size())
        `uvm_error("CDN_CMP_GRAPH_ERR",
            {$psprintf("graph slave size must be %d!=%d", NUM_OF_SLAVES, slv_agts.size())})


    `ifdef MASTER0 `CDN_MASTER_CREATE(m0_cfg, m0_agt, 0) `endif
    `ifdef MASTER1 `CDN_MASTER_CREATE(m1_cfg, m1_agt, 1) `endif
    if (NUM_OF_MASTERS != mst_agts.size())
        `uvm_error("CDN_CMP_GRAPH_ERR",
            {$psprintf("graph master size must be %d!=%d", NUM_OF_MASTERS, mst_agts.size())})


    for(int i=0; i<NUM_OF_MASTERS; i++) begin
        mst_scbs[i] = mst_scb_t::type_id::create({$psprintf("mst_scbs[%0d]", i)}, this);

        uvm_config_db#(mst_agt_t)::set(
            null,
            {$psprintf("/.+mst_scbs[*%0d]*/", i)},
            {$psprintf("initor_m[%0d]", i)},
            mst_agts[i]
        );

        for(int j=0; j<NUM_OF_SLAVES; j++) begin
            uvm_config_db#(slv_agt_t)::set(
                null,
                {$psprintf("/.+mst_scbs[*%0d]*/", i)},
                {$psprintf("targets_s[%0d]", j)},
                slv_agts[j]
            );
        end
     end
  endfunction : build_phase


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    for(int i=0; i<NUM_OF_MASTERS; i++) begin
        mst_agts[i].mon.item_collected_port.connect(mst_scbs[i].initor[i]);
        for(int j=0; j<NUM_OF_SLAVES; j++) begin
            slv_agts[j].mon.item_collected_port.connect(mst_scbs[i].targets[j]);
        end
    end
  endfunction : connect_phase

endclass : cdn_cluster0


`endif // __CDN_BUSMATRIX_ENV_SV__
