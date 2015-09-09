******************************************************************************
* Title: XBus eVC 
* Name: xbus_simple
* Version: 1.0
* Requires:
* Modified: 2014
* Category: Golden UVC
* Support: 
* Documentation: 
* Release notes: 

* Description:

This is a simplified version of the XBus UVC. It has master and slave agents,
but not arbiter agent. The arbitration is implemented in Verilog.


* Directory structure:

This package contains the following directories:
 
  e/         - e sources
  v/         - Verilog testbench examples and an examnple arbiter

* Installation:
  Make sure that the parent directory of xbus_simple is on the SPECMAN_PATH


* To demo:
  Set SPECMAN_PATH to find both this package and run
  % `sn_which.sh xbus_simple/demo.sh`
