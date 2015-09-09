#! /bin/tcsh -f 
#
# demo.sh - demonstrating a run of the given example
# 
# Usage Explanation:
#   - The example can be run with several simulators 
#   - A dry-run option can print out the prepare, compile and run command(s) without executing them
#   - See the the "Usage" invocation options below: 

set script = `basename $0`
set usage = "Usage: $script <IES | VCS | QUESTA> [-h|-help] [-debug] [-dry|--dry-run] [-gui] [-steps [ies-multi-step-target]][--uvm-version <UVM-SV version>]"
set explanation = '\n\
The first argument selects the simulator and is mandatory.\n\
The --uvm-version <version> option selects the desirable UVM-SV version to work against. Currently, 1.1 and 1.2 are supported. \n\
The -h or -help options will print this help text (when present, other options are ignored)\n\
The -dry options will print the invocation commands without executing them (optional)\n\
The -gui option invokes IES in GUI mode (optional, available currently only for IES)\n\
The -debug option switches on the debugging options of the appropriate simulator \n\
and also compiles the C/C++ code in debugging mode whenever appropriate\n\
The -steps option invokes IES in multi-step mode (optional, in place of a single irun command doing all steps)\n\
\tThe optional "target" argument can accept one of 4 Makefile targets (if not stated, the first is chosen):\n\
\t\ties_ncsc_cl_multistep\t ies_ncsc_proc_multistep\n\
\t\ties_osci_cl_multistep\t ies_osci_proc_multistep\n\
\n\
Note: you can run the commands resulting from --dry-run "as is" in Bourne-Shell.\n\
An easy way is to dump the result of the dry run into a do.sh file and then run it, using:\n\
\t% ./demo.sh IES --dry-run > do.sh \n\
\t% chmod +x do.sh \n\
\t% ./do.sh \n\
If such a run fails - run ${UVM_ML_HOME}/ml/test_env.csh to see if any settings are missing.\n\
Missing environment variables may be set by sourcing one of the ${UVM_ML_HOME}/ml/setup_* files.\n\
To run the same commands in other shells, some modifications may be needed, such as:\n\
\t- in the "set_variables" section, replace "<var>=<value>; export <var>"  with   "setenv <var> <value>"\n\
\t- you may need to remove some output redirections such as "2>&1 | tee <log_file>.log"\n\
\n\
Note: For the IES simulator, info on the "irun invocation options" used for ML can be found in the UVM-ML docs\n\
(see the Integrator User Guide, in ${UVM_ML_HOME}/ml/docs/basic_docs/IntegratorUserGuide.pdf)\n'


if ( ! ($?UVM_ML_HOME) ) then
   echo "Please set environment variable UVM_ML_HOME to the parent directory of ml";
   exit 1
endif

if ($#argv == 0) then
   set noglob
   echo $usage 
   unset noglob
   exit 1
endif

# Initialize some variables
set make_opt="" gui_opt="" sim_opt="" target="" error_msg=""; @ cnt = 0;  
set test_and_tops_msg = "# Note: uvm tops & test are defined procedurally in code"  
set targets = (ies_ncsc_cl_multistep ies_ncsc_proc_multistep ies_osci_cl_multistep ies_osci_proc_multistep) # legal multi-step targets
set debug_opt=""

while ($#argv > 0)
    switch ($1)
      case IES:
        set sim_opt = ies
	set target = ies_ncsc_cl #  use command line (cl) mode for ies (make target 'ies' uses procedural to set top/test)
	@ cnt++
	set test_and_tops_msg = "# Note: uvm tops & test are set by irun command line options -uvmtops & -uvmtest"
        breaksw
      case VCS:
        set sim_opt = vcs
	@ cnt++
        breaksw
      case QUESTA:
        set sim_opt = questa
	@ cnt++
        breaksw
      case -dry:
      case --dry-run:
	set make_opt = "--dry-run --always-make"
	breaksw
      case -gui:
	if ( "$sim_opt" == "ies" ) then
	    set gui_opt = 'GUI_OPT=-gui' 
	else
	    set error_msg = "The -gui option is currently available only for IES"
	endif
	breaksw
      case -steps:
	if ( "$sim_opt" == "ies" ) then
	    set target = ""
	    if ( "$2" == "" ) then          # the default multi-step target is the first one
		set target = $targets[1]
	    else                          # otherwise - check if a legal target was specified
		foreach value ($targets)
		    if ( "$2" == "$value" ) then
			set target = $value
			shift
			break
		    endif
		end
	    endif
	    if ( "$target" == "" ) then
		set error_msg = "Wrong usage of the -steps option.\n\tThe target supplied ($2) is not one of the legal multi-step targets.\n\t(Legal targets are: $targets)\n\tIt is best to put the -steps option last on the command line.\n"
		shift
	    endif
	else
	    set error_msg = "The -steps option is available only for IES"
	endif
	breaksw
      case -uvm_version:
      case -uvm-version:
      case --uvm-version:
        shift
        setenv UVM_SV_VERSION $1
        if ( "$UVM_SV_VERSION" == "" ) then
            echo "Wrong usage of the -uvm_version option. Please specify either of the supported UVM-SV versions (1.1 or 1.2)"
            exit 1
        endif
        if ( "$UVM_SV_VERSION" != "1.1" && "$UVM_SV_VERSION" != "1.2") then
            echo "Uknown UVM-SV version. Please specify either of the supported UVM-SV versions (1.1 or 1.2)"
            exit 1
        endif
        breaksw
      case -debug:
      case --debug:
            set debug_opt = "DEBUG=yes"
        breaksw
      case -h:
      case -help:
	 set noglob
 	 echo $usage $explanation
	 unset noglob
         exit 0
      default:
	 set noglob
	 echo $usage 
	 unset noglob
	 exit 1
    endsw
    shift
end


# error checking (illegal option combinations)
if ( $cnt != 1 ) then
    set error_msg = "One simulator should be selected (not $cnt as in this invocation). "
endif
if ( "$make_opt" == "--dry-run --always-make" && "$sim_opt" == "" ) then
    set error_msg = "The --dry-run option must come with a simulator choice"
endif
if ( "$error_msg" != "" ) then 
    set noglob
    echo "Usage error (demo.sh):" $error_msg
    unset noglob
    exit 1
endif


# Invoke the test according to the selected options
if ( "$target" == "" ) then
    set target = $sim_opt
endif
if ("$make_opt" == "") then
    # run the test (using make)
    make -f ${UVM_ML_TEST_SRC_DIR}/Makefile $target $gui_opt $debug_opt
else
    # do a dry-run (only printing the run-command resulting from Make)
    echo "#\!/bin/sh\n# Dry-run output: the command(s) used to run this test are echoed below:"
    echo "# (Note: you can run these commands 'as is' in Bourne-Shell; for more information, run 'demo.sh -help')"
    make -f ${UVM_ML_TEST_SRC_DIR}/Makefile $make_opt $target $gui_opt $debug_opt | \
	awk '/_command - start:/ {flag=1;sub(/"/,"",$2);print "\n#",$2,":";next} /_command - end:/{flag=0} flag {print}'
    set file_name = `grep -l -r 'string[[:space:]]*tops' *`
    echo "\n# tops_and_test_commands :"
    echo $test_and_tops_msg "\n# see 'uvm_ml_run_test' in docs & in file $file_name for various ways to set them"
endif

exit 0
