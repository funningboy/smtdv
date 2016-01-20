
import smtdv_stl_pkg::*;

module test();

task test_xbus_stl();
  chandle m_dpi_mb;
  chandle m_dpi_trx;

  m_dpi_mb = dpi_smtdv_parse_file("xbus.stl");
  assert(m_dpi_mb!=null);

  for (int i=0; i<2; i++) begin
    m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
    assert(m_dpi_trx!=null);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_begin_cycle(m_dpi_trx)) == 2);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_end_cycle(m_dpi_trx)) == 4);
    assert(dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w");
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx)) == 32'h10000000);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 0)) == 32'hffffffff);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_byten(m_dpi_trx, 0)) == 4'h1);
  end
endtask

task test_apb_stl();
  chandle m_dpi_mb;
  chandle m_dpi_trx;

  m_dpi_mb = dpi_smtdv_parse_file("apb.stl");
  assert(m_dpi_mb!=null);

  for (int i=0; i<2; i++) begin
    m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
    assert(m_dpi_trx!=null);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_begin_cycle(m_dpi_trx)) == 2);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_end_cycle(m_dpi_trx)) == 4);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_id(m_dpi_trx)) == 0);
    assert(dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w");
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx)) == 32'h10000000);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 0)) == 32'hffffffff);
  end
endtask

task test_ahb_stl();
  chandle m_dpi_mb;
  chandle m_dpi_trx;

  m_dpi_mb = dpi_smtdv_parse_file("ahb.stl");
  assert(m_dpi_mb!=null);

  for (int i=0; i<2; i++) begin
    m_dpi_trx = dpi_smtdv_next_smtdv_transfer(m_dpi_mb);
    assert(m_dpi_trx!=null);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_begin_cycle(m_dpi_trx)) == 2);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_end_cycle(m_dpi_trx)) == 4);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_id(m_dpi_trx)) == 0);
    assert(dpi_smtdv_get_smtdv_transfer_rw(m_dpi_trx) == "w");
    assert(dpi_smtdv_get_smtdv_transfer_bst_type(m_dpi_trx) == "INCR4");
    assert(dpi_smtdv_get_smtdv_transfer_trx_size(m_dpi_trx) == "B32");
    assert(dpi_smtdv_get_smtdv_transfer_trx_prt(m_dpi_trx) == "USER_ACCESS");
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_addr(m_dpi_trx)) == 32'h10000000);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 0)) == 32'h11111111);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 1)) == 32'h22222222);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 2)) == 32'h33333333);
    assert(dpi_hexstr_2_longint(dpi_smtdv_get_smtdv_transfer_data(m_dpi_trx, 3)) == 32'h44444444);
  end
endtask



initial begin
  test_xbus_stl();    $display("test xbus pass");
  test_apb_stl();     $display("test apb pass");
  test_ahb_stl();     $display("test ahb pass");
end

endmodule
