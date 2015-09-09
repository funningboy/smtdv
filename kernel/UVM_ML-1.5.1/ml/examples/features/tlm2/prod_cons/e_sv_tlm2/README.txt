----------------------------------------------------------------------
   (C) Copyright 2013 Cadence Design Systems, Incorporated
   (C) Copyright 2013 Advanced Micro Devices, Inc.
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

                                 UVM_ML Demo

This simple environment demonstrates the basic features of UVM-ML. Two 
independent environments, one in SystemC and one in SystemVerilog are 
co-simulated, exchanging data using TLM2 transactions, both blocking 
and non-blocking.

Each environment has a top component with an "env" component under it. The env 
components have producer and consumer components. The producer generates data 
and send it through the various ports, while the consumer reacts to the data 
using both the blocking and non-blocking interfaces.

to set-up the environment refer to the README_INSTALLATION.txt file at the top 
of this package. 

to run the demo on IES and NCSC:
	% make ies

to run the demo on IES and OSCI: 
	% make ies_osci_proc

to run with VCS and OSCI:
	% make vcs

to run with Questa and OSCI:
	% make questa

