
`ifndef __SMTDV_RESET_MODEL_SV__
`define __SMTDV_RESET_MODEL_SV__

typedef class smtdv_reset_monitor;

//===========================================
// Component Reset Group Declaration
//===========================================
class reset_comp_group extends uvm_object;

    static reset_comp_group sw_rst_aa [string];
    static reset_comp_group hw_rst_aa [string];
    static reset_comp_group comp_registered [uvm_component];
    static reset_comp_group grp_registered [string];

    uvm_component m_root_comp_q[$];
    uvm_component m_root_comp_ex_q[$];
    uvm_component m_comps_q[$];

    uvm_domain  m_rst_domain;

    `uvm_object_utils(reset_comp_group)

    function new(string name = "reset_comp_group");
      super.new(name);
    endfunction

    extern virtual function reset_comp_group get_rst_grp(string rst_grp_name,
                                                         rst_type_t rst_typ);


    extern virtual function void set_rst_domain(reset_comp_group rst_grp,
                                                uvm_domain domain);


    extern virtual function void create_rst_domain(reset_comp_group rst_grp);


    extern virtual function void set_reset_type(string rst_grp_name,
                                                rst_type_t rst_typ);


    extern virtual function void add_comp(string rst_grp_name,
                                          uvm_component comp_obj);


    extern virtual function void add_except_comp(string rst_grp_name,
                                                 uvm_component comp_obj);


    extern virtual function void resolve_comps(reset_comp_group rst_grp);


    extern virtual function void resolve_comps_recur(uvm_component root_comp,
                                                     ref uvm_component comps_q [$]);


    extern virtual function void show_comps(string rst_grp_name, bit show_root = 1);


    extern virtual task do_reset_jump(rst_type_t rst_typ);


    extern virtual task hw_reset();


    extern virtual task sw_reset();
endclass


function reset_comp_group reset_comp_group::get_rst_grp(string rst_grp_name,
                                                        rst_type_t rst_typ);
  case(rst_typ)
  HW_RST: begin
    if(!hw_rst_aa.exists(rst_grp_name)) begin
      `uvm_fatal(get_full_name(), $sformatf("Can't find HW rst_grp_name=%s",
        rst_grp_name))
      end
    return hw_rst_aa[rst_grp_name];
    end
  SW_RST: begin
    if(!sw_rst_aa.exists(rst_grp_name)) begin
      `uvm_fatal(get_full_name(), $sformatf("Can't find SW rst_grp_name=%s",
        rst_grp_name))
      end
    return sw_rst_aa[rst_grp_name];
    end
  default: begin
    `uvm_fatal(get_full_name(), $sformatf("Get unsupported rst_typ=%s",
      rst_typ.name()))
    end
  endcase
endfunction


