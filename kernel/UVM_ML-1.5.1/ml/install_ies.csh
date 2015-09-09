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
if (! $?UVM_ML_HOME) then
    set sourced=($_)

    if ( "$sourced" != "" ) then
        set full_name=$sourced[2]
    else
        set full_name=$0
    endif


    set a_dir=`dirname $full_name`

    setenv UVM_ML_HOME `cd $a_dir/..; pwd`

endif

if ( ! { (which irun >& /dev/null) } ) then
    echo IES installation not found
    exit 1
endif

if ( ! $?UVM_ML_CDS_INST_DIR ) then
setenv UVM_ML_CDS_INST_DIR `ncroot`
endif

if ( ! $?UVM_ML_CC) then
setenv UVM_ML_CC ${UVM_ML_CDS_INST_DIR}/tools/cdsgcc/gcc/bin/g++
endif

if ( ! $?UVM_ML_LD) then
setenv UVM_ML_LD $UVM_ML_CC
endif

if ( ! $?UVM_ML_SVDPI_DIR ) then
setenv UVM_ML_SVDPI_DIR ${UVM_ML_CDS_INST_DIR}/tools/include
endif

setenv WRAPPER_SPECIFIC_HELP "This wrapper is aimed to build UVM-ML-OA in IES/NCSC environment. \
Any OSCI-related stuff is being built only if OSCI_SRC and OSCI_INSTALL are set in the environment. \
This wrapper passes --build-tcl-debug, --build-cdns-backplane-loader \
and --build-ncsc to install.csh in a hardcoded way."


# You may customize the name of the resulting setup scripts (this is useful if you require multiple different builds)
# For that, you should set the environment variable     UVM_ML_SETUP_BASE_NAME 
# The resulting script names will be composed by adding a suffix to the base name, such as:
#          ${UVM_ML_SETUP_BASE_NAME}_<bits>.<ext>
#     (<bits> = 32 or 64, <ext> = one of the file extensions: SH (shell), CSH (C-shell), mk (GNU make)
# For example, if you set the base name like this
#          setenv   UVM_ML_SETUP_BASE_NAME   ${UVM_ML_HOME/ml/setup_ies 
# then the three resulting scripts for 32 bit compilation would be 
#         ${UVM_ML_HOME}/ml/setup_ies_32.csh
#         ${UVM_ML_HOME}/ml/setup_ies_32.csh
#         ${UVM_ML_HOME}/ml/setup_ies_32.mk

if ( $?OSCI_INSTALL && $?OSCI_SRC ) then
    set build_osci_flag="--build-osci"
else
    set build_osci_flag="--no-osci"
endif

source $UVM_ML_HOME/ml/install.csh --build-tcl-debug --build-cdns-backplane-loader --build-ncsc ${build_osci_flag} $*
