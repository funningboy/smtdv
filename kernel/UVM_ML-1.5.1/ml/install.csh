#!/bin/csh -f
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
################################################
set build_osci = 1
set build_specman = 0
set build_boost = 1
set build_backplane = 1
set build_uvm_sv = 1

# Cadence Incisive only
set build_cdns_backplane_loader=0
set build_tcl_debug = 0
set build_ncsc = 0


set build_target_32 = "debug32"
set build_target_64 = "debug64"
set debug_flags = "-g -O0"

if (! ($?UVM_ML_HOME) ) then
    echo "Environment variable UVM_ML_HOME must be defined"
    exit 1
endif

if (! (-d $UVM_ML_HOME/ml) ) then
    echo "$UVM_ML_HOME/ml must exist"
    exit 1
endif


if (! ($?UVM_ML_ERROR_FLAGS) ) then
    setenv UVM_ML_ERROR_FLAGS "-Wall -Werror -Wno-unused"
endif


set to_clean = 0
set to_build = 1
set build_32bit = 0
set build_64bit = 0


foreach parameter ($*)
    if ( "$parameter" == "--help" || "$parameter" == "-help" || "$parameter" == "-h" ) then
        if ( $?WRAPPER_SPECIFIC_HELP ) then
            echo $0 was invoked that is a wrapper around install.csh
            echo $WRAPPER_SPECIFIC_HELP:q
        endif
        cat <<EOF
