CHILD_UNITTESTS += ./uvm/simple_model/simple_model_unit_test.sv ./uvm/uvm_express/apb_coverage_agent_unit_test.sv ./uvm/uvm_express/apb_mon_unit_test.sv ./uvm/uvm_express/apb_if_unit_test.sv ./uvm/uvm_express/apb_coverage_unit_test.sv ./uvm/uvm_report_mock/uut_unit_test.sv

INCDIR += ./uvm/simple_model ./uvm/uvm_express ./uvm/uvm_express ./uvm/uvm_express ./uvm/uvm_express ./uvm/uvm_report_mock

CHILD_TESTSUITES = ./uvm/simple_model/.__uvm_simple_model_testsuite.sv ./uvm/uvm_express/.__uvm_uvm_express_testsuite.sv ./uvm/uvm_report_mock/.__uvm_uvm_report_mock_testsuite.sv



-include svunit.mk
include $(SVUNIT_INSTALL)/bin/cfg.mk
