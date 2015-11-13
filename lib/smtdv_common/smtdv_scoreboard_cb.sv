
`ifndef __SMTDV_SCOREBOARD_CB_SV__
`define __SMTDV_SCOREBOARD_CB_SV__

class smtdv_scoreboard_cb
  extends
    uvm_object;
    /*
    string table_nm, query;
    smtdv_sequence_item ini_items[];
    smtdv_sequence_item tgt_items[];
    smtdv_sequence_item aitem;
    $cast(aitem, item);
    table_nm = {$psprintf("\"%s\"",  initor.mon.get_full_name())};
    query = smtdv_bus_backdoor::gen_query_cmd(table_nm, "LAST_TRX", aitem);
    smtdv_bus_backdoor::convert_2_item(table_nm, query, ini_items);

    slave_id = agent.cfg.find_slave(aitem.addr);
    table_nm = {$psprintf("\"%s\"", target.mon.get_full_name())};
    query = smtdv_bus_backdoor::gen_query_cmd(table_nm, "LAST_TRX", aitem);
    smtdv_bus_backdoor::convert_2_item(table_nm, query, tgt_items);

    if (ini_items.size() == 1)
      init_items[0].compare(tgt_items[0]);
*/
endclass

`endif // __SMTDV_SCOREBOARD_CB_SV__
