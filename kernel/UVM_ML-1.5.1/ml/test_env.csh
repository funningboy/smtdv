#! /bin/tcsh -f
##
################################################
##
## test_install.sh
##         This file helps to test the installation was done 
##         correctly. It prints out tool version info and echoes
##         the environment variables used by UVM-ML, for the 
##         user to examine and verify.
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

echo "########## BEGIN_TESTING ##########"
set err = 0

echo "irun:       " `which irun`
echo "ncroot:     " `ncroot`
echo "Specman:    " `which specman`
echo "vcs:        " `which vcs`
echo "questa:     " `which vsim`


if ( $?UVM_ML_HOME ) then
    echo "UVM_ML_HOME:" $UVM_ML_HOME
    set last = `echo $UVM_ML_HOME|tail -c2`
    if ("$last" == '/') then
      echo "*** WARNING: UVM_ML_HOME terminates with /"
      echo "    Please remove trailing slash"
      #exit 1
    endif
    if ( -e $UVM_ML_HOME/ml/timestamp ) then 
      echo "timestamp:  " `cat $UVM_ML_HOME/ml/timestamp`
    else
      echo "timestamp      undefined"
    endif
else
    echo "*** ERROR: UVM_ML_HOME is undefined"
    exit 1
endif

if ( $?VCS_HOME ) then
    echo "VCS_HOME:     " $VCS_HOME
else
    echo "VCS_HOME       undefined"
endif

if ( $?MTI_HOME ) then
    echo "MTI_HOME:     " $MTI_HOME
else
    echo "MTI_HOME       undefined"
endif

if ( $?UVM_ML_COMPILER_VERSION ) then
    echo "UVM_ML_COMPILER_VERSION:" $UVM_ML_COMPILER_VERSION
endif

echo "g++:          " `which g++`

if ( $?IES_VERSION ) then
  if ( $IES_VERSION != `$UVM_ML_HOME/ml/tools/get_ies_version.sh` ) then
    echo "*** ERROR: Inconsistent IES version"
    echo "    IES_VERSION is $IES_VERSION"
    echo "    PATH contains IES version `$UVM_ML_HOME/ml/tools/get_ies_version.sh`"
    set err = 3
  else
    echo "IES_VERSION:  " $IES_VERSION
  endif
else
    echo "IES_VERSION    undefined"
    set err = 0
endif 

if ( $?OSCI_VERSION ) then
  echo "OSCI_VERSION: " $OSCI_VERSION
else
  echo "OSCI_VERSION   undefined" 
endif

if ( $?TLM2_INSTALL ) then
  echo "TLM2_INSTALL: " $TLM2_INSTALL
else 
  echo "TLM2_INSTALL   undefined" 
endif

if ( $?OSCI_SRC ) then
  echo "OSCI_SRC:     " $OSCI_SRC
else
  echo "OSCI_SRC       undefined"
endif

if ( $?OSCI_INSTALL ) then 
  echo "OSCI_INSTALL: " $OSCI_INSTALL
else
  echo "OSCI_INSTALL   undefined"
endif


echo "g++ version:  " `g++ --version`

echo ""

if ( $?UVM_ML_CC ) then
  echo "UVM_ML_CC:       " $UVM_ML_CC
else
    echo "*** ERROR: UVM_ML_CC is undefined"
    set err = 2
endif

if ( $?UVM_ML_LD ) then
    echo "UVM_ML_LD:       " $UVM_ML_LD
else
    echo "*** ERROR: UVM_ML_LD is undefined"
    set err = 2
endif

if ( $?UVM_ML_SVDPI_DIR ) then
    echo "UVM_ML_SVDPI_DIR:" $UVM_ML_SVDPI_DIR
else
    echo "*** ERROR: UVM_ML_SVDPI_DIR is undefined"
    set err = 2
endif


