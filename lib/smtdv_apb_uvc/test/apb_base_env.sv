
`ifndef __APB_BASE_TEST_SV__
`define __APB_BASE_TEST_SV__

//typedef class apb_mst_cfgs;
//typedef class apb_slv_cfgs;
//typedef class apb_mst_agts;
//typedef class apb_slv_agts;
//typedef class apb_base_scoreboard;
//typedef class apb_item;

/*
* a basic 1Mx2S cluster env
*
* @class apb_base_env#(ADDR_WIDTH, DATA_WIDTH, VIF, MCFG, MAGT, SCFG, SAGT, T1)
*/
class apb_base_env#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH),
  type MCFG = apb_master_cfg,
  type MAGT = apb_master_agent#(ADDR_WIDTH, DATA_WIDTH),
  type SCFG = apb_slave_cfg,
  type SAGT = apb_slave_agent#(ADDR_WIDTH, DATA_WIDTH),
  type T1 = apb_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
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

  typedef apb_base_env#(ADDR_WIDTH, DATA_WIDTH, VIF, MCFG, MAGT, SCFG, SAGT, T1) env_t;
  typedef apb_base_scoreboard#(
    ADDR_WIDTH,
    DATA_WIDTH,
    NUM_OF_INITOR,
    NUM_OF_TARGETS
  ) mst_scb_t;
  mst_scb_t mst_scbs[$];

  `uvm_component_utils(env_t)

  function new(string name = "apb_base_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    bit [ADDR_WIDTH-1:0] start_addr, end_addr;
    super.build_phase(phase);

    // slave cfg, agent
    for(int i=0; i<NUM_OF_SLAVES; i++) begin
        slv_cfgs[i] = slv_cfg_t::type_id::create({$psprintf("slv_cfgs[%0d]", i)}, this);

        `SMTDV_RAND_WITH(slv_cfgs[i], {
            has_force == TRUE;    // force orignal vif behavior
            has_coverage == TRUE; // turn on coverage
            has_export == TRUE;   // export to sqlite3
            has_error == TRUE;    // rsp err
        })

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

        `SMTDV_RAND_WITH(mst_cfgs[i], {
          has_force == TRUE;    // force original vif behavior
          has_coverage == TRUE; // turn on coverage
          has_export == TRUE;   // export to sqlite3
          has_retry == TRUE;    // retry while rsp err
        })

        for(int j=0; j<NUM_OF_SLAVES; j++) begin
            start_addr = `APB_START_ADDR(j)
            end_addr = `APB_END_ADDR(j)
            mst_cfgs[i].add_slave(slv_cfgs[j], j, start_addr, end_addr);
        end

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

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    for(int i=0; i<NUM_OF_MASTERS; i++) begin
        mst_agts[i].mon.item_collected_port.connect(mst_scbs[i].initor[i]);
        for(int j=0; j<NUM_OF_SLAVES; j++) begin
            slv_agts[j].mon.item_collected_port.connect(mst_scbs[i].targets[j]);
        end
    end

  endfunction : connect_phase

endclass : apb_base_env

`endif // __APB_BASE_ENV_SV__
