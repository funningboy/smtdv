
`ifndef __CDN_BASE_TEST_SV__
`define __CDN_BASE_TEST_SV__

class cdn_base_test
  extends
  smtdv_test;

  `CDN_CLUSTER0 env0;
  `CDN_CLUSTER1 env1;

  `CDN_RST_VIF cdn_rst_vif;
  smtdv_reset_model #(`CDN_RST_VIF) cdn_rst_model;

  `uvm_component_param_utils_begin(`CDN_BASE_TEST)
  `uvm_component_utils_end

  function new(string name = "cdn_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //sqlite3
    smtdv_sqlite3::delete_db("cdn_busmatrix.db");
    smtdv_sqlite3::new_db("cdn_busmatrix.db");

    // build up your cluster env for power domain partition issue
    env0 = `CDN_CLUSTER0::type_id::create("cdn_cluster0", this);
    env1 = `CDN_CLUSTER1::type_id::create("cdn_cluster1", this);

    // resetn
    cdn_rst_model = smtdv_reset_model#(`CDN_RST_VIF)::type_id::create("cdn_rst_model");
    if(!uvm_config_db#(`CDN_RST_VIF)::get(this, "", "cdn_rst_vif", cdn_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".cdn_rst_vif"});
    cdn_rst_model.create_rst_monitor(cdn_rst_vif);

  endfunction

 virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    cdn_rst_model.add_component(this.env0);
    cdn_rst_model.add_component(this.env1);
    cdn_rst_model.set_rst_type(ALL_RST);
    cdn_rst_model.show_components(0);
  endfunction

endclass


`endif // __CDN_BASE_TEST_SV__
