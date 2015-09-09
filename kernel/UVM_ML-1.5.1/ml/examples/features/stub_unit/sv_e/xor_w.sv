//---------------------------------------------------------------------------
// This is a Verilog file that define a XOR gate. It is used to demonstrate
// the interface of Specman to Verilog
//
//---------------------------------------------------------------------------
module xor_try;

   //import uvm_sv and uvm_ml packages
   import uvm_pkg::*;
`include "uvm_macros.svh"
   import uvm_ml::*;
   
   //include the uvm sv top class
`include "svtop.sv"
   
    reg  [1:0]  inp_xor;    // The two-bit inputs to the XOR
    reg     out_xor;        // The XOR output
    reg     clk;
   
   wire     specman_in;
   wire     specman_out;
   
   assign specman_in = ~specman_out;
   
   initial clk = 1'b1;
   always #50 clk = ~clk;
   // The clock
   
    always @(posedge clk) out_xor = #1 (inp_xor[0] ^ inp_xor[1]);
                // The actual operation

   //uvm ml additions
`ifdef USE_UVM_ML_RUN_TEST
initial begin
   string tops[2];   
   tops[0] = "SV:svtop";
   tops[1] = "e:xor_verify.e";
   uvm_ml_run_test(tops, "");
end
`endif
   
   
endmodule // xor_try


