<'
-----------------------------------------------------------------------------
-- Example file xor_verify.e: An example of using TCM.
-- To run this test you have to activate Verilog and use the xor.v example
-- in this same directory. This TCM example is a verification of this
-- xor.v Verilog module.
-----------------------------------------------------------------------------

package xor1;

import uvm_e/e/uvm_e_top.e;
import operation.e;
import operation_ser.e;

unit verify like uvm_agent {   
    
   // This code section is redundant starting version 14.1
   agent: string;
   keep soft uvm_config_get(agent);
   keep agent() == agent;
   
   hdl_path: string;
   keep soft uvm_config_get(hdl_path);
   keep hdl_path() == hdl_path;
   // end redundant section
      
    clk : in simple_port of bit is instance;
    p_inp : out simple_port of uint(bits:2) is instance;
    p_out : in simple_port of bit is instance;
    
    w_out: out simple_port of bit is instance;
    w_in:in simple_port of bit is instance;
    
    keep bind(w_out,external);
    keep w_out.hdl_path() == "specman_writes_this";
    keep w_out.verilog_wire()==TRUE;
    keep w_out.verilog_forcible()==TRUE;
    keep bind(w_in,external);
    keep w_in.hdl_path() == "specman_reads_this";
    keep w_in.verilog_wire()==TRUE;
    keep w_in.verilog_forcible()==TRUE;
    
    keep bind(p_inp,external);
    keep p_inp.hdl_path() == "inp_xor";
    
    keep bind(p_out,external);
    keep p_out.hdl_path() == "out_xor";
    
    keep bind(clk,external);
    keep clk.hdl_path() == "clk";
    
    event xor_clk is fall(clk$) @sim; -- Define a clocked event
    
    get_port  : out interface_port of tlm_get of operation is instance;
      keep bind(get_port,external);
    
        xor_drive() @xor_clk is {	  	      
            var p:operation;
            var wire_val:bit=1'b1;
            var res:bool;
        for i from 1 to 10 {	
            get_port$.get(p);
            message(LOW, "got this operation: ", p);
            p_inp$ = pack(NULL,p);
            wire_val=~wire_val;
            w_out$=wire_val;
            wait cycle;     -- Wait one more cycle before the next op
            p.xor_result = p_out$;
            -- Put the result in the field of operation
            print p;   -- Print it
            print p_out$;
            print (p.a ^ p.b);
	    print sys.time;
            check that p.xor_result == (p.a ^ p.b);
        };
        stop_run();        -- Stop the Verilog operation. Note the
    };
    
    
    
    run() is also {
        start xor_drive();
    };
    
};

extend sys {
    pre_stub_generation() is also {
        uvm_ml_create_stub_unit("stub_unit_for_xor","uvm_test_top.verify");
    };
};

unit stub_unit_for_xor like uvm_ml::parent_component_proxy {
   verify: verify is instance;
   keep hdl_path() == "~/top.xor_try";
   keep agent() == "SV";
};

'>