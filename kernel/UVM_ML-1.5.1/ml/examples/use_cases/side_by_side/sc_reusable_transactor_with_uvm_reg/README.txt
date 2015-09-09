This package demoes layering uvm_reg on top of a SystemC Transactor using uvm ml
Developer : patrick@cadence.com
Date : june 2015

Description : The current example demonstrates how to layer UVM SystemVerilog register 
package on top of a SystemC transactor. 
The SystemC transactor is a reusable component. In one case, the test could come from 
some software and transmit orders to the RTL DUT via the transactor.
In another use-case, demonstrated by the current example, this transactor is used with a 
UVM SystemVerilog testbench, controlled by the register sequences. 
The testbench translates a register operation sequence item (uvm_reg_bus_op 
transaction) into TLM2 tlm_generic_payload. The payload is transmitted to the 
SystemC transactor via UVM-ML. 
The transactor further drives the hbus transaction to the DUT, thus using the same
driver in both use-cases described above.

The package assumes the usage of IES/irun and that the uvm_ml package
from Accelera is already installed
In case you need to install it, please go to
http://forums.accellera.org/files/file/65-uvm-ml-open-architecture/
(or google uvm ml download) and follow instructions how to download and 
setup the package

The current package was tested against uvm ml 1.5 version
It includes following files

demo.sh : a shell to launch the demo

- scsv/reg_model.sv : A simplistic register model, implementing one register.
The adapter translates a uvm register operation into a uvm_tlm_generic_payload 
transaction. 

- scsv/test.sv : defines tlm2_sequencer, tlm2_driver and the uvm test
The tlm2_sequencer is the default sequencer of the register layer
The tlm2_driver takes all tlm_generic_payload and calls the SC layer
The uvm test instantiates the register model and starts a simple sequence

- scsv/hbus.v : a simple hbus dut with some registers. It s wrapped into a 
higher module called hbus, the hierarchy is then hbus/dut

- scsv/hbus.h and hbus.cpp are the SystemC wrappers to instantiate the dut in SC

- scsv/tlm2_to_hbus.h : the code of the transactor
It takes a tlm_generic_payload as input, translates it to an hbus transaction
and drives the hbus transaction into the bus

- scsv/top.cpp and top.h : defines the top SystemC 
The SC top instantiates the dut, the transactor, and connect needed ports







