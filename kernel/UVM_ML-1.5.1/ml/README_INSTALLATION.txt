File: README_INSTALLATION.txt	

Content: Installation and Setup directions for the UVM-ML OA package

Note: "UVM-ML OA" stands for the UVM-Multi-Language Open-Architecture 
      Verification Methodology Package. 
      In this README file, "UVM-ML" is a shorthand for UVM-ML OA

----------------------------------------------------------------------
   (C) Copyright 2013-2015 Cadence Design Systems, Incorporated
   (C) Copyright 2013-2015 Advanced Micro Devices, Inc.
   All Rights Reserved Worldwide

   Licensed under the Apache License, Version 2.0 (the
   "License"); you may not use this file except in
   compliance with the License.  You may obtain a copy of
   the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in
   writing, software distributed under the License is
   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.  See
   the License for the specific language governing
   permissions and limitations under the License.
----------------------------------------------------------------------

This package contains the UVM-ML solution code, along with
documentation and examples to demonstrate typical use cases.

This document describes how to install the package and run an example
to verify that the installation is operational.

If you have any issues, consult the trouble shooting section in the
UVM-ML OA User Guide.

For more information about the package please open README.html. It
gives a hyperlinked list of all relevant material and suggests where
to start reading from.


CONTENTS OF THIS README
-----------------------
(1)  Tools
	(1.1) Simulation tools
	(1.2) Language libraries
	(1.3) Build tools
(2)  UVM-ML Installation
	(2.1) Installation steps
	(2.2) Setup the environment
	(2.3) install_*.csh options
	(2.4) Optional environment values
        (2.5) Re-Install options
(3)  Running a demo
(4)  Installing ASI-SystemC and TLM2
(5)  Building the package manually
(6)  Building the portable adapter for Questa


Note: The package was designed to work on Linux operating system only.


(1) Tools
----------------------------------------------------------------------
To build the library and run the examples, you need the tools listed
below.  A subset of these tools may be sufficient, depending on the
simulators and programming languages you use.

(1.1) Simulation tools
-----------------------
The package was tested with IES, VCS, Questa and ASI-SystemC.

For simulation, use one or more of these supported versions:
- Cadence IES: version 14.1 up to 15.1. 

     Runs SystemVerilog and SystemC and requires Specman for e. 
     Also verified with ASI-System.

- Synopsys VCS: 

     Verified against version 2014.12 SP1.
     Runs SustemVerilog and requires Specman for e and verified against 
     ASI-SystemC.

- Mentor Questa:

     Verified against version 10.3d. 
     Runs SystemVerilog and SystemC and requires Specman for e. 
     Also verified with ASI-System.

