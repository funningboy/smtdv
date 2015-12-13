
`timescale 1ns/10ps

`include "smtdv_vif.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  `include "./test/smtdv_test_list.sv"

  reg clk;
  reg resetn;

  initial begin
    resetn = 1;
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_if vif0(
    .clk(clk),
    .resetn(resetn)
  );

  smtdv_if vif1(
    .clk(clk),
    .resetn(resetn)
  );

  initial begin
    uvm_config_db#(virtual interface smtdv_if)::set(uvm_root::get(), "*.master_agent[*0]*", "vif", vif0);
    uvm_config_db#(virtual interface smtdv_if)::set(uvm_root::get(), "*.slave_agent[*0]*", "vif", vif1);
    run_test();
  end

  initial begin
    $dumpfile("test_smtdv.vcd");
    $dumpvars(0, top);
  end

endmodule