if ( ($?UVM_HOME) ) then
  if($UVM_HOME != $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml) then
    echo "*** ERROR: UVM_HOME should not be defined " $UVM_HOME
    echo "    value will be set internally to $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml"
    echo "unsetenv UVM_HOME"
    set err = 1
  endif
endif


if ($?UVM_ML_OVERRIDE) then
    echo "UVM_ML_OVERRIDE: " $UVM_ML_OVERRIDE
    if ( ! -d ${UVM_ML_OVERRIDE} ) then 
      echo "*** WARNING: UVM_ML_OVERRIDE does not point to a directory"
    else if ( ! -f ${UVM_ML_OVERRIDE}/libuvm_ml_bp.so ) then
      echo "*** ERROR: $UVM_ML_OVERRIDE/""libuvm_ml_bp.so not found" 
      set err = 1
    else if ( ! -f ${UVM_ML_OVERRIDE}/libml_uvm.so ) then
      echo "*** ERROR: $UVM_ML_OVERRIDE/""libml_uvm.so not found" 
      set err = 1
    else if ($?UNILANG_OVERRIDE) then
      echo "UNILANG_OVERRIDE:" $UNILANG_OVERRIDE
      if ( ! -d ${UNILANG_OVERRIDE} ) then 
        echo "*** WARNING: UNILANG_OVERRIDE does not point to a directory"
      else if ( ! -f ${UNILANG_OVERRIDE}/libml_uvm.so ) then
        echo "*** WARNING: $UNILANG_OVERRIDE""libml_uvm.so not found" 
      else if ( ! -f ${UNILANG_OVERRIDE}libml_uvm.so ) then
        echo "*** ERROR: UNILANG_OVERRIDE must end with '/'" 
        echo "    unsetenv UNILANG_OVERRIDE"
        set err = 2
      endif
    endif
else
    echo "*** WARNING: UVM_ML_OVERRIDE is not defined"
endif


if ($?UVM_ML_BITS) then
    echo "UVM_ML_BITS:     " $UVM_ML_BITS
else 
    echo "*** WARNING: UVM_ML_BITS is undefined"
    set err = 2
endif

echo ""
set ok32 = 0
set ok64 = 0

if($err != 0) then
    echo "*** See error messages above"
else
  if( -f $UVM_ML_HOME/ml/libs/backplane/$UVM_ML_COMPILER_VERSION/64bit/libuvm_ml_bp.so) then
    echo "Installation for 64bit OK"
    set ok64=1
  endif
  if( -f $UVM_ML_HOME/ml/libs/backplane/$UVM_ML_COMPILER_VERSION/libuvm_ml_bp.so) then
    echo "Installation for 32bit OK"
    set ok32=1
  endif
  if( $ok64 == 0 && $ok32 == 0 ) then
    echo "*** ERROR: Installation problem: libuvm_ml_bp.so not found"
    if ($?UVM_ML_BITS) then
      echo "source "\$"UVM_ML_HOME/ml/install_"$UVM_ML_BITS".csh" 
    else
      echo "source "\$"UVM_ML_HOME/ml/install_*.csh" 
    endif
    exit 1
  endif
endif
if($err == 1) then
  if ($?UVM_ML_BITS) then
    echo "*** Suggestion: source "\$"UVM_ML_HOME/ml/install_"$UVM_ML_BITS".csh"
  else
    echo "*** Suggestion: source "\$"UVM_ML_HOME/ml/install_*.csh"
  endif
endif
if($err == 2) then 
  if ($?UVM_ML_BITS) then
    echo "*** Suggestion: source "\$"UVM_ML_HOME/ml/setup_"$UVM_ML_BITS".csh"
  else
    echo "*** Suggestion: source "\$"UVM_ML_HOME/ml/setup_*.csh"
  endif
endif
if($err == 3) then 
    echo "*** Suggestion: install the appropriate IES version or change the environment variable to match the installed version"
endif
echo "####### END TESTING ##########" 
