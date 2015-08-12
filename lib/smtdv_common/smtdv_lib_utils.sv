
`ifndef __SMTDV_LIB_UTILS_SV__
`define __SMTDV_LIB_UTILS_SV__

class smtdv_timeout_cb extends uvm_report_catcher;

  string            id      = "PH_TIMEOUT";
  string            re_msg  = "/.*timeout of.*indicating a probable testbench issue/";

  uvm_phase         m_run_ph;
  uvm_objection     run_obj;

  `uvm_object_utils_begin(smtdv_timeout_cb)
  `uvm_object_utils_end

  function new(string name = "smtdv_timeout_cb");
    super.new(name);
  endfunction

  virtual function action_e catch();
    int               not_match;

    not_match= uvm_re_match(re_msg, get_message());

    if((get_id() == id) && (!not_match) && (uvm_severity_type'(get_severity()) == UVM_FATAL)) begin
      `uvm_info(get_full_name(),
        $sformatf("Catch a TIMEOUT message from reporter"),
        UVM_NONE)
      run_obj= m_run_ph.get_objection();
      run_obj.display_objections();
      end
    return THROW;
  endfunction

endclass

// *********************************************************************
class smtdv_severity_change_cb extends uvm_report_catcher;

  string            id;
  string            re_msg;
  uvm_severity_type ovr_sv_t;

  `uvm_object_utils_begin(smtdv_severity_change_cb)
    `uvm_field_string(id, UVM_ALL_ON)
    `uvm_field_string(re_msg, UVM_ALL_ON)
    `uvm_field_enum(uvm_severity_type, ovr_sv_t, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_severity_change_cb");
    super.new(name);
  endfunction

  virtual function action_e catch();
    uvm_severity_type orig_sv_t;
    int               not_match;

    not_match= (re_msg == "") ? 0 : uvm_re_match(re_msg, get_message());

    if((get_id() == id) && (!not_match) && (uvm_severity_type'(get_severity()) != ovr_sv_t)) begin
      orig_sv_t= uvm_severity_type'(get_severity());
      set_severity(ovr_sv_t);
      `uvm_info(get_full_name(),
        $sformatf(
          {
            "Trying to overwrite the severity of a MSG ID=[%0s] with RE_MSG=[%0s] ",
            "from %s to %s"
          }, id, re_msg, orig_sv_t.name(), ovr_sv_t.name()),
        UVM_DEBUG
      )
      end
    return THROW;
  endfunction

endclass


`endif // end of __SMTDV_LIB_UTILS_SV__
