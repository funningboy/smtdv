`ifndef __SMTDV_GEN_RST_IF_SV__
`define __SMTDV_GEN_RST_IF_SV__

`timescale 1ns/10ps

/**
* smtdv_gen_rst_vif
* as smart rst to notify all registered comp to do reset methodology
* default is negative reset
*
* @class smtdv_gen_rst_if(output logic rst)
*
*/
interface smtdv_gen_rst_if (output logic rst);

  parameter string  if_name       = "smtdv_gen_rst_if";
  parameter time    PWRST_PERIOD  = 1000;
  parameter bit     POLARITY      = 0;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "smtdv_macros.svh"

  time      deassert_period_before_pwrst = 1000;
  semaphore rst_sm;

  initial begin
    time rand_period;

    rst_sm= new(1);

    if(!rst_sm.try_get()) begin
      `uvm_fatal(if_name, "RESET_CONFLICT: User specified reset is in process")
      end

    `uvm_info(if_name, "Power-On Reset Initialized ...", UVM_HIGH)

    rst= ~POLARITY;                     // deassert

    `SMTDV_RAND_VAR_WITH(rand_period,
      {
        rand_period inside {[0:deassert_period_before_pwrst]};
      }
    )
    #(rand_period*1ns) rst= POLARITY;   // assert

    #(PWRST_PERIOD*1ns) rst= ~POLARITY; // deassert

    `uvm_info(if_name, "Power-On Reset Released ...", UVM_HIGH)

    rst_sm.put();
    end

  task automatic do_reset(time period = 1000);
    if(!rst_sm.try_get()) begin
      `uvm_fatal(if_name, "RESET_CONFLICT: Either Power-On reset or User specified reset is in process")
      end

    rst= POLARITY;
    fork
      begin
        rst= #(period*1ns) ~POLARITY;
        rst_sm.put();
        end
      join_none
  endtask

  task automatic wait_reset_done();
    wait(rst === ~POLARITY);
  endtask

endinterface

`endif // end of __GEN_RST_IF_SV__
