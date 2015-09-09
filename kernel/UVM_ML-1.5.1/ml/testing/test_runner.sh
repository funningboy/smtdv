#! /bin/bash
#
## 
## -------------------------------------------------------------
##    Copyright 2013 Cadence.
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

unset UNILANG_OVERRIDE
unset UVM_ML_OVERRIDE


clean_in_between=""
to_stop=0
run_64bit=0
run_32bit=0
run_specman=0
only_specman=0
stub_out=""
log_base="irun"
tests_to_run=""
running_counter=0
passing_counter=0
skipped_counter=0
failing_counter=0
first_failure_in_a_group=0
group_title=""
run_dir=""



declare -a failing_tests=()
declare -a bit_flags=()

##########################################################################################
# Run the test, check its results and add group title and test characteristics to the list of failures


function run_and_check {
    local local_run_dir=${run_dir:-${test_dir}}
    running_counter=`expr ${running_counter} + 1`
    echo "********************************************************"
    echo "*                                                      *"
    echo "* Running ${target} with ${bit_flag} in ${test_dir}         *"
    
    if [ ${to_stop} -eq 0 ]; then
        echo "* $failing_counter failed test(s) up to now *" 
    fi

    echo "* $running_counter out of $overall_number_of_runs *"
    echo "*                                                      *"
    echo "********************************************************"


     test_string="make -C ${local_run_dir} -f ${test_dir}/Makefile ${clean_in_between} ${target} ${bit_flag}"
     $stub_out make -C ${local_run_dir:-${test_dir}} -f ${test_dir}/Makefile $clean_in_between ${target} ${bit_flag}
    # Check the status here
    if [ $? -gt 0 ]; then 
        failing_counter=`expr ${failing_counter} + 1`
        if [ $first_failure_in_a_group -eq 1 ]; then
            first_failure_in_a_group=0
            failing_tests=("${failing_tests[@]}" "" "${group_title}" "")
        fi
        failing_tests=("${failing_tests[@]}" "${test_string}")
        if [ $to_stop -eq 1 ]; then
            exit 1 
        fi
    else
        passing_counter=`expr ${passing_counter} + 1`
    fi
}

##########################################################################################

function help {
cat <<EOF
Usage:
 test_runner.sh <switches> <make targets>
 The following switches are supported: 
 --clean        - clean before running. Do it e.g. if you run 32-bit and 64-bit tests in the same directory
 --stop         - stop after first failure and remain in the failure directory. 
 --with-specman - run also tests/examples that involve Specman. 
 --only-specman - run ONLY tests/examples that involve Specman. 
 --dry-run      - only print the relevant commands out but not execute them 
 --help, -h     - print short help and exit
 --run-in-pwd, -pwd -   run all the tests in the current directory (by default, each test is run in its respective source directory). This implies --clean.
 
EOF
}

##########################################################################################
# By default, Specman runs are not performed
# unless --with-specman or --only-specman are passed to the script 

function no_need_to_skip {
    number_of_e_files=$(find $1 -iname '*.e' 2>/dev/null | wc -l)
    if [ \( ! -e $1/skip_test \)  -a \( \( $number_of_e_files -ge 1 \) -a \( \( $run_specman -eq 1 \) -o \( $only_specman -eq 1 \) \) -o \( \( $number_of_e_files -eq 0 \) \)  -a \( $only_specman -eq 0 \) \) ]; then
        return 0
    else
        return 1
    fi
}


##########################################################################################
# Parsing the parameters

