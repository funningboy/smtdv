******************************************************************************
* Title: UVM_ML Unified Hierarchy Demo
* Name: prod_cons
* Version: 1.0
* Requires:
* Modified: 2 Feb 2015
* Category: ML Unified Hierarchy
* Support: 
* Documentation: 
* Release notes: 


This demo shows how to construct a unified hierarchy by incorporating a UVM-e 
IP in a UVM-SV verification environment. The UVM-SV environment and the 
embedded UVM-e IP exchange TLM2 transactions.

The UVM-SV top component "svtop" has an env component with a producer and a 
consumer. In addition it has a UVM-e child component which is an env with a 
producer and consumer.

The UVM-SV top component configures the UVM-e and UVM-SV env components using
the configuration mechanism:
      uvm_config_int::set(this,"*producer","address", ($urandom() & 'hffff));
      uvm_config_int::set(this,"*","e_active",e_active);
      uvm_config_int::set(this,"*env","sv_active",sv_active);
Setting one of the IP "*_active" to FALSE results in the corresponding "env" 
component not instantiating the producer.

to set-up the environment refer to the README file at the top of this package. 

to run the demo on IES: 
	% demo.sh IES

to run with VCS and OSCI:
	% demo.sh VCS

to run with QUESTA and OSCI:
	% demo.sh QUESTA


