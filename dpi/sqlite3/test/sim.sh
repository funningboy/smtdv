#!/bin/csh -f

vsim \
-c -do 'run 1000us; quit ' \
+notimingchecks \
-suppress 3829 \
-64 \
-novopt \
-l $1_simulation.log \
-L work \
test \
+incdir+../ \
-gblso ../dpi_smtdv_lib.so
