
`ifndef __SMTDV_BASE_ENV_SV__
`define __SMTDV_BASE_ENV_SV__

//typedef class smtdv_reset_model;
//typedef class smtdv_slv_agts;
//typedef class smtdv_mst_agts;
//typedef class smtdv_slv_cfgs;
//typedef class smtdv_mst_cfgs;
//typedef class smtdv_scoreboard;

// only check compile is ok for base models
class smtdv_base_env#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type MCFG = smtdv_master_cfg,
  type MAGT = smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH, VIF),
  type SCFG = smtdv_slave_cfg,
  type SAGT = smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH, VIF),
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  )extends
  smtdv_cmp_env#(
    .MCFG(MCFG),
    .MAGT(MAGT),
    .SCFG(SCFG),
    .SAGT(SAGT),
    .T1(T1)
  );

  parameter NUM_OF_MASTERS = 1;
  parameter NUM_OF_SLAVES = 2;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = NUM_OF_SLAVES;

  typedef smtdv_base_env#(ADDR_WIDTH, DATA_WIDTH, VIF, MCFG, MAGT, SCFG, SAGT, T1) env_t;
  typedef smtdv_scoreboard#(
      ADDR_WIDTH,
      DATA_WIDTH,
      NUM_OF_INITOR,
      NUM_OF_TARGETS,
      T1,
      MAGT,
      SAGT) mst_scb_t;
  mst_scb_t mst_scbs[$];

  `uvm_component_param_utils_begin(env_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_base_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // slave cfg, agent
    for(int i=0; i<NUM_OF_SLAVES; i++) begin
        slv_cfgs[i] = slv_cfg_t::type_id::create({$psprintf("slv_cfgs[%0d]", i)}, this);
        slv_agts[i] = slv_agt_t::type_id::create({$psprintf("slv_agts[%0d]", i)}, this);
        uvm_config_db#(uvm_bitstream_t)::set(
            null,
            {$psprintf("/.+slv_agts[*%0d]*/", i)},
            "is_active",
            UVM_ACTIVE
        );
        uvm_config_db#(slv_cfg_t)::set(
            null,
            {$psprintf("/.+slv_agts[*%0d]*/", i)},
            "cfg",
            slv_cfgs[i]
        );
    end

    // master cfg, agent
    for(int i=0; i<NUM_OF_MASTERS; i++) begin
        mst_cfgs[i] = mst_cfg_t::type_id::create({$psprintf("mst_cfgs[%0d]", i)}, this);
        mst_agts[i] = mst_agt_t::type_id::create({$psprintf("mst_agts[%0d]", i)}, this);
        uvm_config_db#(uvm_bitstream_t)::set(
            null,
            {$psprintf("/.+mst_agts[*%0d]*/", i)},
            "is_active",
            UVM_ACTIVE
        );
        uvm_config_db#(mst_cfg_t)::set(
            null,
            {$psprintf("/.+mst_agts[*%0d]*/", i)},
            "cfg",
            mst_cfgs[i]
        );
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

endclass : smtdv_base_env

`endif // end of __SMTDV_UNITTEST_SV__
