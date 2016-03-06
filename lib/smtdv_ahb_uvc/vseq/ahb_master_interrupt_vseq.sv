`ifndef __AHB_MASTER_INTERRUPT_VSEQ_SV__
`define __AHB_MASTER_INTERRUPT_VSEQ_SV__

/*
* sequence graph test
*/
class ahb_master_interrupt_vseq
  extends
  ahb_master_base_vseq;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef ahb_master_interrupt_vseq vseq_t;
  typedef ahb_master_stl_seq#(ADDR_WIDTH, DATA_WIDTH) seq_stl_t;
  typedef ahb_master_irq_seq#(ADDR_WIDTH, DATA_WIDTH) seq_irq_t;
  typedef uvm_component bcmp_t;
  typedef uvm_object obj_t;

  bcmp_t bseqr;
  obj_t bseq;

  seq_stl_t seq_stls[$];
  seq_irq_t seq_irq;

  rand int cnt;
  constraint c_cnt { cnt inside {[10:20]}; }

  int nodeid = 0;
  int edgeid = 0;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_interrupt_seq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

    for(int i=0; i<cnt; i++) begin
      `uvm_create_on(seq_stls[i], vseqr.ahb_magts[0].seqr)

      graph.nodes[nodeid] = '{
                    uuid: nodeid,
                    seq: seq_stls[i],
                    seqr: vseqr.ahb_magts[0].seqr,
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

    `uvm_create_on(seq_irq, vseqr.ahb_magts[0].seqr)
    graph.nodes[nodeid] = '{
                    uuid: nodeid,
                    seq: seq_irq,
                    seqr: vseqr.ahb_magts[0].seqr,
                    prio: -1,
                    desc: {$psprintf("bind Node[%0d] as %s", nodeid, "seq_irq")}
                };
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
        begin seq_stls[k].start(vseqr.ahb_magts[0].seqr, this, 0); end
      join_none
    end

    fork
      begin seq_irq.start(vseqr.ahb_magts[0].seqr, this, 0); end
    join_none

    #10;
  endtask : body

  virtual task post_body();
    super.post_body();
    wait(vseqr.ahb_magts[0].seqr.finish);
  endtask : post_body

endclass : ahb_master_interrupt_vseq


`endif // __AHB_MASTER_INTERRUPT_VSEQ_SV__
