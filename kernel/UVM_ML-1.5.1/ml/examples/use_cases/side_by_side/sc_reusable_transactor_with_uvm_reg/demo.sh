#! /bin/tcsh -f
#
# demo.sh - demonstrating a run of the given example
# 
# Usage Explanation:
#
#   - This example can be used currently only with IES because it uses an IES-specific instantiation of a
#     Verilog module in a SystemC module. It is not possible with ASI SystemC.
#   - To see all invocation options, use     % demo.sh -help
#
#   - NOTE: To learn how to run UVM-ML (e.g. in order to write your own run scripts), 
#           use the --dry-run option, which is described in detail by    % demo.sh -help
#           This will print the sequence of commands to run this demo in your preferred setting
#           (the --dry-run option extracts from Make-files the commands needed for a specific run)

if ( ! ($?UVM_ML_HOME) ) then
   echo "To run this script, you need to have the environment variable UVM_ML_HOME set."
   echo "Please set UVM_ML_HOME to the parent directory of the /ml directory"
   echo "(should be a few levels above pwd = `pwd`)."
   exit 1
endif

setenv UVM_ML_TEST_SRC_DIR `pwd`/scsv
echo $UVM_ML_TEST_SRC_DIR
setenv UVM_ML_TEST_RUN_DIR `pwd`/run_scsv

${UVM_ML_HOME}/ml/example_utils/demo.sh $argv   # pass arguments to the central demo.sh file
exit $status                            # and return the status returned by it... 
