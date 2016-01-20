import svunit_pkg::*;

module __uvm_simple_model_testsuite;
  string name = "__uvm_simple_model_ts";
  svunit_testsuite svunit_ts;
  
  
  //===================================
  // These are the unit tests that we
  // want included in this testsuite
  //===================================
  simple_model_unit_test simple_model_ut();


  //===================================
  // Build
  //===================================
  function void build();
    simple_model_ut.build();
    svunit_ts = new(name);
    svunit_ts.add_testcase(simple_model_ut.svunit_ut);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    svunit_ts.run();
    simple_model_ut.run();
    svunit_ts.report();
  endtask

endmodule
