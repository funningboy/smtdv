
`ifndef __SMTDV_STL__
`define __SMTDV_STL__

/* util */
import "DPI" function longint dpi_hexstr_2_longint(string st);
import "DPI" function string dpi_longint_2_hexstr(longint i);

/* smtdv util calls */
import "DPI" function chandle dpi_smtdv_parse_file(string name);
import "DPI" function chandle dpi_smtdv_next_smtdv_transfer(chandle mb);

/* smtdv set function calls */
import "DPI" function string dpi_smtdv_set_smtdv_transfer_begin_cycle(chandle trx, string begin_cycle);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_end_cycle(chandle trx, string end_cycle);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_begin_time(chandle trx, string begin_time);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_end_time(chandle trx, string end_time);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_rw(chandle trx, string rw);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_addr(chandle trx, string addr);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_data(chandle trx, string data);
import "DPI" function string dpi_smtdv_set_smtdv_transfer_byten(chandle trx, string byten);


/* smtdv get function calls */
import "DPI" function string dpi_smtdv_get_smtdv_transfer_begin_cycle(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_end_cycle(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_begin_time(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_end_time(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_rw(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_addr(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_data(chandle trx);
import "DPI" function string dpi_smtdv_get_smtdv_transfer_byten(chandle trx);

`endif // __SMTDV_STL__
