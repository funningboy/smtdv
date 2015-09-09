******************************************************************************
* Title: UVM_ML Unified Hierarchy Demo
* Name: e_top_sv_tlm2
* Version: 1.0
* Requires:
* Modified: 2 Feb 2015
* Category: ML Unified Hierarchy
* Support: 
* Documentation: 
* Release notes: 

                       UVM_ML Unified Hierarchy Demo

This demo shows how to construct a unified hierarchy by incorporating a 
SystemVerilog IP in an e verification environment. The e environment and the 
embedded SV IP exchange TLM2 transactions.

The e testbench has an env component with a producer and a consumer. In 
addition it has an SV child component which is an env with a producer and 
consumer.


to set-up the environment refer to the README file at the top of this package. 

to run the demo on IES: 
	% demo.sh IES

to run with VCS and OSCI:
	% demo.sh VCS

to run with and OSCI:
	% demo.sh QUESTA


