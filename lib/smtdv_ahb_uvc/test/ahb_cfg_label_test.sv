`ifndef __AHB_CFG_LABEL_TEST_SV__
`define __AHB_CFG_LABEL_TEST_SV__

//typedef class apb_base_test;
//typedef class apb_master_stl_seq;

class apb_cfg_label_test
  extends
  apb_base_test;

  typedef apb_cfg_label_test test_t;
  typedef apb_master_stl_vseq m_vseq_t;
  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;

  typedef apb_master_cfg mst_cfg_t;
  typedef apb_master_agent#(ADDR_WIDTH, DATA_WIDTH) mst_agt_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef smtdv_run_label blab_t;

  // bind force_replay_label at master
  typedef smtdv_force_replay_label#(
    ADDR_WIDTH,
    DATA_WIDTH,
    mst_cfg_t,
    mst_agt_t,
    item_t) cfg_lab_t;

  cfg_lab_t cfg_labs[$];

  `uvm_component_utils(apb_cfg_label_test)

  function new(string name = "apb_cfg_label_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "vseqr.run_phase",
      "default_sequence",
      m_vseq_t::type_id::get());

    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*slv_agts[*0]*.seqr.run_phase",
      "default_sequence",
      s_bseq_t::type_id::get());

    cfg_labs[0] = cfg_lab_t::type_id::create("apb_force_replay_label", this);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    blab_t blab;

    super.connect_phase(phase);

    $cast(blab, cfg_labs[0]);
    smtdv_label_handler::add(blab, TRUE);

  endfunction : connect_phase


  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    cmp_envs[0].slv_agts[0].cfg.has_error = FALSE;

    cfg_labs[0].set('{
        WR,
        `AHB_SLAVE_START_ADDR_0,
        1,
        cmp_envs[0].mst_agts[0],
        cmp_envs[0].mst_agts[0].cfg
    });

  endfunction : end_of_elaboration_phase


  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);

    if (cmp_envs[0].mst_agts[0].cfg.stlid != 7)
      `uvm_error("SMTDV_CFG_LABEL",
         {$psprintf("REPLAY CFG LABEL UPDATED FAIL %d!=7", cmp_envs[0].mst_agts[0].cfg.stlid)})

  endfunction : check_phase

endclass : apb_cfg_label_test

`endif // end of __AHB_CFG_LABEL_TEST_SV__
