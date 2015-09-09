run_mti:
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
	../smtdv_sqlite3_pkg.sv \
	test_dpi_smtdv.sv

	vsim \
	-c -do 'run -all; quit ' \
	+notimingchecks \
	-suppress 3829 \
	-64 \
	-novopt \
	-l $1_simulation.log \
	-L work \
	test \
	+incdir+../ \
	-gblso ../dpi_smtdv_lib.so

clean_mti:
	rm -rf work
	rm -rf *.log
	rm -rf *.db
	rm -rf cov_work
	rm -rf waves.shm

run_ius:
	#-linedebug
	#-lineuvmdebug
	irun \
	-64bit \
	-access rwc \
	-status \
	-top test \
	-covoverwrite \
	-coverage b:u \
	+nccoverage+functional \
	+notchkmsg \
	+notimingchecks \
	+no_notifier \
	+define+SVA \
	+incdir+./ \
	+incdir+../ \
	../smtdv_sqlite3_pkg.sv \
	./test_dpi_smtdv.sv \
	-sv_lib ../dpi_smtdv_lib.so \
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
