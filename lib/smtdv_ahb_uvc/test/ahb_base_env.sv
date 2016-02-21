
`ifndef __AHB_BASE_ENV_SV__
`define __AHB_BASE_ENV_SV__

//typedef class ahb_master_cfg;
//typedef class ahb_slave_cfg;
//typedef class ahb_master_agent;
//typedef class ahb_slave_agent;
//typedef class ahb_base_scoreboard;
//typedef class ahb_sequence_item;

// 1Mx2S
class ahb_base_env#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH),
  type MCFG = ahb_master_cfg,
  type MAGT = ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH),
  type SCFG = ahb_slave_cfg,
  type SAGT = ahb_slave_agent#(ADDR_WIDTH, DATA_WIDTH),
  type T1 = ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
  extends
  smtdv_cmp_env#(
    .MCFG(MCFG),
    .MAGT(MAGT),
    .SCFG(SCFG),
    .SAGT(SAGT),
    .T1(T1)
  );

  parameter NUM_OF_MASTERS = 1;
  parameter NUM_OF_SLAVES = 1;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = NUM_OF_SLAVES;

  typedef ahb_base_env#(ADDR_WIDTH, DATA_WIDTH, VIF, MCFG, MAGT, SCFG, SAGT, T1) env_t;
  typedef ahb_base_scoreboard#(
    ADDR_WIDTH,
    DATA_WIDTH,
    NUM_OF_INITOR,
    NUM_OF_TARGETS
  ) mst_scb_t;
  mst_scb_t mst_scbs[$];

  `uvm_component_utils(env_t)

  function new(string name = "ahb_base_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // lookup table expect from .xml or .yaml
  virtual function void build_phase(uvm_phase phase);
    bit [ADDR_WIDTH-1:0] start_addr, end_addr;
    super.build_phase(phase);

    // slave cfg, agent
    for(int i=0; i<NUM_OF_SLAVES; i++) begin
        `AHB_SLAVE_CREATE(slv_cfg, slv_agt, i)
    end

    // master cfg, agent
    for(int i=0; i<NUM_OF_MASTERS; i++) begin
        `AHB_MASTER_CREATE(mst_cfg, mst_agt, i)
    end

    // scoreboard num of masters cross all slaves ex: 3*all, 2*all socreboard
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

endclass : ahb_base_env

`endif // __AHB_BASE_ENV_SV__
