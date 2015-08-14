-uvm
-64bit
-access rwc
-status
-top top
+UVM_TESTNAME=apb_1w1r_test
#+UVM_VERBOSITY=UVM_FULL
+UVM_VERBOSITY=UVM_DEBUG
-covoverwrite
-coverage b:u
+nccoverage+functional
+notchkmsg
+notimingchecks
+no_notifier
+define+SVA
#-linedebug
#-lineuvmdebug
+incdir+../../smtdv_common
+incdir+../
+incdir+../test
+incdir+../seq
+incdir+../v
+incdir+./
+incdir+../../../dpi/sqlite3
../../smtdv_common/smtdv_common_pkg.sv
./../../../dpi/sqlite3/smtdv_sqlite3_pkg.sv
../apb_pkg.sv
../test/apb_top.sv
-sv ../v/dut_apb_1m2s.v
-sv_lib ../../../dpi/sqlite3/dpi_smtdv_lib.so
-input simvision.tcl
-batch

