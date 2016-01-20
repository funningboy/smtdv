
`ifndef __APB_FWCTRL_TEST_SV__
`define __APB_FWCTRL_TEST_SV__

//class apb_fwctrl_test
//  extends `APB_FWCTRL_TEST;
//
//  `uvm_component_utils(`APB_FWCTRL_TEST)
//
//  function new(string name = "apb_fwctrl_test", uvm_component parent=null);
//    super.new(name, parent);
//  endfunction
//
//  virtual function void build_phase(uvm_phase phase);
//    super.build_phase(phase);
//
//    // cpu master cfg, agent
//    master_cfg[1] = `APB_MASTER_CFG::type_id::create({$psprintf("master_cfg[%0d]", 1)}, this);
//    `SMTDV_RAND_WITH(master_cfg[1], {
//      has_force == 1;
//      has_coverage == 0;
//      has_export == 0;
//    })
//    master_agent[1] = `APB_MASTER_AGENT::type_id::create({$psprintf("cpu_master_agent[%0d]", 1)}, this);
//    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+cpu_master_agent[*1]*/", "is_active", UVM_ACTIVE);
//    uvm_config_db#(`APB_MASTER_CFG)::set(null, "/.+cpu_master_agent[*1]*/", "cfg", master_cfg[1]);
//
//    // load event listener preload seq to force drived master
//    uvm_config_db#(uvm_object_wrapper)::set(this,
//      "*master_agent[*0]*.seqr.run_phase",
//      "default_sequence",
//      `APB_MASTER_PRELOAD_SEQ::type_id::get());
//
//
//
//  endfunction
//
//
//
//endclass


`endif // end of __APB_FWCTRL_TEST_SV__