while [ $# -gt 0 ]
do 
    if [ "$1" == "--clean" ]; then
        clean_in_between="clean"
    elif [ "$1" == "--stop" ]; then
        to_stop=1
    elif [ "$1" == "--64bit" ]; then
        run_64bit=1
    elif [ "$1" == "--32bit" ]; then
        run_32bit=1
    elif [ "$1" == "--with-specman" ]; then
        run_specman=1
    elif [ "$1" == "--only-specman" ]; then
        run_specman=1;
        only_specman=1;
    elif [ "$1" == "--dry-run" ]; then
        stub_out="echo"
    elif [ "$1" == "--help" -o "$1" == "-h" ]; then
        help
        exit 0
    elif [ "$1" == "--run-in-pwd" -o "$1" == "-pwd" ]; then
        run_dir=${PWD};
        clean_in_between="clean";
    elif [[ "$1" == \-* ]]; then
        echo "Invalid switch: $1"
        help
        exit 1
    else 
        targets_to_run="$targets_to_run $1"
    fi
    shift
done

##########################################################################################
# If not targets were passed, go ahead with 'ies vcs questa'.


if [ "$targets_to_run" == "" ]; then
    targets_to_run="ies vcs questa" 
fi
number_of_targets=`echo $targets_to_run | wc -w`

##########################################################################################
# By default, only 32 bit tests are run
# If UVM_ML_BITS is set in advance, it is considered
# Passing --32bit or --64bit overrides UVM_ML_BITS


number_of_runs_per_target=0

if [ $run_64bit -eq 0 -a $run_32bit -eq 0 ]; then
    if [ "${UVM_ML_BITS:-32}" == "64" ]; then 
        run_64bit=1
    else
        run_32bit=1
    fi
fi


if [ $run_64bit -eq 1 ]; then
    number_of_runs_per_target=`expr $number_of_runs_per_target + 1`
    bit_flags=("${bit_flags[@]}" "UVM_ML_BITS=64")
fi

if [ $run_32bit -eq 1 ]; then
    number_of_runs_per_target=`expr $number_of_runs_per_target + 1`
    bit_flags=("${bit_flags[@]}" "UVM_ML_BITS=32")
fi

##########################################################################################
# Finding the directories to run in
# UVM_ML_TESTS_RUN variable may contain the explicit list of directories to run the targets in
# Alternatively, UVM_ML_TEST_HOME may contain the root directory to look for tests under
# By default, every directory under ${UVM_ML_HOME}/ml/examples (but for simulator internal csrc / INCA_libs ),
# containing a Makefile, is considered. Some directories are skipped, depending on the Specman-related flags. 


test_dirs=${UVM_ML_TESTS_TO_RUN:-`find ${UVM_ML_TEST_HOME:-${UVM_ML_HOME}/ml/examples} -follow -iname Makefile | xargs --no-run-if-empty -I'{}' dirname '{}' | grep -v -E 'csrc|INCA_libs'`}

for test_dir in $test_dirs 
do
    if [ -d $test_dir ]; then
        if no_need_to_skip $test_dir; then
            final_test_dirs="${final_test_dirs} ${test_dir}"
        else
            skipped_counter=`expr ${skipped_counter} \+ ${number_of_targets} \* ${number_of_runs_per_target} `
        fi
    fi
done

number_of_dirs=`echo $final_test_dirs | wc -w`


##########################################################################################
# Fail if there are no tests to run

overall_number_of_runs=`expr $number_of_dirs \* $number_of_targets \* $number_of_runs_per_target`


if [ ${overall_number_of_runs} -eq 0 ]; then
    echo "**** NO TESTS TO RUN ****"
    exit 1
fi


###########################################################################################
# Print a short intro


echo "**** The requested run characteristics: ****"
echo "**** Running ${number_of_targets} target(s)  : ${targets_to_run} ****" 
echo "**** In ${number_of_dirs} directories ****" 

if [ ${run_32bit} -eq 1 ]; then
    echo "**** Running for the 32-bit platform ****"
fi

if [ ${run_64bit} -eq 1 ]; then
    echo "**** Running for the 64-bit platform ****"
fi

if [ ${only_specman} -eq 1  ]; then
    echo "**** Running only tests involving Specman ****" 
elif [ ${run_specman} -eq 1 ]; then
    echo "**** Running tests involving Specman ****"
else
    echo "**** Skipping tests involving Specman ****"
fi

echo "**** Total of ${overall_number_of_runs} runs ****"



##########################################################################################
# Run the tests grouped by target + bitness

for target in $targets_to_run
do
    for bit_flag in "${bit_flags[@]}"
    do
        group_title="======= ${target} tests with ${bit_flag} ======"
        first_failure_in_a_group=1
        for test_dir in $final_test_dirs
        do
            run_and_check
        done
    done
done


##########################################################################################
# Print out list of failures (if any) and summary

if [ $failing_counter -gt 0 ]; then
    echo;echo;echo "**** LIST OF FAILURES ****";echo
    for failing_test in "${failing_tests[@]}"; do
        echo $failing_test
    done
    echo;echo;echo "**** END OF LIST OF FAILURES  ****";echo
fi
    
echo "**** SUMMARY ****"
echo "**** ${passing_counter} tests passed  ****"


if [ ${run_specman} -eq 0  -a ${run_specman} -eq 0 ]; then 
    skipping_criteria="involving Specman "
elif [ ${only_specman} -eq 1 ]; then
    skipping_criteria="not involving Specman "
else 
    skipping_criteria=""
fi

echo "**** ${skipped_counter} tests ${skipping_criteria}skipped ****"
echo "**** ${failing_counter} tests failed  ****"
echo

##########################################################################################
# Fail if there were any failures

if [ $failing_counter -gt 0 ]; then
    exit 1
fi
