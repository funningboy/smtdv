******************************************************************************
* Title: UVM_ML Side-by-side
* Name: sc_sv_e
* Version: 1.2
* Requires:
* Modified: 2 Feb 2015
* Category: Three UVCs in different languages
* Support: 
* Documentation: 
* Release notes: 

* Description:


                          UVM_ML Side-by-side Demo

This simple environment demonstrates the basic features of UVM-ML OA. Three 
independent environments, one in e and one in SystemVerilog and one in SystemC
are co-simulated, exchanging data using TLM1 and TLM2 transactions in both 
directions, both blocking and non-blocking.

Each environment has an "env" component. The env components have
producer and consumer components. The producer generates data and sends it 
through the various ports and sockets, while the consumer reacts to the data 
using both the blocking and non-blocking interfaces.

to set-up the environment refer to the README file at the top of this package. 

to run the demo on IES:
	% demo.sh IES

to run with VCS and OSCI:
	% demo.sh VCS

to run with Questa and OSCI:
	% demo.sh QUESTA
