import svunit_pkg::*;

module __uvm_uvm_report_mock_testsuite;
  string name = "__uvm_uvm_report_mock_ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  uut_unit_test uut_ut();


  //===================================
  // Build
  //===================================
  function void build();
    uut_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(uut_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    uut_ut.run();
    svunit_ts.report();
  endtask

endmodule