Usage of install.csh:
    At a CSH prompt, issue 'source install.csh <parameters>'
    The following parameters are supported:
    --clean: clean the binaries under \$UVM_ML_HOME before building
    --32bit: build 32-bit build
    --64bit: build 64-bit build
    NOTE: If neither --32bit nor --64bit is stated, --32bit is implied. If both --32bit and --64bit are stated, both are built.
    Each flag comes either in positive '--build-' form or in negative '--no-' form. The description below is partial.
    --no-osci: do not build OSCI-adapted UVM-SC framework and ML-OA adapter
    --no-specman: do not build UVM-ML-OA Specman adapter
    --no-build | --env-only : do not perform any actual build, just set the relevant environment variables
    --no-backplane: do not build the UVM-ML-OA backplane libraries
    --no-boost: do not build the UVM-ML-OA-customized BOOST library
    --no-uvm-sv: do not build the UVM-SV adapter for UVM-ML-OA
    --build-cdns-backplane-loader : do not build the backplane loader used only for Incisive
    --build-ncsc: do not build NCSC-adapted UVM-SC framework and ML-OA adapter
    --build-tcl-debug: do not build the TCL debug extension library used only for Incisive
    --no-debug-build : build without debug information (by default, debug information is included for all non-encrypted files
EOF
        exit 0
    else if ( "$parameter" == "--clean" || "$parameter" == "-clean" ) then
        set to_clean = 1
    else if ("$parameter" == "--no-clean" || "$parameter" == "-no-clean" || "$parameter" == "--noclean" || "$parameter" == "-noclean" ) then
        set to_clean = 0
    else if ( "$parameter" == "--32bit" || "$parameter" == "-32bit" ) then
        set build_32bit = 1
    else if ( "$parameter" == "--64bit" || "$parameter" == "-64bit" ) then
        set build_64bit = 1
    else if ( "$parameter" == "--clean" || "$parameter" == "-clean" ) then
        set to_clean = 1
    else if ( "$parameter" == "--no-osci" || "$parameter" == "-no-osci" ) then
        set build_osci = 0
    else if ( "$parameter" == "--no-ncsc" || "$parameter" == "-no-ncsc" ) then
        set build_ncsc = 0
    else if ( "$parameter" == "--no-specman" || "$parameter" == "-no-specman" ) then
        set build_specman = 0
    else if ( "$parameter" == "--build-specman" || "$parameter" == "-build-specman" ) then
        set build_specman = 2
    else if ( "$parameter" == "--build-osci" || "$parameter" == "-build-osci" ) then
        set build_osci = 2
    else if ( "$parameter" == "--build-ncsc" || "$parameter" == "-build-ncsc" ) then
        set build_ncsc = 2
    else if ( "$parameter" == "--no-build" || "$parameter" == "-no-build" || "$parameter" == "--env-only" || "$parameter" == "-env-only" ) then
        set to_build = 0
    else if ( "$parameter" == "--no-backplane"  ) then
        set build_backplane = 0
    else if ( "$parameter" == "--no-boost" ) then
        set build_boost = 0
    else if ( "$parameter" == "--no-uvm-sv" ) then
        set build_uvm_sv = 0
    else if ( "$parameter" == "--no-tcl-debug" || "$parameter" == "-no-tcl-debug" ) then
        set build_tcl_debug = 0
    else if ( "$parameter" == "--build-tcl-debug" || "$parameter" == "-build-tcl-debug" ) then
        set build_tcl_debug = 1
    else if ( "$parameter" == "--build-cdns-backplane-loader" || "$parameter" == "-build-cdns-backplane-loader" ) then
        set build_cdns_backplane_loader = 1
    else if ( "$parameter" == "--no-cdns-backplane-loader" || "$parameter" == "-no-cdns-backplane-loader" ) then
        set build_cdns_backplane_loader = 0
    else if ( "$parameter" == "--debug-build" || "$parameter" == "-debug-build"  ) then
        set debug_flags = "-g -O0"
        set build_target_32 = "debug32"
        set build_target_64 = "debug64"
    else if (  "$parameter" == "--no-debug-build" || "$parameter" == "-no-debug-build" ) then
        set debug_flags = ""
        set build_target_32 = "nodebug32"
        set build_target_64 = "nodebug64"
    else
        echo Unrecognized parameter ${parameter}
        exit 1
    endif
end

#default 32 bit
if ( $build_32bit == 0 && $build_64bit == 0 ) then
    set build_32bit = 1
endif

set a_flag = 0


if ( $build_backplane != 0 || $build_uvm_sv != 0 ) then
    if (! ($?UVM_ML_SVDPI_DIR) ) then
        echo "Please define UVM_ML_SVDPI_DIR to the location of svdpi.h"
        set a_flag = 1
    endif
endif

if (! ($?UVM_ML_CC) ) then
    echo "Please define UVM_ML_CC environment variable to the location of the C++ compiler"
    set a_flag = 1
endif

if (! ($?UVM_ML_LD) ) then
    setenv UVM_ML_LD $UVM_ML_CC
endif

if (! ($?UVM_ML_BITS) ) then
    if ( $build_64bit == 1  ) then
        setenv UVM_ML_BITS 64
    endif
    if ( $build_32bit == 1  ) then
        setenv UVM_ML_BITS 32
    endif
endif


if ( $a_flag == 1 ) then
    exit 1
endif


setenv UVM_ML_COMPILER_VERSION `$UVM_ML_HOME/ml/tools/get_gcc_version.sh $UVM_ML_CC`


echo



if (  $build_ncsc != 0 || $build_specman != 0 ) then
    # Clean any remenants
    setenv IES_VERSION `$UVM_ML_HOME/ml/tools/get_ies_version.sh`
    echo IES VERSION $IES_VERSION
    if ( $build_32bit == 1  ) then
        setenv UVM_ML_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/
    else
        setenv UVM_ML_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/
    endif

    setenv UNILANG_OVERRIDE $UVM_ML_OVERRIDE

endif

##########################################################
#
# Dump the environment variables
#
##########################################################

if ( ! $?UVM_ML_NO_ENV_DUMP ) then

    if ( $build_64bit == 1 ) then
        if( $build_ncsc != 0 || $build_specman != 0 ) then
            if ( ! $?SPECMAN_PATH ) then
                setenv SPECMAN_PATH
            endif
            (setenv UVM_ML_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/; setenv UNILANG_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/; setenv SPECMAN_DLIB ${UVM_ML_HOME}/ml/libs/uvm_e/${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/64bit/libsn_sn_uvm_ml.so; setenv SPECMAN_PATH ${UVM_ML_HOME}/ml/libs/uvm_e/${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/64bit:${UVM_ML_HOME}/ml/primitives:$SPECMAN_PATH; env BITS=64 $UVM_ML_HOME/ml/tools/dump_env_vars.sh)
        else
            (setenv UVM_ML_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/ ; unsetenv UNILANG_OVERRIDE; env BITS=64 $UVM_ML_HOME/ml/tools/dump_env_vars.sh)
        endif
    endif

    if ( $build_32bit == 1 ) then
        if( $build_ncsc != 0 || $build_specman != 0 ) then
            if ( ! $?SPECMAN_PATH ) then
                setenv SPECMAN_PATH
            endif
            ( setenv UVM_ML_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/; setenv UNILANG_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/;setenv SPECMAN_DLIB ${UVM_ML_HOME}/ml/libs/uvm_e/${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/libsn_sn_uvm_ml.so; setenv SPECMAN_PATH ${UVM_ML_HOME}/ml/libs/uvm_e/${IES_VERSION}/${UVM_ML_COMPILER_VERSION}:${UVM_ML_HOME}/ml/primitives:$SPECMAN_PATH; env BITS=32 $UVM_ML_HOME/ml/tools/dump_env_vars.sh )
        else
            (setenv UVM_ML_OVERRIDE $UVM_ML_HOME/ml/libs/backplane/ies_$IES_VERSION/$UVM_ML_COMPILER_VERSION/; unsetenv UNILANG_OVERRIDE; env BITS=32 $UVM_ML_HOME/ml/tools/dump_env_vars.sh )
        endif
    endif

endif

# ENV-ONLY STOPS HERE



if ( $to_build == 0 ) then
    exit 0
endif


if ( $build_ncsc != 0 ) then
    set NCROOT_PATH=`/usr/bin/which ncroot`
    if ( ( ${%NCROOT_PATH} == 0 )) then
        echo "IES was not detected"
        if ( $build_ncsc == 2 ) then
            exit 1
        else
            echo "NCSC-related parts will not be built"
            set build_ncsc = 0
        endif
    endif
endif


if ( $build_specman != 0 ) then
    set SN_ROOT_PATH=`/usr/bin/which sn_root`
    if ( ( ${%SN_ROOT_PATH} == 0 )) then
        echo "Specman was not detected"
        if ( $build_specman == 2 ) then
            exit 1
        else
            echo "Specman-related parts will not be built"
            set build_specman = 0
        endif
    endif
endif

set osci_env_not_set_flag = 0

if ( $build_osci != 0 &&  ! ($?OSCI_INSTALL) ) then
    echo "Environment variable OSCI_INSTALL was not found."
    set osci_env_not_set_flag = 1
endif

if ($build_osci != 0 && ! ($?OSCI_SRC) ) then
    echo "Environment variable OSCI_SRC was not found"
    set osci_env_not_set_flag = 1
endif



if ( $osci_env_not_set_flag == 1 ) then
    if ( $build_osci != 0 ) then
        echo "OSCI-related parts will not be built."
        set build_osci = 0
    else
        exit 1
    endif
else
    if ( $build_osci != 0 ) then
        if ( ! $?OSCI_VERSION ) then
            # Forcefully Set OSCI_VERSION here
            setenv OSCI_VERSION `$UVM_ML_HOME/ml/tools/get_osci_version.sh`
            if ( "x$OSCI_VERSION" == "x" ) then
                echo "Failed to detect OSCI_VERSION"
                exit 1
            endif
        endif
    endif
endif

# Not needed for OSCI 2.3, hence here

if ($build_osci != 0 ) then
    if ( "$OSCI_VERSION" == "2.2" && ! ($?TLM2_INSTALL) ) then
        echo "Environment variable TLM2_INSTALL was not found"
        echo "OSCI-related parts will not be built."
        set build_osci = 0
    endif
endif


if ($build_osci == 2 ) then
    set build_osci = 1
endif

if ( $build_ncsc == 2 ) then
    set build_ncsc = 1
endif


if ( $build_specman != 0 ) then
    set specman_exec =  `sn_root -dir`/specman
    set sn_check_version = `nm $specman_exec | grep sn_unilang_adapter`
    if ( "$sn_check_version" == "" ) then
	echo "This version of UVM-ML Open Architecture requires a newer version of Incisive/Specman: supported versions are IES13.20 and up.";
	if ($build_specman == 2) then
	    echo "Exiting ...";
	    exit 1;
	else
	    echo "Specman/e UVM-ML adapter will not be built. If you want to build without Specman/e you can execute 'source install.csh -no-specman'.";
	    set build_specman = 0;
        endif
    endif
endif

if ( $build_specman == 2 ) then
    set build_specman = 1
endif



##################################################################


if ( $build_boost == 1 ) then



    pushd $UVM_ML_HOME/ml/frameworks/uvm/sc/packages/boost/libs/regex/build

    if ( $to_clean == 1 ) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the BOOST REGEX library libuvmscboost_regex.so in 64 bit"
        if ( ! { make LIB_DIR=$UVM_ML_HOME/ml/libs/boost/${UVM_ML_COMPILER_VERSION}/64bit OBJEXT=${UVM_ML_COMPILER_VERSION}.64.o LIB_NAME=libboost_regex-gcc-1_47.${UVM_ML_COMPILER_VERSION}.64.a CXXFLAGS="${debug_flags}" BIT_CXXFLAGS="-fPIC" CXX="${UVM_ML_CC}" LINKER="${UVM_ML_LD} -shared" LDFLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/boost/${UVM_ML_COMPILER_VERSION}/64bit/libuvmscboost_regex.so"
            popd
            exit 1
        endif
    endif

    if (( $build_32bit == 1 )) then
        echo "Compiling the BOOST REGEX library libuvmscboost_regex.so in 32 bit"
        if (! { make LIB_DIR=$UVM_ML_HOME/ml/libs/boost/${UVM_ML_COMPILER_VERSION} CXXFLAGS="-m32 ${debug_flags}" LDFLAGS="-m32" BIT_CXXFLAGS="" CXX="${UVM_ML_CC}" LINKER="${UVM_ML_LD} -shared" OBJEXT=${UVM_ML_COMPILER_VERSION}.o } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/boost/${UVM_ML_COMPILER_VERSION}/libuvmscboost_regex.so"
            popd
            exit 1
        endif
    endif

    popd


endif
########################################################################

if ( $build_backplane == 1 ) then

    pushd $UVM_ML_HOME/ml/backplane
    if ( $to_clean == 1 ) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the backplane library $UVM_ML_HOME/ml/libs/backplane/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_ml_bp.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create the backplane library $UVM_ML_HOME/ml/libs/backplane/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_ml_bp.so"
            popd
            exit 1
        endif
    endif

    if (( $build_32bit == 1 ) ) then
        echo "Compiling the backplane library $UVM_ML_HOME/ml/libs/backplane/${UVM_ML_COMPILER_VERSION}/libuvm_ml_bp.so"
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create the backplane library $UVM_ML_HOME/ml/libs/backplane/${UVM_ML_COMPILER_VERSION}/libuvm_ml_bp.so"
            popd
            exit 1
        endif
    endif


    popd


endif



#########################################################################


#debug facility

if ( $build_tcl_debug == 1 ) then

    pushd $UVM_ML_HOME/ml/facilities/debug
    if ( $to_clean == 1 ) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the debug library $UVM_ML_HOME/ml/libs/debug/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_ml_debug.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create the debug library $UVM_ML_HOME/ml/libs/debug/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_ml_debug.so"
            popd
            exit 1
        endif
    endif

    if (( $build_32bit == 1 ) ) then
        echo "Compiling the debug library $UVM_ML_HOME/ml/libs/debug/${UVM_ML_COMPILER_VERSION}/libuvm_ml_debug.so"
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create the debug library $UVM_ML_HOME/ml/libs/debug/${UVM_ML_COMPILER_VERSION}/libuvm_ml_debug.so"
            popd
            exit 1
        endif
    endif

    popd


endif

#######################################################################

if ( $build_uvm_sv == 1 ) then

    pushd $UVM_ML_HOME/ml/adapters/uvm_sv

    if ( $to_clean == 1 ) then
        make clean
    endif

    if (( $build_64bit == 1 )) then
        echo "Compiling the UVM-ML SV adapter library $UVM_ML_HOME/ml/libs/uvm_sv/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_sv_ml.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/uvm_sv/${UVM_ML_COMPILER_VERSION}/64bit/libuvm_sv_ml.so"
            popd
            exit 1
        endif
    endif

    if (( $build_32bit == 1 )) then
        echo "Compiling the UVM-ML SV adapter library $UVM_ML_HOME/ml/libs/uvm_sv/${UVM_ML_COMPILER_VERSION}/libuvm_sv_ml.so"
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/uvm_sv/${UVM_ML_COMPILER_VERSION}/libuvm_sv_ml.so"
            popd
            exit 1
        endif
    endif

    popd


endif
#######################################################################

if ( $build_specman == 1 ) then
    pushd $UVM_ML_HOME/ml/adapters/uvm_e
    echo "Compiling the UVM-ML e adapter library libsn_sn_uvm_ml.so"

    if ( $to_clean == 1 ) then
        make clean
    endif

    if (( $build_64bit == 1 )) then
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/uvm_e/$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libsn_sn_uvm_ml.so"
            popd
            exit 1
        endif
    endif

    if (( $build_32bit == 1 )) then
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/uvm_e/$IES_VERSION/$UVM_ML_COMPILER_VERSION/libsn_sn_uvm_ml.so"
            popd
            exit 1
        endif
    endif

    popd
endif

######################################################################
# Backplane loader

if (  $build_cdns_backplane_loader == 1 ) then
    pushd $UVM_ML_HOME/ml/libs/backplane/
    if ( $to_clean == 1 ) then
        make clean
    endif

    if ( $build_64bit == 1 ) then
        echo "Compiling the NCSIM backplane loader library $UVM_ML_HOME/ml/libs/backplane/ies_${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/64bit/libml_uvm.so"
        if ( ! { make loader64 } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/backplane/ies_${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/64bit/libml_uvm.so"
            popd
            exit 1
        endif
    endif

    if ( $build_32bit == 1 ) then
        echo "Compiling the NCSIM backplane loader library $UVM_ML_HOME/ml/libs/backplane/ies_${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/libml_uvm.so"
        if ( ! { make loader32 } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/backplane/ies_${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/libml_uvm.so"
            popd
            exit 1
        endif
    endif

    popd

endif

#######################################################################

if ( $build_ncsc == 1 ) then
    pushd $UVM_ML_HOME/ml/frameworks/uvm/sc/ncsc/
    if ($to_clean == 1) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the UVM SC NCSC library $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_fw.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_fw.so"
            popd
            exit 1
        endif
    endif
    if ( ( $build_32bit == 1 ) ) then
        echo "Compiling the UVM SC NCSC library $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_fw.so"
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_fw.so"
            popd
            exit 1
        endif
    endif

    popd
endif


###########################################################################
if ($build_osci == 1 ) then
    if ( ! $?UVM_ML_NO_ENV_DUMP ) then
        # Dump the OSCI-related information
        \rm -f $UVM_ML_HOME/ml/example_utils/osci_version.mk # The file may have been created
        #read-only, so recreate it instead of failing during an attempt to overwrite it.
        echo "OSCI_VERSION:=$OSCI_VERSION" > $UVM_ML_HOME/ml/example_utils/osci_version.mk
        echo "OSCI_INSTALL:=$OSCI_INSTALL" >> $UVM_ML_HOME/ml/example_utils/osci_version.mk
        if ( $?TLM2_INSTALL ) then
            echo "TLM2_INSTALL:=$TLM2_INSTALL" >> $UVM_ML_HOME/ml/example_utils/osci_version.mk
        endif
    endif
    pushd $UVM_ML_HOME/ml/frameworks/uvm/sc/osci/
    if ($to_clean == 1) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the UVM SC OSCI library $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_fw_osci.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_fw_osci.so"
            popd
            exit 1
        endif
    endif
    if ( ( $build_32bit == 1 ) ) then
        echo "Compiling the UVM SC OSCI library $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_fw_osci.so"
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_fw_osci.so"
            popd
            exit 1
        endif
    endif
    popd
endif


##############################################################################


if ( $build_ncsc == 1 ) then
    pushd $UVM_ML_HOME/ml/adapters/uvm_sc/ncsc

    if ( $to_clean == 1) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the UVM SC NCSC adapter library $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_ml.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_ml.so"
            popd
            exit 1
        endif
    endif
    if ( ( $build_32bit == 1 ) ) then
        echo "Compiling the UVM SC NCSC adapter library $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_ml.so"
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_ml.so"
            popd
            exit 1
        endif
    endif

    popd

endif


##########################################################################

if ( $build_osci == 1 ) then

    pushd $UVM_ML_HOME/ml/adapters/uvm_sc/osci
    if ( $to_clean == 1) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        echo "Compiling the UVM SC OSCI adapter library $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_ml_osci.so"
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_sc_ml_osci.so"
            popd
            exit 1
        endif
    endif
    if ( ( $build_32bit == 1 ) ) then
        echo "Compiling the UVM SC OSCI adapter library $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_ml_osci.so"
        if ( ! { make ${build_target_32}  UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_sc_ml_osci.so"
            popd
            exit 1
        endif
    endif

    popd

endif

#######################################################################

if ( $build_osci == 1 ) then

    pushd $UVM_ML_HOME/ml/libs/osci
    if ($to_clean == 1) then
        make clean
    endif


    if ( ( $build_64bit == 1 ) ) then
        if ( ! { make bundle64  UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm_osci.so"
            popd
            exit 1
        endif
    endif
    if ( ( $build_32bit == 1 ) ) then
        if ( ! { make bundle32 UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/osci/$OSCI_VERSION/$UVM_ML_COMPILER_VERSION/libuvm_osci.so"
            popd
            exit 1
        endif
    endif

    popd

endif


#####################################################################







if ( $build_ncsc == 1 ) then
    pushd $UVM_ML_HOME/ml/libs/ncsc/
    if ($to_clean == 1) then
        make clean
    endif

    if ( ( $build_64bit == 1 ) ) then
        if ( ! { make ${build_target_64} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/64bit/libuvm.so"
            popd
            exit 1
        endif
    endif
    if ( ( $build_32bit == 1 ) ) then
        if ( ! { make ${build_target_32} UVM_ML_DEBUG_FLAGS="${debug_flags}" } ) then
            echo "Failed to create $UVM_ML_HOME/ml/libs/ncsc/$IES_VERSION/$UVM_ML_COMPILER_VERSION/libuvm.so"
            popd
            exit 1
        endif
    endif

    popd
endif

############################################################
#
# Print the summary information
#
############################################################
if ( $to_clean == 1 ) then
    set clean_note = "with cleaning"
else
    set clean_note = "without cleaning"
endif

if ( $build_64bit == 1 ) then
    set build_64bit_note = "for 64 bit"
else
    set build_64bit_note = ""
endif
if ( $build_32bit == 1 ) then
    set build_32bit_note = "for 32 bit"
else
    set build_32bit_note = ""
endif

if ($build_64bit == 1 && $build_32bit == 1) then
    set build_note_delimiter = " and "
else
    set build_note_delimiter = ""
endif
if ( $build_osci == 1 ) then
    set osci_note = "with OSCI UVM-SC framework and adapter for OSCI ${OSCI_VERSION}"
else
    set osci_note = "without OSCI UVM-SC framework and adapter"
endif

if ( $build_ncsc == 1 ) then
    set ncsc_note = "with IES NCSC UVM-SC framework and adapter for NCSC ${IES_VERSION} "
else
    set ncsc_note = "without IES NCSC UVM-SC framework and adapter"
endif

if ( $build_specman == 1 ) then
    set specman_note = "with Specman UVM-E adapter for Specman ${IES_VERSION}"
else
    set specman_note = "without Specman UVM-E adapter"
endif


if ( $build_32bit == 1 ) then
    set csh_32bit_capture = "$UVM_ML_HOME/ml/setup_32.csh"
    set sh_32bit_capture = "$UVM_ML_HOME/ml/setup_32.sh"
    set make_32bit_capture = "$UVM_ML_HOME/ml/setup_32.mk"
else
    set csh_32bit_capture = ""
    set sh_32bit_capture = ""
    set make_32bit_capture = ""
endif

if ( $build_64bit == 1 ) then
    set csh_64bit_capture = "$UVM_ML_HOME/ml/setup_64.csh"
    set sh_64bit_capture = "$UVM_ML_HOME/ml/setup_64.sh"
    set make_64bit_capture = "$UVM_ML_HOME/ml/setup_64.mk"
else
    set csh_64bit_capture = ""
    set sh_64bit_capture = ""
    set make_64bit_capture = ""
endif

if ( $build_target_32 == "nodebug32" || $build_target_64 == "nodebug64" ) then
    set debug_note = "without debug information"
else
    set debug_note = "with debug information"
endif

echo
echo
echo "***********************************"
echo "*"
echo "* Setup "
echo "* using compiler version $UVM_ML_COMPILER_VERSION"
echo "* - ${build_64bit_note}${build_note_delimiter}${build_32bit_note}"
echo "* - $debug_note"
echo "* - $clean_note"
echo "* - $osci_note"
echo "* - $ncsc_note"
echo "* - $specman_note"
echo "* completed successfully"

if ( ! $?UVM_ML_NO_ENV_DUMP ) then
    echo "*"
    echo "* The information about the environment variables "
    echo "* vital for running UVM-ML "
    echo "* may be found in ${csh_32bit_capture}${build_note_delimiter}${csh_64bit_capture} (CSH format),"
    echo "* in  ${sh_32bit_capture}${build_note_delimiter}${sh_64bit_capture} (Bourne shell format)"
    echo "* and in ${make_32bit_capture}${build_note_delimiter}${make_64bit_capture} (Makefile format)"
    echo "***********************************"
endif

