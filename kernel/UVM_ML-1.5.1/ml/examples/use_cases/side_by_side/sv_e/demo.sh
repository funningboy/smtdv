#! /bin/tcsh -f
#
# demo.sh - demonstrating a run of the given example
# 
# Usage Explanation:
#
#   - All example can be run with several simulators, and there are several run options.
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

set dir = `dirname $0`
setenv UVM_ML_TEST_SRC_DIR ${dir}

# ----------- provide special multi-step options, just for this example -----------------------------------------------
set steps="" target="" handled="" dry="" help="";
set message = 'Special Multi-Step Options:\n\
For this example-directory only, there are two special IES multi-step targets you can use, both invoke IES in \n\
multi-step compilation mode, using the basic ncvlog, ncelab, ncsim commands (rather than using irun), \n\
one with e loaded (interpreted), the other with e compiled.\n\
These two targets are:\n\
\t ies_multistep_non_irun_e_load \t ies_multistep_non_irun_e_comp\n\
You can use them with or without the -dry option. All other demo.sh options are ignored when these two are used.\n\
(two bash scripts in this directory, with similar name (and .sh extension), implement these two compile flows)\n'

foreach parameter ($*)
  if ( $steps != "" && $handled == "") then     # if the previous parameter was -steps, then now is the target
    set target="$parameter" handled="yes"
  endif

  if ( "$parameter" == "-steps") then           # parse the relevant parameters (without modifying the argv)
    set steps = "yes"
  else if ( "$parameter" == "-dry" || "$parameter" == "--dry-run" ) then
    set dry = "yes"
  else if ( "$parameter" == "-help" || "$parameter" == "-h" || "$parameter" == "--help" ) then
    set help = "yes"
  endif
end

# special handling only if a "multistep_non_irun" target was requested. Otherwise pass all work to the central demo.sh
if ("$target" == "ies_multistep_non_irun_e_load" || "$target" == "ies_multistep_non_irun_e_comp") then
  set file = "$target.sh"
  if ("$dry" == "yes") then
    cat $dir/$file
  else
    $dir/$file
  endif
  exit $status
endif

# ------------------------ end of special options for this example only -----------------------------------------------


# If there was no "special IES multi-step target" request - then do the usual:

${UVM_ML_HOME}/ml/example_utils/demo.sh $argv   # pass arguments to the central demo.sh file
if ("$help" == "yes" ) then 
    echo $message
endif
exit $status                            # and return the status returned by it... 
