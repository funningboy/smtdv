
`ifndef __APB_MASTER_INTERRUPT_VSEQ_SV__
`define __APB_MASTER_INTERRUPT_VSEQ_SV__

/*
* sequence graph test
*/
class apb_master_interrupt_vseq
  extends
  apb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_master_interrupt_vseq vseq_t;
  typedef apb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stl_t;
  typedef apb_master_irq_seq#(ADDR_WIDTH, DATA_WIDTH) seq_irq_t;
  typedef apb_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stop_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  seq_stl_t seq_stls[$];
  seq_irq_t seq_irq;
  seq_stop_t seq_stop;

  rand int cnt;
  constraint c_cnt { cnt inside {[10:20]}; }

  int nodeid = 0;
  int edgeid = 0;

  typedef struct {
    string q[$];
  } stls_t;

  stls_t stls = '{
    q:
        '{
            {getenv("SMTDV_HOME"), "/lib/smtdv_apb_uvc/stl/preload1.stl"},
            {getenv("SMTDV_HOME"), "/lib/smtdv_apb_uvc/stl/preload0.stl"}
        }
  };

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_interrupt_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    for(int i=0; i<cnt; i++) begin
      `uvm_create_on(seq_stls[i], vseqr.apb_magts[0].seqr)
      if (i%2==0)
        seq_stls[i].m_file = stls.q[0];
      else
        seq_stls[i].m_file = stls.q[1];

      graph.nodes[nodeid] = '{
                    uuid: nodeid,
                    seq: seq_stls[i],
                    seqr: vseqr.apb_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", nodeid, {$psprintf("seq_stls[%0d]", i)})}
                };
      nodeid++;
    end

    for(int i=0; i<cnt-1; i++) begin
      graph.edges[edgeid] = '{
                    uuid : edgeid,
                    sourceid: i,
                    sinkid: i+1,
                    desc: {$psprintf("bind Edge[%0d] form Node[%0d] to Node[%0d]", edgeid, i, i+1)}
                };
      edgeid++;
    end

    `uvm_create_on(seq_irq, vseqr.apb_magts[0].seqr)
    graph.nodes[nodeid] = '{
                    uuid: nodeid,
                    seq: seq_irq,
                    seqr: vseqr.apb_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", nodeid, "seq_irq")}
                };
      nodeid++;

    `uvm_create_on(seq_stop, vseqr.apb_magts[0].seqr)
    nodeid++;
   endtask : pre_body

  // read after write
  virtual task body();
    super.body();
    // TODO: use seq_graph.scheduler to handler seq's behavior
    foreach(seq_stls[i]) begin
      automatic int k;
      k = i;
      fork
        begin seq_stls[k].start(vseqr.apb_magts[0].seqr, this, 0); end
      join_none
    end

    fork
      begin seq_irq.start(vseqr.apb_magts[0].seqr, this, 0); end
      begin seq_stop.start(vseqr.apb_magts[0].seqr, this, 0); end
    join_none

    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.apb_magts[0].seqr.finish);
  endtask : post_body

endclass : apb_master_interrupt_vseq


`endif // __APB_MASTER_INTERRUPT_VSEQ_SV__
