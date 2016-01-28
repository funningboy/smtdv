`ifndef __SMTDV_SEQUENCE_SV__
`define __SMTDV_SEQUENCE_SV__

/**
* smtdv_sequence
* wrapper smtdv_sequence item
*
* @class smtdv_sequence
*
*/
class smtdv_sequence#(
    type REQ = uvm_sequence_item,
    type RSP = REQ)
  extends
    uvm_sequence#(REQ, RSP);

  string seq_name;

  `uvm_object_param_utils(smtdv_sequence#(REQ, RSP))

  function new(string name = "smtdv_sequence");
    super.new(name);
    seq_name = name;
  endfunction : new

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

endtask : body

/**
 *  drop objection, close sequence
 */
task smtdv_sequence::post_body();
  fork
    super.post_body();
  join_none

  if(starting_phase != null) begin
    starting_phase.drop_objection(this, get_full_name());
    `uvm_info({get_full_name(), ".post_body()"},
      {"drop objection in phase: ", starting_phase.get_name()},
      UVM_DEBUG)
    end
endtask : post_body


`endif // end of __SMTDV_SEQUENCE_SV__
