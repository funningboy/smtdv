module xor_try;
   
    reg  [1:0]  inp_xor;    // The two-bit inputs to the XOR
    reg     out_xor;        // The XOR output
    reg     clk;

   wire     specman_writes_this;
   wire     specman_reads_this;
   
   initial clk = 1'b1;
   always #50 clk = ~clk; // The clock
   
    always @(posedge clk) out_xor = #1 (inp_xor[0] ^ inp_xor[1]); // The actual operation   
   
endmodule // xor_try


