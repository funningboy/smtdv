import svunit_pkg::*;

module __testsuite;
  string name = "__ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  bogus_unit_test bogus_ut();


  //===================================
  // Build
  //===================================
  function void build();
    bogus_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(bogus_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    bogus_ut.run();
    svunit_ts.report();
  endtask

endmodule
