
#!/bin/sh -f
#
# Script for running xbus demo
# 
# =============================================================================

#----------------------------------------------------------------------
# Editable Section
#----------------------------------------------------------------------

uvc_path=`sn_which.sh xbus_simple`
if [ -n "$uvc_path" ]; then
   # uvc is already in path
   echo ""
   echo $uvc_path
else
   # add uvm examples lib to path
   echo "Please add xbus_simple package to the SPECMAN_PATH! (aborting demo)"   
   exit 1
fi


demo_file="test_1.e" 
vlg_hdl_files="$uvc_path/v/tb_xbus.v $uvc_path/v/arbiter_dut.v"
vtop="xbus_evc_demo"

# =============================================================================
# Default args
# =============================================================================
hdl_files="$vlg_hdl_files"
demo_file=`sn_which.sh $uvc_path/examples/$demo_file`

 irun \
    $vlg_hdl_files  \
    $demo_file \
    -timescale 1ns/1ns \
    -nosncomp  \
    -gui


exit