- ASI-SystemC: 2.2.0, 2.3.0  
      
     Runs with SystemC versions 2.2.0 or 2.3.0
     ASI-SystemC can run simulations with any of the simulators above 
     (available on  http://www.accellera.org/downloads/standards/systemc).

- Specman e: version 14.1 up to 15.1.

(1.2) Language libraries
-------------------------
- TLM version - TLM 2.0.1 (2009-07-15) only for SystemC 2.2 because 
  version 2.3 already includes TLM (available on  
     http://www.accellera.org/downloads/standards/systemc)
- UVM-SV ML-enabled version - included in this package (1.1d-ml is an 
  ML-enabled version of UVM-SV)

(1.3) Build tools
-----------------
To build the package use:
- GCC version - v4.1-v4.4.5
- GNU Make 3.81
- TCL 8.4

(2) UVM-ML Installation
---------------------------------------------------------------------    

(2.1) Installation steps
------------------------
1. Untar the package in a clean UNIX directory (do not extract
   the package in Windows because Windows will not create the   
   necessary links and the package will not be installed    
   properly).
2. Set the environment variable UVM_ML_HOME to point to the root directory of the UVM-ML installation (UVM_ML-xxx, where xxx is the version number of this release)
   % setenv UVM_ML_HOME  <UVM-ML installation path>/UVM_ML-1.5
3. Add the relevant path to PATH
   -For IES:    % set path=( <path to irun> $path)
   -For VCS:    % set path=( <path to vcs> $path) 
   -For Questa: % set path=( <path to questa> $path) 
4. <optional>: set the values of the following advanced environment values 
   (each explained in 2.4):
      UVM_ML_CC   UVM_ML_LD  OSCI_VERSION  OSCI_INSTALL  OSCI_SRC  TLM2_INSTALL
5. Source the install script: install_<simulator>.csh
   - For IES:    % source $UVM_ML_HOME/ml/install_ies.csh [--64bit]
   - For VCS:    % source $UVM_ML_HOME/ml/install_vsc.csh [--64bit]
   - For QUESTA: % source $UVM_ML_HOME/ml/install_questa.csh [--64bit]

6. The install script creates a setup script, that you should source in each 
  new shell (see next section for details).

(2.2) Setup the environment
---------------------------
 Before using UVM-ML, you should setup the environment with all the 
 environment variables. This has to be done for each new shell, so please 
 follow the following steps:
  1. setenv UVM_ML_HOME <install dir>
  2. Source the setup script which are created under $(UVM_ML_HOME)/ml.
     In CSH/TCSH, for 32-bit environment:
     % source ${UVM_ML_HOME}/ml/setup_32.csh
     Same for 64-bit environment: 
     % source ${UVM_ML_HOME}/ml/setup_64.csh
     In Bourne shell, for 32-bit environment: 
     % . ${UVM_ML_HOME}/ml/setup_32.sh
     Same for 64-bit environment: 
     % . ${UVM_ML_HOME}/ml/setup_64.sh


(2.3) install_*.csh options
---------------------------
Various options are provided to control the install_*.csh    
script:
     - To install the environment on a 64 bit machine use --64bit
     - To build without the ASI SystemC (for IES only) use --no-osci
     - To build without Specman (SV/SC only) use --no-specman

(2.4) Optional environment values
---------------------------------
- UVM_ML_CC and UVM_ML_LD: UVM-ML OA installation uses the default compiler 
  and linker for SystemC/C++ which come with IES in the IES case and
  the ones on the machine in the VCS and Questa case.  In case you
  want to use other tools, you can define them in the following
  environment variables: UVM_ML_CC (for compilation) and UVM_ML_LD
  (for linking).
- OSCI_VERSION:
  % setenv OSCI_VERSION 2.<x>
  ASI SystemC versio, e.g. 2.2 or 2.3
- OSCI_install:
  % setenv OSCI_INSTALL <path to osci 2.x compiled with g++-4.4.5-pic>
  ASI SystemC path, this is the same directory provided as --prefix to
  OSCI's configuration e.g. .../2.2/g++-4.4.5-pic
- OSCI_SRC 
  % setenv OSCI_SRC <path to source for OSCI SystemC>
  ASI SystemC sources path, e.g. .../systemc/systemc-2.2.0
- TLM2_INSTALL:
  % setenv TLM2_INSTALL <path to installation of SystemC TLM-2009-07-15>
  e.g. .../TLM-2009-07-15  // for SC version 2.2 
  e.g. setenv TLM2_INSTALL $OSCI_SRC // for ASI SystemC version 2.3


(2.5) Re-Install options
------------------------
If you need to reinstall the library, perform the same steps as in the
original installation. However, when sourcing the install_*.csh script
(the last step), there are some options relevant to reinstall only:
     - To avoid rebuilding the backplane use --no-backplane
     - To avoid rebuilding BOOST use --no-boost
     - To rebuild the entire package use --clean
     - To set up the environment without rebuilding use --env_only

(3) Running a demo
----------------------------------------------------------------
Run a simple demo to make sure your installation is successful. 

   % ${UVM_ML_HOME}/ml/examples/first_time_demo.sh <IES|VCS|QUESTA>
Note:
1. More demo examples can be found in $UVM_ML_HOME/ml/examples. 
   A README file in each demo directory explains how to run the 
   demo in various environments. 
2. A more detailed explanation on running the examples can be     
   found in the Running the UVM-ML OA Demos.pdf document (located under 
   $UVM_ML_HOME/ml/examples).


(4) Installing ASI-SystemC and TLM2
--------------------------------------------------------------------
TLM2 and the ASI-SystemC simulator can be downloaded from 
http://www.accellera.org/downloads/standards/systemc. 
You can select systemc-2.3.0.tgz that includes TLM, or systemc-2.2.0.tgz 
and TLM-2.0.1.tgz.

Installation of TLM2 is done by opening the tar.

Instructions of how to install the OSCI SystemC simulator can be found
in http://openesl.org/systemc-wiki/Installation. Note however, that
the use model of UVM-ML requires compiling the OSCI engine into a
shared library. To get a position independent 64-bit shared library,
you must pass the "-fPIC" flag to g++.

Thus to compile the 64-bit OSCI library fit for UVM-ML usage: 
1. Build it as follows: 
   % gmake CFLAGS='-fPIC' CXXFLAGS='-fPIC' LDFLAGS='-fPIC' \
     EXTRA_CXXFLAGS='-fPIC' install
   % gmake check
2. Set the appropriate environment variable to the directory you provided in 
   the --prefix flag in the configuration script.

Note: UVM-ML is tested using g++ 4.4.5. Please compile the OSCI engine
using the same compiler.

(5) Building the package manually
-------------------------------------------------------------------------------
If there is need to incorporate UVM-ML OA into a proprietary flow instead of 
using the install_*.csh, you must be aware of following:
 - All the default installation scripts above make use of the  
   ml/install.csh script, which has many options for specific    
   needs.
 - UVM-ML OA 1.3.4 and later includes its own specfiles in 
   $UVM_ML_HOME/ml/tools/specfiles, and further on per IES    
   version. Each subdirectory contains specfiles for g++ 4.4 and      
   4.1; the names should be self-explanatory.
 - The makefiles use the UVM_ML_COMPILER_VERSION environment      
   variable to refer to the appropriate specfile. If undefined, 
   the variable is deduced automatically by running $UVM_ML_CC -  
   version and analyzing its output. In general, "-gcc_vers 
  <desired version> -spec <desired specfile>" should be 
   passed to irun/ncsc_run.
 - The specfiles in question are MANDATORY for IES users.    
   Failing to state the appropriate specfile can cause IES-
   supplied UVM-SC headers to be used instead of UVM-ML ones, 
   resulting in all kinds of compilation and simulation failures    
   hard to decipher.

(6) Building the portable adapter for Questa
------------------------------------------------------------------------------
There are instructions in the UVM Multi-Language Open Architecture
User Guide on how to rebuild the portable adapter for Questa when
using Questa SystemC. Make sure to set UVM_ML_CC and UVM_ML_LD to the
location of g++ in the Questa installation directory. If you are using
the install.csh script use it as shown below:

   % source $UVM_ML_HOME/ml/install.csh --no-ncsc --no-osci

