
`ifndef __SMTDV_STL__
`define __SMTDV_STL__

/* util */
import "DPI-C" function longint dpi_hexstr_2_longint(string st);
import "DPI-C" function string dpi_longint_2_hexstr(longint i);

/* smtdv util calls */
import "DPI-C" function chandle dpi_smtdv_parse_file(string name);
import "DPI-C" function chandle dpi_smtdv_next_smtdv_transfer(chandle mb);

/* smtdv set function calls */
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_begin_cycle(chandle trx, string begin_cycle);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_end_cycle(chandle trx, string end_cycle);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_begin_time(chandle trx, string begin_time);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_end_time(chandle trx, string end_time);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_rw(chandle trx, string rw);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_addr(chandle trx, string addr);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_data(chandle trx, string data);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_byten(chandle trx, string byten);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_id(chandle trx, string id);
import "DPI-C" function string dpi_smtdv_set_smtdv_transfer_resp(chandle trx, string resp);

/* smtdv get function calls */
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_begin_cycle(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_end_cycle(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_begin_time(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_end_time(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_rw(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_addr(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_data(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_byten(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_id(chandle trx);
import "DPI-C" function string dpi_smtdv_get_smtdv_transfer_resp(chandle trx);

`endif // __SMTDV_STL__
