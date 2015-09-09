import svunit_pkg::*;

module __uvm_uvm_express_testsuite;
  string name = "__uvm_uvm_express_ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  apb_coverage_agent_unit_test apb_coverage_agent_ut();
  apb_mon_unit_test apb_mon_ut();
  apb_if_unit_test apb_if_ut();
  apb_coverage_unit_test apb_coverage_ut();


  //===================================
  // Build
  //===================================
  function void build();
    apb_coverage_agent_ut.build();
    apb_mon_ut.build();
    apb_if_ut.build();
    apb_coverage_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(apb_coverage_agent_ut.svunit_ut);
    svunit_ts.add_testcase(apb_mon_ut.svunit_ut);
    svunit_ts.add_testcase(apb_if_ut.svunit_ut);
    svunit_ts.add_testcase(apb_coverage_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    apb_coverage_agent_ut.run();
    apb_mon_ut.run();
    apb_if_ut.run();
    apb_coverage_ut.run();
    svunit_ts.report();
  endtask

endmodule
