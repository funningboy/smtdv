import svunit_pkg::*;

`ifdef RUN_SVUNIT_WITH_UVM
  import uvm_pkg::*;
  import svunit_uvm_mock_pkg::*;
`endif

module testrunner();
  string name = "testrunner";
  svunit_testrunner svunit_tr;


  //==================================
  // These are the test suites that we
  // want included in this testrunner
  //==================================
  __modules_apb_slave_testsuite __modules_apb_slave_ts();
  __uvm_simple_model_testsuite __uvm_simple_model_ts();
  __uvm_uvm_express_testsuite __uvm_uvm_express_ts();
  __uvm_uvm_report_mock_testsuite __uvm_uvm_report_mock_ts();


  //===================================
  // Main
  //===================================
  initial
  begin

    `ifdef RUN_SVUNIT_WITH_UVM_REPORT_MOCK
      uvm_report_cb::add(null, uvm_report_mock::reports);
    `endif

    build();

    `ifdef RUN_SVUNIT_WITH_UVM
      svunit_uvm_test_inst("svunit_uvm_test");
    `endif

    run();
    $finish();
  end


  //===================================
  // Build
  //===================================
  function void build();
    svunit_tr = new(name);
    __modules_apb_slave_ts.build();
    svunit_tr.add_testsuite(__modules_apb_slave_ts.svunit_ts);
    __uvm_simple_model_ts.build();
    svunit_tr.add_testsuite(__uvm_simple_model_ts.svunit_ts);
    __uvm_uvm_express_ts.build();
    svunit_tr.add_testsuite(__uvm_uvm_express_ts.svunit_ts);
    __uvm_uvm_report_mock_ts.build();
    svunit_tr.add_testsuite(__uvm_uvm_report_mock_ts.svunit_ts);
  endfunction


  //===================================
  // Run
  //===================================
  task run();
    __modules_apb_slave_ts.run();
    __uvm_simple_model_ts.run();
    __uvm_uvm_express_ts.run();
    __uvm_uvm_report_mock_ts.run();
    svunit_tr.report();
  endtask


endmodule
