
mv work a
\rm -rf a &

# Testbench files
vlib work
vlog \
-timescale 10ps/1ps \
+notimingchecks \
-vopt \
-64 \
-suppress 2240 \
-suppress 2181 \
-suppress 2239 \
-sv \
+libext+_ncverilog.v+.v+.sv \
-l compile.log \
+incdir+../../ \
+incdir+../ \
+incdir+../test \
+incdir+../seq \
+incdir+../v \
+incdir+./ \
+incdir+../../../../dpi/sqlite3 \
../../../../dpi/sqlite3/smtdv_sqlite3_pkg.sv \
../../smtdv_common_pkg.sv \
../xbus_pkg.sv
#../test/xbus_top.sv

