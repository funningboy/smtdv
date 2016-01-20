import svunit_pkg::*;

module __modules_apb_slave_testsuite;
  string name = "__modules_apb_slave_ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  apb_slave_unit_test apb_slave_ut();


  //===================================
  // Build
  //===================================
  function void build();
    apb_slave_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(apb_slave_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    apb_slave_ut.run();
    svunit_ts.report();
  endtask

endmodule
