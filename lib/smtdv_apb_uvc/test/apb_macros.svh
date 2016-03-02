`ifndef __APB_MACROS_SVH__
`define __APB_MACROS_SVH__

`define APB_SLAVE_CREATE(CFG, AGENT, ID) \
   ``CFG`` = ``CFG``_t::type_id::create({$psprintf("slv_cfgs[%0d]", ID)}, this); \
   \
   `SMTDV_RAND_WITH(``CFG``, { \
       has_force == TRUE;    \
       has_coverage == TRUE; \
       has_export == TRUE;   \
       has_error == TRUE;    \
       has_debug == TRUE;    \
       has_notify == TRUE;   \
   }) \
   \
   if (!$cast(slv_cfgs[ID], ``CFG``)) \
    `uvm_error("SMTDV_DCAST_SLV_CFG",  \
        {$psprintf("DOWN CAST TO SMTDV SLV CFG FAIL")}) \
   \
   ``AGENT`` = ``AGENT``_t::type_id::create({$psprintf("slv_agts[%0d]", ID)}, this); \
   if (!$cast(slv_agts[ID], ``AGENT``)) \
     `uvm_error("SMTDV_DCAST_SLV_AGENT",  \
        {$psprintf("DOWN CAST TO SMTDV SLV AGENT FAIL")}) \
   \
   uvm_config_db#(uvm_bitstream_t)::set(  \
       null, \
       {$psprintf("/.+slv_agts[*%0d]*/", ID)}, \
       "is_active", \
       UVM_ACTIVE \
   ); \
   \
   uvm_config_db#(slv_cfg_t)::set( \
       null, \
       {$psprintf("/.+slv_agts[*%0d]*/", ID)}, \
       "cfg", \
       slv_cfgs[ID] \
   );

`define APB_MASTER_CREATE(CFG, AGENT, ID) \
    ``CFG`` = ``CFG``_t::type_id::create({$psprintf("mst_cfgs[%0d]", ID)}, this); \
    `SMTDV_RAND_WITH(``CFG``, { \
        has_force == TRUE;    \
        has_coverage == TRUE; \
        has_export == TRUE;   \
        has_retry == TRUE;    \
        has_debug == TRUE;    \
        has_notify == TRUE;   \
    }) \
    \
    if (!$cast(mst_cfgs[ID], ``CFG``)) \
    `uvm_error("SMTDV_DCAST_MST_CFG",  \
        {$psprintf("DOWN CAST TO SMTDV MST CFG FAIL")}) \
    \
    for(int j=0; j<NUM_OF_SLAVES; j++) begin  \
        start_addr = `APB_START_ADDR(j) \
        end_addr = `APB_END_ADDR(j) \
        mst_cfgs[ID].add_slave(slv_cfgs[j], j, start_addr, end_addr); \
    end \
    \
    ``AGENT`` = ``AGENT``_t::type_id::create({$psprintf("mst_agts[%0d]", ID)}, this); \
    if (!$cast(mst_agts[ID], ``AGENT``)) \
     `uvm_error("SMTDV_DCAST_MST_AGENT",  \
        {$psprintf("DOWN CAST TO SMTDV MST AGENT FAIL")}) \
    \
    uvm_config_db#(uvm_bitstream_t)::set( \
        null, \
        {$psprintf("/.+mst_agts[*%0d]*/", ID)}, \
        "is_active", \
        UVM_ACTIVE \
    ); \
    \
    uvm_config_db#(mst_cfg_t)::set( \
        null, \
        {$psprintf("/.+mst_agts[*%0d]*/", ID)}, \
        "cfg", \
        mst_cfgs[ID] \
    );

`endif // __APB_MACROS_SVH__
