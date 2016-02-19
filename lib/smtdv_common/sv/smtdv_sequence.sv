`ifndef __SMTDV_SEQUENCE_SV__
`define __SMTDV_SEQUENCE_SV__

typedef class smtdv_seq_node;

/**
* smtdv_sequence
* wrapper smtdv_sequence item
*
* @class smtdv_sequence
*
*/
class smtdv_sequence#(
  type REQ = uvm_sequence_item,
  type RSP = REQ,
  type NODE = smtdv_seq_node#(uvm_object, uvm_component)
  ) extends
  uvm_sequence#(REQ, RSP);

  NODE node;
  string seq_name;

  `uvm_object_param_utils(smtdv_sequence#(REQ, RSP))

  function new(string name = "smtdv_sequence");
    super.new(name);
    seq_name = name;
  endfunction : new

  virtual function void set(NODE inode);
    if (!$cast(node, inode))
      `uvm_error("SMTDV_DCAST_SEQ_NODE",
        {$psprintf("DOWN CAST TO SEQ_NODE FAIL")})

  endfunction : set

  extern virtual task pre_body();
  extern virtual task body();
  extern virtual task post_body();

endclass : smtdv_sequence

/**
 *  do raise objection, keep sequence is alive
 */
task smtdv_sequence::pre_body();
  fork
    super.pre_body();
  join_none

  if (node==null)
    `uvm_warning("SMTDV_BASE_SEQ",
        $psprintf({"FIND NULL SEQ_NODE, PLEASE REGISTER SEQ_NODE FIRST IF NEEDED"}))

  if (node)
    node.pre_do();

  if(starting_phase != null) begin
    starting_phase.raise_objection(this, get_full_name());
    `uvm_info({get_full_name(), ".pre_body()"},
      {"raise objection in phase: ", starting_phase.get_name()},
      UVM_DEBUG)
    end
endtask : pre_body

/**
 *  do main task
 */
task smtdv_sequence::body();
  fork
    super.body();
  join_none

  $display ("----------------------------------------------------------");
  $display ($realtime , " Running sequence : [%s]  !", seq_name);
  $display ("----------------------------------------------------------");

  if (node)
    node.mid_do();

endtask : body

/**
 *  drop objection, close sequence
 */
task smtdv_sequence::post_body();
  fork
    super.post_body();
  join_none

  if (node)
    node.post_do();

  if(starting_phase != null) begin
    starting_phase.drop_objection(this, get_full_name());
    `uvm_info({get_full_name(), ".post_body()"},
      {"drop objection in phase: ", starting_phase.get_name()},
      UVM_DEBUG)
    end
endtask : post_body


`endif // end of __SMTDV_SEQUENCE_SV__
