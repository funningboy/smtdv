//---------------------------------------------------------------------------
// This is a Verilog file that define a XOR gate. It is used to demonstrate
// the interface of Specman to Verilog
//
//---------------------------------------------------------------------------
module top;
   
   //import uvm_sv and uvm_ml packages
   import uvm_pkg::*;
`include "uvm_macros.svh"
   import uvm_ml::*;
   //include the uvm sv top class
`include "svtop.sv"


   xor_try xor_try();
   
   
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[1];
   tops[0]="";
   uvm_ml_run_test(tops, "sv:svtop");
end
`endif
   
   
endmodule // top