function void reset_comp_group::set_rst_domain(reset_comp_group rst_grp,
                                               uvm_domain domain);
  rst_grp.m_rst_domain= domain;
  foreach(rst_grp.m_comps_q[i]) begin
    if(comp_registered.exists(rst_grp.m_comps_q[i])) begin
      `uvm_fatal(get_full_name(), $sformatf(
        {"comp_name=%s already has assigned to rst_grp_name=%s, ",
        "please use add_except_comp to filter out the unnecessary components."},
        rst_grp.m_comps_q[i].get_name(), comp_registered[rst_grp.m_comps_q[i]].get_name()))
      end
    rst_grp.m_comps_q[i].set_domain(domain, 0);
    comp_registered[rst_grp.m_comps_q[i]]= rst_grp;
    end
endfunction


function void reset_comp_group::create_rst_domain(reset_comp_group rst_grp);
  uvm_domain                      domain, common_domain;
  uvm_phase                       schedule;

  // UVM Runtime phases
  smtdv_pre_reset_phase         u_per_p= new();
  smtdv_reset_phase             u_r_p= new();
  smtdv_post_reset_phase        u_ptr_p= new();
  smtdv_pre_configure_phase     u_pec_p= new();
  smtdv_configure_phase         u_c_p= new();
  smtdv_post_configure_phase    u_ptc_p= new();
  smtdv_pre_main_phase          u_pem_p= new();
  smtdv_main_phase              u_m_p= new();
  smtdv_post_main_phase         u_ptm_p= new();
  smtdv_pre_shutdown_phase      u_pes_p= new();
  smtdv_shutdown_phase          u_s_p= new();
  smtdv_post_shutdown_phase     u_pts_p= new();

  domain= new({rst_grp.get_name(), "_domain"});
  schedule= new("uvm_sched", UVM_PHASE_SCHEDULE);
  schedule.add(u_per_p);
  schedule.add(u_r_p);
  schedule.add(u_ptr_p);
  schedule.add(u_pec_p);
  schedule.add(u_c_p);
  schedule.add(u_ptc_p);
  schedule.add(u_pem_p);
  schedule.add(u_m_p);
  schedule.add(u_ptm_p);
  schedule.add(u_pes_p);
  schedule.add(u_s_p);
  schedule.add(u_pts_p);
  domain.add(schedule);

  common_domain= uvm_domain::get_common_domain();
  common_domain.add(domain,
    .with_phase(common_domain.find(uvm_run_phase::get())));
  set_rst_domain(rst_grp, domain);
endfunction


function void reset_comp_group::set_reset_type(string rst_grp_name,
                                               rst_type_t rst_typ);
  reset_comp_group rst_grp;

  if(!grp_registered.exists(rst_grp_name))
    `uvm_fatal(get_full_name(), $sformatf(
      "set_reset_type should be called after add_comp/add_except_comp "))

  rst_grp= grp_registered[rst_grp_name];
  case(rst_typ)
  HW_RST: begin
    if(hw_rst_aa.exists(rst_grp_name))
      `uvm_fatal(get_full_name(), $sformatf(
        "HW reset group named: %s already exists!", rst_grp_name))
    hw_rst_aa[rst_grp_name]= rst_grp;
    end
  SW_RST: begin
    if(sw_rst_aa.exists(rst_grp_name))
      `uvm_fatal(get_full_name(), $sformatf(
        "SW reset group named: %s already exists!", rst_grp_name))
    sw_rst_aa[rst_grp_name]= rst_grp;
    end
  ALL_RST: begin
    if(hw_rst_aa.exists(rst_grp_name))
      `uvm_fatal(get_full_name(), $sformatf(
        "HW reset group named: %s already exists!", rst_grp_name))
    if(sw_rst_aa.exists(rst_grp_name))
      `uvm_fatal(get_full_name(), $sformatf(
        "SW reset group named: %s already exists!", rst_grp_name))
    hw_rst_aa[rst_grp_name]= rst_grp;
    sw_rst_aa[rst_grp_name]= rst_grp;
    end
  default: begin
    `uvm_fatal(get_full_name(), $sformatf("receives an unsupported rst_type=%s",
      rst_typ.name()))
    end
  endcase
  resolve_comps(rst_grp);
  create_rst_domain(rst_grp);
endfunction


function void reset_comp_group::add_comp(string rst_grp_name,
                                         uvm_component comp_obj);
  reset_comp_group rst_grp;

  if(!grp_registered.exists(rst_grp_name)) begin
    rst_grp= reset_comp_group::type_id::create(rst_grp_name);
    grp_registered[rst_grp_name]= rst_grp;
    end

  rst_grp= grp_registered[rst_grp_name];
  rst_grp.m_root_comp_q.push_back(comp_obj);
endfunction


function void reset_comp_group::add_except_comp(string rst_grp_name,
                                                uvm_component comp_obj);
  reset_comp_group rst_grp;

  if(!grp_registered.exists(rst_grp_name)) begin
    rst_grp= reset_comp_group::type_id::create(rst_grp_name);
    grp_registered[rst_grp_name]= rst_grp;
    end

  rst_grp= grp_registered[rst_grp_name];
  rst_grp.m_root_comp_ex_q.push_back(comp_obj);
endfunction


function void reset_comp_group::resolve_comps(reset_comp_group rst_grp);
  uvm_component comps_ex_q[$];
  uvm_component comp_q[$];
  int           idx_q[$];

  foreach(rst_grp.m_root_comp_q[i]) begin
    comp_q.delete();
    resolve_comps_recur(rst_grp.m_root_comp_q[i], comp_q);
    rst_grp.m_comps_q= {rst_grp.m_comps_q, rst_grp.m_root_comp_q[i], comp_q};
    end

  foreach(rst_grp.m_root_comp_ex_q[i]) begin
    comp_q.delete();
    resolve_comps_recur(rst_grp.m_root_comp_ex_q[i], comp_q);
    comps_ex_q= {comps_ex_q, rst_grp.m_root_comp_ex_q[i], comp_q};
    end

  foreach(comps_ex_q[i]) begin
    idx_q= rst_grp.m_comps_q.find_index with (item == comps_ex_q[i]);
    if(idx_q.size() != 1) begin
      `uvm_fatal(get_full_name(), $sformatf("Find comp reference(%s) size = %0d",
        comps_ex_q[i].get_name(), idx_q.size()))
      end
    rst_grp.m_comps_q.delete(idx_q[0]);
    uvm_config_db#(bit)::set(null, {comps_ex_q[i].get_full_name(), "*"}, "resetn", 1);
    idx_q.delete();
    end
endfunction


function void reset_comp_group::resolve_comps_recur(uvm_component root_comp, ref uvm_component comps_q [$]);
  uvm_component comp_q[$], child_comp_q[$];

  root_comp.get_children(child_comp_q);
  foreach(child_comp_q[i]) begin
    comp_q.delete();
    resolve_comps_recur(child_comp_q[i], comp_q);
    comps_q= {comps_q, child_comp_q[i], comp_q};
    end
