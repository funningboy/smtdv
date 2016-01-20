* Title:            Tests for UVM-ML OA
* Name:             e_sv_tlm2
* Version:          1.0
* Requires: 
* Created:          June 2014
* Category:         
* Support:          
* Documentation:
* Release notes: 
* Description:      Tests for ML transactions 

This simple environment demonstrates the basic features of UVM-ML OA. Two 
independent environments, one in e and one in SystemVerilog are 
co-simulated, exchanging data using TLM2 transactions, both blocking 
and non-blocking.

Each environment has a top component with an "env" component under it. The env 
components have producer and consumer components. The producer generates data 
and send it through the various ports, while the consumer reacts to the data 
using both the blocking and non-blocking interfaces.

to set-up the environment refer to the README_INSTALLATION.txt file at the top 
of this package. 
* To setup: 

* To demo:
  % make 

To remove all the temporary generated files:
  % make distclean

