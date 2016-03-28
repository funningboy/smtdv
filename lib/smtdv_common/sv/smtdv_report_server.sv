
`ifndef __SMTDV_REPORT_SERVER_SV__
`define __SMTDV_REPORT_SERVER_SV__

/**
* smtdv_report_server
*
* @class smtdv_report_server
*
*/
class smtdv_report_server extends uvm_report_server;

  bit en_filename = 1;
  bit en_line     = 1;
  bit en_time     = 1;
  bit en_name     = 1;
  bit en_id       = 1;

  function new();
    super.new();
  endfunction

  extern virtual function void set_display_mode(bit [4:0] en_mask);

  extern virtual function string compose_message( uvm_severity severity,
                                                  string name,
                                                  string id,
                                                  string message,
                                                  string filename,
                                                  int    line);

  extern virtual function void summarize(UVM_FILE file=0);

endclass


function void smtdv_report_server::set_display_mode(bit [4:0] en_mask);
  {en_filename, en_line, en_time, en_name, en_id}= en_mask;
endfunction


function string smtdv_report_server::compose_message(uvm_severity severity,
                                                  string name,
                                                  string id,
                                                  string message,
                                                  string filename,
                                                  int    line);
  uvm_severity_type sv;
  string time_str;
  string line_str;

  sv = uvm_severity_type'(severity);
  $swrite(time_str, "%0t", $realtime);

  case(1)
  (name == "" && filename == ""):
    return {sv.name(),
            (en_time) ? {" @ ", time_str} : "",
            (en_id)   ? {" [", id, "] "}  : " ",
            message};

  (name != "" && filename == ""):
    return {sv.name(),
            (en_time) ? {" @ ", time_str, ": "} : " ",
            (en_name) ? name : "",
            (en_id)   ? {" [", id, "] "} : " ",
            message};

  (name == "" && filename != ""): begin
    $swrite(line_str, "%0d", line);
    return {sv.name(), " ",
            (en_filename)           ? filename : "",
            (en_filename & en_line) ? {"(", line_str, ")"} : "",
            (en_time)               ? {" @ ", time_str} : "",
            (en_id)                 ? {" [", id, "] "} : " ",
            message};
    end

  (name != "" && filename != ""): begin
    $swrite(line_str, "%0d", line);
    return {sv.name(), " ",
            (en_filename)           ? filename : "",
            (en_filename & en_line) ? {"(", line_str, ")"} : "",
            (en_time)               ? {" @ ", time_str} : "",
            (en_name)               ? {": ", name} : "",
            (en_id)                 ? {" [", id, "] "} : " ",
            message};
    end

  endcase
endfunction


function void smtdv_report_server::summarize(UVM_FILE file=0);
  string test_name;
  super.summarize(file);

  f_display(file, "");
  f_display(file,   "=============================================================");

  if(get_severity_count(UVM_FATAL) + get_severity_count(UVM_ERROR))
    f_display(file, "                         TEST FAILED ");
  else
    f_display(file,
      $sformatf({"                         TEST PASSED ", get_severity_count(UVM_WARNING) ? "with %0d UVM_WARNING(S)" : ""},
        get_severity_count(UVM_WARNING)));

  f_display(file, "");
  f_display(file, "");
  f_display(file,
      $sformatf({"release date: %s, version: %s, license: %s"},
      about.date,
      about.version,
      about.license
  ));

  foreach(about.authors[i])
    f_display(file,
      $sformatf({"author: %s, mail: %s"}, about.authors[i].name, about.authors[i].mail));

  f_display(file,   "=============================================================");
  f_display(file, "");

  if(get_severity_count(UVM_FATAL) + get_severity_count(UVM_ERROR))
    if ($value$plusargs("UVM_TESTNAME=%s", test_name))
        setenv(test_name, "FAILED", 1);
  else
     if ($value$plusargs("UVM_TESTNAME=%s", test_name))
        setenv(test_name, "PASSED", 1);

endfunction

`endif // end of __SMTDV_REPORT_SERVER_SV__
