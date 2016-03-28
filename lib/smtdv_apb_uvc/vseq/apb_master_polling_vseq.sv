
`ifndef __APB_MASTER_POLLING_VSEQ_SV__
`define __APB_MASTER_POLLING_VSEQ_SV__

class apb_master_polling_vseq
  extends
  apb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_master_polling_vseq vseq_t;
  typedef apb_master_cfg_seq#(ADDR_WIDTH, DATA_WIDTH) seq_cfg_t;
  typedef apb_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stop_t;
  typedef apb_master_polling_seq#(ADDR_WIDTH, DATA_WIDTH) seq_pol_t;

  seq_cfg_t seq_cfgs[$];
  seq_pol_t seq_pol;
  seq_stop_t seq_stop;

  static const bit [ADDR_WIDTH-1:0] start_addr = `APB_START_ADDR(0)
  static const bit [ADDR_WIDTH-1:0] end_addr = `APB_END_ADDR(0)
  static const bit [DATA_WIDTH-1:0] pats[$] = '{ 'h0, 'h4 };
  bit [ADDR_WIDTH-1:0] cur_addr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_polling_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    cur_addr = start_addr;
    super.pre_body();

    if (!$cast(vseqr, this.get_sequencer()))
      `uvm_error("SMTDV_UCAST_V/PSEQR",
         {$psprintf("UP CAST TO SMTDV V/PSEQR FAIL")})

    `uvm_create_on(seq_cfgs[0], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_cfgs[0],
      {
        seq_cfgs[0].start_addr == cur_addr;
        seq_cfgs[0].write_data == pats[0];
      })

    `uvm_create_on(seq_cfgs[1], vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_cfgs[1],
      {
        seq_cfgs[1].start_addr == cur_addr;
        seq_cfgs[1].write_data == pats[1];
      })

   `uvm_create_on(seq_pol, vseqr.apb_magts[0].seqr)
    `SMTDV_RAND_WITH(seq_pol,
    {
       seq_pol.start_addr == cur_addr;
       seq_pol.expect_data == pats[1];
    })

    `uvm_create_on(seq_stop, vseqr.apb_magts[0].seqr)

     graph = '{
        nodes:
           '{
               '{
                   uuid: 0,
                   seq: seq_cfgs[0],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 0, "seq_cfgs[0]")}
               },
               '{
                   uuid: 1,
                   seq: seq_cfgs[1],
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 1, "seq_cfgs[1]")}
               },
               '{
                   uuid: 2,
                   seq: seq_stop,
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 2, "seq_stop")}
                },
               '{
                   uuid: 3,
                   seq: seq_pol,
                   seqr: vseqr.apb_magts[0].seqr,
                   prio: -1,
                   desc: {$psprintf("bind Node[%0d] as %s", 2, "seq_pol")}
                }
           },
        edges:
           '{
               '{
                   uuid: 0,
                   sourceid: 0,
                   sinkid: 1,
                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 0, 0, 1)}
               },
               '{
                   uuid: 1,
                   sourceid: 1,
                   sinkid: 3,
                   desc: {$psprintf("bind Edge[%0d] from Node[%0d] to Node[%0d]", 1, 1, 3)}
               }
           }
     };
  endtask : pre_body

  virtual task body();
    super.body();
    fork
      begin seq_cfgs[0].start(vseqr.apb_magts[0].seqr, this, 0); end
      begin seq_cfgs[1].start(vseqr.apb_magts[0].seqr, this, 0); end
      begin seq_pol.start(vseqr.apb_magts[0].seqr, this, 0); end
      begin seq_stop.start(vseqr.apb_magts[0].seqr, this, 0); end
    join_none
    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.apb_magts[0].seqr.finish);
  endtask : post_body

endclass : apb_master_polling_vseq


`endif // __APB_MASTER_PRELOAD_VSEQ_SV__


