
`timescale 1ns/10ps

`include "smtdv_vif.sv"

module top();

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import test_smtdv_common_pkg::*;
  `include "smtdv_macros.svh"

  typedef virtual interface smtdv_gen_rst_if#("smtdv_rst_if", 100, 0) rst_t;

  reg clk;
  wire resetn;

  initial begin
    clk= 0;
     forever clk= #5 ~clk;
  end

  smtdv_gen_rst_if rst_if(resetn);
  defparam rst_if.if_name       = "smtdv_rst_if";
  defparam rst_if.PWRST_PERIOD  = 100;
  defparam rst_if.POLARITY      = 0;

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
    uvm_config_db#(rst_t)::set(uvm_root::get(), "*", "rst_vif", rst_if);
    run_test();
  end

  initial begin
    $dumpfile("test_smtdv.vcd");
    $dumpvars(0, top);
  end

endmodule
