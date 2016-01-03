
`ifndef __SMTDV_COMPONENT_SV__
`define __SMTDV_COMPONENT_SV__

typedef class smtdv_cfg;

/**
* smtdv_component
* a basic smtdv component
*
* @class smtdv_component#(CMP, VIF, CFG)
*
*/
class smtdv_component #(
  type COMP = uvm_component,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_cfg)
    extends
    COMP;

  typedef smtdv_component#(COMP, VIF, CFG) cmp_t;

  VIF vif;
  CFG cfg;
  // An indicator showing if the Power-On Reset is completed
  bit         pwrst_done    = FALSE;
  // An indicator showing the type of the incoming reset {HW_RST, SW_RST, PWR_RST}
  rst_type_t  rst_typ       = NOT_VALID;
  // A Reset flag for component to deal with its internal reset scheme
  bit         resetn        = TRUE;
  bit         finish        = FALSE;

  // used to record the time interval in reset phase
  time        reset_phase_start   = 0;
  time        reset_phase_end     = 0;
  time        reset_phase_period  = 0;

  `uvm_component_param_utils_begin(cmp_t)
    `uvm_field_int(resetn, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_component", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  extern virtual function void start_of_simulation_phase(uvm_phase phase);

  // Internal use
  extern virtual function string get_severity_status_str(bit all, uvm_severity sv);

  // Reset Handling
  extern virtual function void phase_started(uvm_phase phase);
  extern virtual function void phase_ended(uvm_phase phase);

  // User APIs
  extern virtual function void clear_global_report( bit           clr_all = 0,
                                                    uvm_severity  sv      = UVM_ERROR);
  extern virtual function void change_id_severity(string id, string re_msg = "", uvm_severity sv);

endclass : smtdv_component


function void smtdv_component::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  if(!uvm_config_db#(bit)::get(this, "", "resetn", resetn)) begin
    resetn= 1;
    end
  `uvm_info(get_full_name(),
    $sformatf("The initial \"resetn\" flag has been set to %b", resetn),
    UVM_FULL)
endfunction


function void smtdv_component::clear_global_report(bit           clr_all = 0,
                                                  uvm_severity  sv      = UVM_ERROR);
  uvm_report_server rpt_svr;
  uvm_severity_type sv_t;
  string            before_stat, after_stat;

  rpt_svr= get_report_server();

  before_stat= get_severity_status_str(clr_all, sv);
  if(clr_all) begin
    rpt_svr.reset_severity_counts();
    end
  else begin
    sv_t= uvm_severity_type'(sv);
    rpt_svr.set_severity_count(sv, 0);
    end
  after_stat= get_severity_status_str(clr_all, sv);

  `uvm_warning(get_full_name(),
    $sformatf(
      {
        "\nTrying to clear %s severity count:\n",
        "BEFORE:\n%s",
        "AFTER:\n%s"
      },
        (clr_all) ? "ALL" : sv_t.name(),
        before_stat,
        after_stat
    )
  )
endfunction


function string smtdv_component::get_severity_status_str(bit all, uvm_severity sv);
  string            stat_str;
  uvm_severity_type sv_t;
  uvm_report_server rpt_svr;

  rpt_svr= get_report_server();

  stat_str= "";
  if(all) begin
    sv_t = sv_t.first();
    forever begin
      stat_str= {stat_str, $sformatf("\t%11s counts: 'd%0d\n", sv_t.name(), rpt_svr.get_severity_count(sv_t))};
      if(sv_t == sv_t.last()) break;
      sv_t = sv_t.next();
      end
    end
  else begin
    sv_t= uvm_severity_type'(sv);
    stat_str= $sformatf("\t%11s counts: 'd%0d\n", sv_t.name(), rpt_svr.get_severity_count(sv_t));
    end

  return stat_str;
endfunction


function void smtdv_component::change_id_severity(string id, string re_msg = "", uvm_severity sv);
  smtdv_severity_change_cb sv_cb;

  sv_cb= smtdv_severity_change_cb::type_id::create({"sv_cb_", id});
  sv_cb.id= id;
  sv_cb.re_msg= re_msg;
  sv_cb.ovr_sv_t= uvm_severity_type'(sv);

  // Applies to all report objects
  uvm_report_cb::add(null, sv_cb);
endfunction


function void smtdv_component::phase_started(uvm_phase phase);
  super.phase_started(phase);

  if(phase.get_name() == "reset") begin
    reset_phase_start= $time;
    if(pwrst_done)
      resetn= 0;
    end

  if(phase.get_name() == "post_reset") begin
    if(rst_typ inside {HW_RST, SW_RST, PWR_RST}) begin
      `uvm_info(get_full_name(),
        $sformatf("Detect a %s", rst_typ.name()),
        UVM_FULL)
      end
    end
endfunction


function void smtdv_component::phase_ended(uvm_phase phase);
  super.phase_ended(phase);

  if(phase.get_name() == "reset") begin
    reset_phase_end= $time;
    reset_phase_period= reset_phase_end - reset_phase_start;
    if(!pwrst_done) begin
      if(reset_phase_period) begin
        rst_typ= PWR_RST;
        end
      else begin
        // This block will be entered when reset signal is deasserted at time 0,
        // and which meands reset_phase_period will be a zero value (reset phase consumes zero delay).
        // But, since uVC can't drive any transaction before the Power-On reset sequence,
        // so just wait for the assetion of the Power-On reset (done by run_phase of reset monitor),
        // then the reset phase will be jumped into again (done by reset model),
        // which makes reset_phase_period a non-zero value.
        end
      end
    else begin
      if(reset_phase_period) begin
        rst_typ= HW_RST;
        end
      else begin
        rst_typ= SW_RST;
        end
      end
    end

  if(phase.get_name() == "post_reset") begin
    if(rst_typ inside {HW_RST, SW_RST, PWR_RST}) begin
      if(rst_typ == PWR_RST)
        pwrst_done= 1;
      resetn= 1;
      end
    rst_typ= NOT_VALID;
    end
endfunction


`endif // end of __SMTDV_COMPONENT_SV__
