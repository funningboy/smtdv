******************************************************************************
* Title: XBus eVC driven from SystemVerilog testbench
* Name: sv_over_e
* Version: 1.2
* Requires:
* Modified: 28 Oct 2014
* Category: ML sequence layering
* Support: 
* Documentation: 
* Release notes: 

* Description:

The SV testbench drives sequences and sequence items into the e XBUS UVC.
Designed to work on top of UVM-ML-OA 1.3 or later


* Directory structure:

This package contains the following directories:
 
  e/                     - e sources
  sv/                    - SystemVerilog sources
  ../../ex_single_lang_uvcs_lib/xbus_simple - the source code for the xbus UVC
  ../../../primitives    - templates and base classes used in this example

* Installation:
  Set the environment variable UVM_ML_HOME
  Setup your environment using the setup_32 or setup_64 script
  % source $UVM_ML_HOME/ml/setup_*.sh --env_only


* To demo:
  Set SPECMAN_PATH to find both this package as well as the xbus and the  
  primitives packages
  % setenv SPECMAN_PATH ../../ex_single_lang_uvcs_lib:../../../primitives
  % demo.sh IES
  or
  % make ies