endfunction


function void reset_comp_group::show_comps(string rst_grp_name, bit show_root = 1);
  uvm_component q[$];
  reset_comp_group rst_grp;

  if(!grp_registered.exists(rst_grp_name))
    `uvm_fatal(get_full_name(), $sformatf(
      "rst_grp_name=%s isn't registered yet", rst_grp_name))

  rst_grp= grp_registered[rst_grp_name];

  q= show_root ? rst_grp.m_root_comp_q : rst_grp.m_comps_q;
  foreach(q[i]) begin
    `uvm_info(rst_grp.get_name(), $sformatf("Get %0scomp_name=%s",
      (show_root) ? "root_" : "", q[i].get_full_name()),
      UVM_LOW);
    end
endfunction


task reset_comp_group::do_reset_jump(rst_type_t rst_typ);
  m_rst_domain.jump(m_rst_domain.find_by_name("reset"));
endtask


task reset_comp_group::hw_reset();
  string grp_name= this.get_name();
  reset_comp_group rst_grp;

  if(!hw_rst_aa.exists(grp_name)) begin
    `uvm_fatal(get_full_name(), $sformatf("Can't find the HW reset group named: %s",
      grp_name))
    end
  rst_grp= hw_rst_aa[grp_name];
  rst_grp.do_reset_jump(HW_RST);
endtask


task reset_comp_group::sw_reset();
  string grp_name= this.get_name();
  reset_comp_group rst_grp;

  if(!sw_rst_aa.exists(grp_name)) begin
    `uvm_fatal(get_full_name(), $sformatf("Can't find the SW reset group named: %s",
      grp_name))
    end
  rst_grp= sw_rst_aa[grp_name];
  rst_grp.do_reset_jump(SW_RST);
endtask


//===========================================
// Reset Model Declaration
//===========================================
class smtdv_reset_model #(type VIF = int) extends reset_comp_group;

  VIF         vif;

  rst_type_t  rst_typ;

  `uvm_object_param_utils(smtdv_reset_model#(VIF))

  function new(string name = "smtdv_reset_model");
    super.new(name);
  endfunction

  extern virtual function void set_rst_type(rst_type_t rst_typ);
  extern virtual function void add_component(uvm_component comp_obj);
  extern virtual function void remove_component(uvm_component comp_obj);
  extern virtual function void create_rst_monitor(VIF vif = null);
  extern virtual function void show_components(bit show_root = 1);

  extern virtual task do_hw_reset(time rst_period = 1000);
  extern virtual task wait_hw_reset_done();
  extern virtual task do_sw_reset();
endclass


function void smtdv_reset_model::set_rst_type(rst_type_t rst_typ);

  if(rst_typ inside {HW_RST, ALL_RST}) begin
    if(this.vif == null) begin
      `uvm_fatal(get_full_name(),
        "Should set a virtual interface for a reset group with reset type=HW_RST/ALL_RST")
      end
    end

  set_reset_type(get_name(), rst_typ);
  this.rst_typ= rst_typ;
endfunction


function void smtdv_reset_model::add_component(uvm_component comp_obj);
  add_comp(get_name(), comp_obj);
  uvm_config_db#(bit)::set(null, {comp_obj.get_full_name(), "*"}, "resetn", 0);
endfunction


function void smtdv_reset_model::remove_component(uvm_component comp_obj);
  add_except_comp(get_name(), comp_obj);
endfunction


function void smtdv_reset_model::create_rst_monitor(VIF vif = null);
  smtdv_reset_monitor #(VIF) rst_mon;

  rst_mon= smtdv_reset_monitor#(VIF)::type_id::create({get_name(), "_rst_mon"}, null);
  rst_mon.vif= vif;
  rst_mon.set_rst_model(this);
  add_component(rst_mon);

  this.vif= vif;
endfunction


function void smtdv_reset_model::show_components(bit show_root = 1);
  show_comps(get_name(), show_root);
endfunction


task smtdv_reset_model::do_hw_reset(time rst_period = 1000);
  reset_comp_group rst_grp;

  rst_grp= get_rst_grp(get_name(), HW_RST);
  vif.do_reset(rst_period);
  rst_grp.hw_reset();
endtask


task smtdv_reset_model::wait_hw_reset_done();
  if(rst_typ inside {HW_RST, ALL_RST}) begin
    vif.wait_reset_done();
    end
  else begin
    `uvm_warning(get_full_name(),
      $sformatf(
        {
          "Skipping wait_hw_reset_done() call: ",
          "A reset group with %s type ",
          "doesn't have a virtual interface to wait"
        }, rst_typ.name()
      )
    )
    end
endtask


task smtdv_reset_model::do_sw_reset();
  reset_comp_group rst_grp;

  rst_grp= get_rst_grp(get_name(), SW_RST);
  rst_grp.sw_reset();
endtask

`endif // end of __SMTDV_RESET_MODEL_SV__
