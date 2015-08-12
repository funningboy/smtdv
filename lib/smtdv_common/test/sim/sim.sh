#!/bin/csh -f

vsim \
-c -do 'run 1000us; quit ' \
+notimingchecks \
-suppress 3829 \
-64 \
-vopt \
-l $1_simulation.log \
-L work \
top \
+incdir+../../ \
+incdir+../ \
+incdir+../test \
+incdir+../seq \
+incdir+../v \
+incdir+./ \
+incdir+../../../../dpi/sqlite3 \
-gblso ../../../../dpi/sqlite3/dpi_smtdv_lib.so \
+UVM_TESTNAME=xbus_1w1r_test \
+UVM_VERBOSITY=UVM_FULL
