-64bit
-access rwc
-status
-top test
-covoverwrite
-coverage b:u
+nccoverage+functional
+notchkmsg
+notimingchecks
+no_notifier
+define+SVA
#-linedebug
#-lineuvmdebug
+incdir+./
+incdir+../
../smtdv_sqlite3_pkg.sv
./test_dpi_smtdv.sv
-sv_lib ../dpi_smtdv_lib.so
-input simvision.tcl
-batch

