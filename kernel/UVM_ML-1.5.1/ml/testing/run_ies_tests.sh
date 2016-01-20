#! /bin/bash
#
## 
## -------------------------------------------------------------
##    Copyright 2012 Cadence.
##    All Rights Reserved Worldwide
## 
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
## 
# clean_in_between=""
# to_stop=0
run_64bit=0
run_32bit=0
run_osci=1
run_ncsc=1
tests_to_run=""
# run_specman=0

test_runner_parameters=""

for parameter in $*
do 
    pass_this_on=1
    if [ "$parameter" == "--64bit" ]; then
        run_64bit=1
    elif [ "$parameter" == "--32bit" ]; then
        run_32bit=1
    elif [ "$parameter" == "--no-osci" ]; then
        run_osci=0
        pass_this_on=0
    elif [ "$parameter" == "--no-ncsc" ]; then
        run_ncsc=0
        pass_this_on=0
    fi

    if [ $pass_this_on -eq 1 ]; then
        test_runner_parameters="${test_runner_parameters} ${parameter}"
    fi
done



if [ $run_64bit -eq 0 -a $run_32bit -eq 0 ]; then
    if [ ${UVM_ML_BITS:-32} -eq 32 ]; then
        run_32bit=1
    elif [ ${UVM_ML_BITS:-32} -eq 64 ]; then
        run_64bit=1
    fi
fi

if [ $run_osci -eq 1 -a  "X${OSCI_INSTALL}" == "X" ]; then
    run_osci=0
fi


if [ $run_osci -eq 1 -a "X${OSCI_VERSION}" == "X" ]; then
    export OSCI_VERSION=$(${UVM_ML_HOME}/ml/tools/get_osci_version.sh)
fi

if [ $run_osci -eq 1 -a "X${UVM_ML_COMPILER_VERSION}" == "X" ]; then
    export UVM_ML_COMPILER_VERSION=$(${UVM_ML_HOME}/ml/tools/get_gcc_version.sh ${UVM_ML_CC})
fi

if [ $run_osci -eq 1 -a $run_32bit -eq 1 ]; then
    if [ ! -f ${UVM_ML_HOME}/ml/libs/osci/${OSCI_VERSION}/${UVM_ML_COMPILER_VERSION}/libuvm_sc_fw_osci.so -o ! -f  ${UVM_ML_HOME}/ml/libs/osci/${OSCI_VERSION}/${UVM_ML_COMPILER_VERSION}/libuvm_sc_ml_osci.so ]; then
        run_osci=0
        echo "Unable to find ${UVM_ML_HOME}/ml/libs/osci/${OSCI_VERSION}/${UVM_ML_COMPILER_VERSION}/libuvm_sc_fw_osci.so and/or ${UVM_ML_HOME}/ml/libs/osci/${OSCI_VERSION}/${UVM_ML_COMPILER_VERSION}/libuvm_sc_ml_osci.so"
    fi
fi

if [ $run_osci -eq 1 -a $run_64bit -eq 1 ]; then
    if [ ! -f ${UVM_ML_HOME}/ml/libs/osci/${OSCI_VERSION}/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_sc_fw_osci.so -o ! -f  ${UVM_ML_HOME}/ml/libs/osci/${OSCI_VERSION}/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_sc_ml_osci.so ]; then
        run_osci=0
    fi
fi




if [ $run_osci -eq 1 ]; then
    tests_to_run="$tests_to_run ies_osci_cl ies_osci_proc ies_osci_cl_multistep ies_osci_proc_multistep"
fi

if [ $run_ncsc -eq 1 ]; then
    tests_to_run="$tests_to_run ies_ncsc_cl ies_ncsc_proc ies_ncsc_cl_multistep ies_ncsc_proc_multistep"
fi

if [ "$tests_to_run" == "" ]; then
    tests_to_run="ies"
fi



./test_runner.sh $test_runner_parameters $tests_to_run


