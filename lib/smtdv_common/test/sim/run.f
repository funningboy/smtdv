-uvm
-64bit
-access rwc
-status
-top top
# xbus_1w1r_test, xbus_rand_test, xbus_stl_test
+UVM_TESTNAME=xbus_stl_test
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
+incdir+../../
+incdir+../
+incdir+../test
+incdir+../seq
+incdir+../v
+incdir+./
+incdir+../../../../dpi/sqlite3
+incdir+../../../../dpi/stl
../../smtdv_common_pkg.sv
../../../../dpi/sqlite3/smtdv_sqlite3_pkg.sv
../../../../dpi/stl/smtdv_stl_pkg.sv
../xbus_pkg.sv
../test/xbus_top.sv
../v/xbus_slave.v
-sv_lib ../../../../dpi/sqlite3/dpi_smtdv_lib.so
-sv_lib ../../../../dpi/stl/dpi_smtdv_stl.so
-input simvision.tcl
-batch

