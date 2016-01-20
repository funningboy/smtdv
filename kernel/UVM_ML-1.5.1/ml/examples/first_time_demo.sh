#! /bin/tcsh -f 

if ( ! ($?UVM_ML_HOME) ) then
   echo "Please set environment variable UVM_ML_HOME to the parent directory of ml";
   exit 1
endif

exec $UVM_ML_HOME/ml/examples/use_cases/side_by_side/sc_sv_e/demo.sh $argv
