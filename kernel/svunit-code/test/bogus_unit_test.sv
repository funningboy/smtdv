`include "svunit_defines.svh"
`include "svunit_pkg.sv"
`include "bogus.sv"

import svunit_pkg::*;


module bogus_unit_test;

  string name = "bogus_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're
  // running the Unit Tests on
  //===================================
  bogus my_bogus;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    my_bogus = new(/* New arguments if needed */);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
  endtask


  //===================================
  // Here we deconstruct anything we
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  `SVTEST(mytest)
    $display("i am here");
  `SVTEST_END

  `SVUNIT_TESTS_END

endmodule
