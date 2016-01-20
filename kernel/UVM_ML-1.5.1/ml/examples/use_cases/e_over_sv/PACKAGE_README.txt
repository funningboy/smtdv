******************************************************************************
* Title: UBUS UVC driven from e testbench
* Name: e_over_sv
* Version: 1.1
* Requires:
* Modified: 12 Feb 2014
* Category: ML sequence layering
* Support: 
* Documentation: 
* Release notes: 

* Description:

The e testbench drives sequences and sequence items into the SV UBUS VIP.
Designed to work on top of UVM-ML-OA 1.3 or later


* Directory structure:

This package contains the following directories:
 
  e/                  - e sources
  sv/                 - SystemVerilog sources
  ../../ex_single_lang_uvcs_lib/ubus_sv  - the source code for the xbus UVC
  ../../../primitives - templates used in this example

* Installation:
  Set the environment as described in $UVM_ML_HOME/ml/README_INSTALLATION.txt

* To demo:
  Set SPECMAN_PATH to find both this package as well as the xbus and the  
  primitives packages
  % setenv SPECMAN_PATH ../../ex_single_lang_uvcs_lib:../../../primitives
  % semo.sh IES
  or
  % make ies
