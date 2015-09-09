<'

package xor1;
struct operation {
                        -- Physical fields
    %a: uint (bits: 1);  -- First input
    %b: uint (bits: 1);  -- Second input
 
    !xor_result: int;      
    
                -- The result of the XOR, from the DUT
                -- (Note: "!" means "do not generate")
    
   //  event collect_it;
   // cover collect_it is  {
   //     item a;
   //     item b;
   //     item result_from_dut;
   // };
};

'>