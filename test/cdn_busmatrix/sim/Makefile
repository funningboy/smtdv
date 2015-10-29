
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
	+incdir+${UVM_REF_HOME}/lib/smtdv_common \
	+incdir+${UVM_REF_HOME}/dpi/sqlite3 \
	+incdir+${UVM_REF_HOME}/dpi/stl \
	+incdir+${UVM_REF_HOME}/lib/smtdv_ahb_uvc/sv \
	+incdir+${UVM_REF_HOME}/lib/smtdv_ahb_uvc/seq \
	+incdir+${UVM_REF_HOME}/lib/smtdv_apb_uvc/sv \
	+incdir+${UVM_REF_HOME}/lib/smtdv_apb_uvc/seq \
	+incdir+${UVM_REF_HOME}/designs/socv/rtl/rtl_lpw/cdn_busmatrix \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/sv \
	+incdir+${UVM_REF_HOME}/text/cdn_busmatrix/seq \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/test \
	${UVM_REF_HOME}/lib/smtdv_common/smtdv_common_pkg.sv \
	${UVM_REF_HOME}/dpi/sqlite3/smtdv_sqlite3_pkg.sv \
	${UVM_REF_HOME}/dpi/stl/smtdv_stl_pkg.sv \
	${UVM_REF_HOME}/lib/smtdv_ahb_uvc/sv/ahb_pkg.sv \
	${UVM_REF_HOME}/lib/smtdv_apb_uvc/sv/apb_pkg.sv \
	${UVM_REF_HOME}/test/cdn_busmatrix/sv/cdn_busmatrix_pkg.sv \
	${UVM_REF_HOME}/test/cdn_busmatrix/tb/cdn_busmatrix_tb.sv

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
	+incdir+${UVM_REF_HOME}/lib/smtdv_common \
	+incdir+${UVM_REF_HOME}/dpi/sqlite3 \
	+incdir+${UVM_REF_HOME}/dpi/stl \
	+incdir+${UVM_REF_HOME}/lib/smtdv_ahb_uvc/sv \
	+incdie+${UVM_REF_HOME}/lib/smtdv_ahb_uvc/seq \
	+incdir+${UVM_REF_HOME}/lib/smtdv_apb_uvc/sv \
	+incdir+${UVM_REF_HOME}/lib/smtdv_apb_uvc/seq \
	+incdir+${UVM_REF_HOME}/designs/socv/rtl/rtl_lpw/cdn_busmatrix \
	+incdir+${UVM_REF_HOME}/text/cdn_busmatrix \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/sv \
	+incdir+${UVM_REF_HOME}/text/cdn_busmatrix/seq \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/test \
	-gblso ${UVM_REF_HOME}/dpi/sqlite3/dpi_smtdv_lib.so \
	-gblso ${UVM_REF_HOME}/dpi/stl/dpi_smtdv_stl.so \
	+UVM_TESTNAME=cdn_cpu_s0_2_dma_m0_test \
	+UVM_VERBOSITY=UVM_FULL

clean_mti:
	rm -rf work
	rm -rf *.log
	rm -rf *.db
	rm -rf cov_work
	rm -rf waves.shm

# apb_1w1r_test, apb_rand_test, apb_stl_test
#-linedebug
#-lineuvmdebug
run_ius:
	irun \
	-uvm \
	-64bit \
	-access rwc \
	-status \
	-top top \
	+UVM_TESTNAME=cdn_cpu_s0_2_dma_m0_test \
	+UVM_VERBOSITY=UVM_DEBUG \
	-covoverwrite \
	-coverage b:u \
	+nccoverage+functional \
	+notchkmsg \
	+notimingchecks \
	+no_notifier \
	+define+SVA \
	+incdir+${UVM_REF_HOME}/lib/smtdv_common \
	+incdir+${UVM_REF_HOME}/dpi/sqlite3 \
	+incdir+${UVM_REF_HOME}/dpi/stl \
	+incdir+${UVM_REF_HOME}/lib/smtdv_ahb_uvc/sv \
	+incdir+${UVM_REF_HOME}/lib/smtdv_ahb_uvc/seq \
	+incdir+${UVM_REF_HOME}/lib/smtdv_apb_uvc/sv \
	+incdir+${UVM_REF_HOME}/lib/smtdv_apb_uvc/seq \
	+incdir+${UVM_REF_HOME}/designs/socv/rtl/rtl_lpw/cdn_busmatrix \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/sv \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/seq \
	+incdir+${UVM_REF_HOME}/test/cdn_busmatrix/test \
	${UVM_REF_HOME}/lib/smtdv_common/smtdv_common_pkg.sv \
	${UVM_REF_HOME}/dpi/sqlite3/smtdv_sqlite3_pkg.sv \
	${UVM_REF_HOME}/dpi/stl/smtdv_stl_pkg.sv \
	${UVM_REF_HOME}/lib/smtdv_ahb_uvc/sv/ahb_pkg.sv \
	${UVM_REF_HOME}/lib/smtdv_apb_uvc/sv/apb_pkg.sv \
	${UVM_REF_HOME}/test/cdn_busmatrix/sv/cdn_busmatrix_pkg.sv \
	${UVM_REF_HOME}/test/cdn_busmatrix/tb/cdn_busmatrix_tb.sv \
	-sv_lib ${UVM_REF_HOME}/dpi/sqlite3/dpi_smtdv_lib.so \
	-sv_lib ${UVM_REF_HOME}/dpi/stl/dpi_smtdv_stl.so \
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
