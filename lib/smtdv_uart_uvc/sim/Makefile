
run_mti:
	vlib work
	vlog \
	-vopt \
	-timescale 10ps/1ps \
	+notimingchecks \
	-64 \
	-suppress 2240 \
	-suppress 2181 \
	-suppress 2239 \
	-sv \
	+libext+_ncverilog.v+.v+.sv \
	-l compile.log \
	+incdir+../sv \
	+incdir+../../smtdv_common \
	+incdir+../ \
	+incdir+../test \
	+incdir+../seq \
	+incdir+../v \
	+incdir+./ \
	+incdir+../../../dpi/sqlite3 \
	+incdir+../../../dpi/stl \
	../../smtdv_common/smtdv_common_pkg.sv \
	../../../dpi/sqlite3/smtdv_sqlite3_pkg.sv \
	../../../dpi/stl/smtdv_stl_pkg.sv \
	../sv/uart_pkg.sv \
	../test/uart_top.sv \
	-sv ../v/dut_uart_1m1s.v

#	-c -do 'run -all; quit ' \

	vsim \
	-vopt \
	-c -do 'run -all; quit ' \
	+notimingchecks \
	-suppress 3829 \
	-64 \
	-l $1_simulation.log \
	-L work \
	top \
	+incdir+../sv \
	+incdir+../../smtdv_common \
	+incdir+../ \
	+incdir+../test \
	+incdir+../seq \
	+incdir+../v \
	+incdir+./ \
	+incdir+../../../dpi/sqlite3 \
	+incdir+../../../dpi/stl \
	-gblso ../../../dpi/sqlite3/dpi_smtdv_lib.so \
	-gblso ../../../dpi/stl/dpi_smtdv_stl.so \
	+UVM_TESTNAME=uart_seq_test \
	+UVM_VERBOSITY=UVM_FULL

clean_mti:
	rm -rf work
	rm -rf *.log
	rm -rf *.db
	rm -rf cov_work
	rm -rf waves.shm

# uart_1w1r_test, uart_rand_test, uart_stl_test
#-linedebug
#-lineuvmdebug
run_ius:
	irun \
	-uvm \
	-64bit \
	-access rwc \
	-status \
	-top top \
	+UVM_TESTNAME=uart_seq_test \
	+UVM_VERBOSITY=UVM_DEBUG \
	-covoverwrite \
	-coverage b:u \
	+nccoverage+functional \
	+notchkmsg \
	+notimingchecks \
	+no_notifier \
	+define+SVA \
	+incdir+../sv \
	+incdir+../../smtdv_common \
	+incdir+../ \
	+incdir+../test \
	+incdir+../seq \
	+incdir+../v \
	+incdir+./ \
	+incdir+../../../dpi/sqlite3 \
	+incdir+../../../dpi/stl \
	../../smtdv_common/smtdv_common_pkg.sv \
	../../../dpi/sqlite3/smtdv_sqlite3_pkg.sv \
	../../../dpi/stl/smtdv_stl_pkg.sv \
	../sv/uart_pkg.sv \
	../test/uart_top.sv \
	-sv ../v/dut_uart_1m1s.v \
	-sv_lib ../../../dpi/sqlite3/dpi_smtdv_lib.so \
	-sv_lib ../../../dpi/stl/dpi_smtdv_stl.so \
	-input simvision.tcl \
	-batch

clean_ius:
	rm -rf INCA_libs
	rm -rf *.log
	rm -rf *.db
	rm -rf cov_work
	rm -rf waves.shm

run_all: run_mti run_ius

clean_all: clean_mti clean_ius
	rm -rf INCA_libs
	rm -rf cov_work
	rm -rf *.log
	rm -rf *.vcd
	rm -rf *.fsdb
	rm -rf nWaveLog
	rm -rf novas*
	rm -rf waves.shm
	rm -rf vfastLog

