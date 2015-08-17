
#include "dpi_smtdv_wrapper.h"

/* shared lib build up */
#ifdef __cplusplus
extern "C" {

  /* char str to long int */
  long int dpi_hexstr_2_longint(char* st) {
    std::stringstream ss;
    unsigned long x;
    ss << std::hex << st;
    ss >> x;
    return x;
  }
  /* longint 2 str */
  char* dpi_longint_2_hexstr(long int i){
    std::stringstream ss;
    string x;
    ss << std::hex << i;
    ss >> x;
    return const_cast<char*>(x.c_str());
  }
  /* new SMTDV_Transfer */
  void* dpi_smtdv_new_smtdv_transfer() {
    SMTDV_Transfer* tt = new SMTDV_Transfer();
    assert(tt!=NULL && "UVM_ERROR: DPI_SMTDV, new SMTDV_Transfer fail");
    return reinterpret_cast<void*>(tt);
  }
  /* new SMTDV_MailBox */
  void* dpi_smtdv_new_smtdv_masmtdvox(char* inst_name) {
    SMTDV_MailBox* ft = new SMTDV_MailBox(inst_name);
    assert(ft!=NULL && "UVM_ERROR: DPI_SMTDV, new SMTDV_MailBox fail");
    return reinterpret_cast<void*>(ft);
  }
  /* set begin time */
  void dpi_smtdv_set_smtdv_transfer_begin_time(void* ip, char* begin_time) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR: DPI_SMTDV, set SMTDV_Transfer begin_time fail");
    tt->begin_time = dpi_hexstr_2_longint(begin_time);
  }
  /* get begin time */
  char* dpi_smtdv_get_smtdv_transfer_begin_time(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR: DPI_SMTDV, get SMTDV_Transfer begin_time fail");
    return dpi_longint_2_hexstr(tt->begin_time);
  }
  /* set end time */
  void dpi_smtdv_set_smtdv_transfer_end_time(void* ip, char* end_time) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR: DPI_SMTDV, set SMTDV_Transfer end_time fail");
    tt->end_time = dpi_hexstr_2_longint(end_time);
  }
  /* get end time */
  char* dpi_smtdv_get_smtdv_transfer_end_time(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERRORL DPI_SMTDV, get_SMTDV_Transfer end time fail");
    return dpi_longint_2_hexstr(tt->end_time);
  }
  /* set begin_cycle */
  void dpi_smtdv_set_smtdv_transfer_begin_cycle(void* ip, char* begin_cycle) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer begin cycle fail");
    tt->begin_cycle = dpi_hexstr_2_longint(begin_cycle);
  }
  /* get begin cycle */
  char* dpi_smtdv_get_smtdv_transfer_begin_cycle(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer begin cycle fail");
    return dpi_longint_2_hexstr(tt->begin_cycle);
  }
  /* set end_cycle */
  void dpi_smtdv_set_smtdv_transfer_end_cycle(void* ip, char* end_cycle) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer end cycle fail");
    tt->end_cycle = dpi_hexstr_2_longint(end_cycle);
  }
  /* get end cycle */
  char* dpi_smtdv_get_smtdv_transfer_end_cycle(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer end cycle fail");
    return dpi_longint_2_hexstr(tt->end_cycle);
  }
  /* set rw */
  void dpi_smtdv_set_smtdv_transfer_rw(void* ip, char* rw) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer rw fail");
    tt->rw = rw;
  }
  /* get rw */
  char* dpi_smtdv_get_smtdv_transfer_rw(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer rw fail");
    char *cstr = new char[tt->rw.length() + 1];
    strcpy(cstr, tt->rw.c_str());
    return cstr;
  }
  /* set addr */
  void dpi_smtdv_set_smtdv_transfer_addr(void* ip, char* addr) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer addr fail");
    tt->addr = dpi_hexstr_2_longint(addr);
  }
  /* get addr */
  char* dpi_smtdv_get_smtdv_transfer_addr(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer addr fail");
    return dpi_longint_2_hexstr(tt->addr);
  }
  /* set data */
  void dpi_smtdv_set_smtdv_transfer_data(void* ip, char* data) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer data fail");
    tt->data = dpi_hexstr_2_longint(data);
  }
  /* get data */
  char* dpi_smtdv_get_smtdv_transfer_data(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer data fail");
    return dpi_longint_2_hexstr(tt->data);
  }
  /* set byten */
  void dpi_smtdv_set_smtdv_transfer_byten(void* ip, char* data) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer byten fail");
    tt->byten = dpi_hexstr_2_longint(data);
  }
  /* get byten */
  char* dpi_smtdv_get_smtdv_transfer_byten(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer byten fail");
    return dpi_longint_2_hexstr(tt->byten);
  }
  /* dpi register smtdv transfer 2 smtdv masmtdvox */
  void dpi_smtdv_register_smtdv_transfer(void* it, void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    SMTDV_MailBox* ft = reinterpret_cast<SMTDV_MailBox*>(it);
    assert(tt!=NULL && ft!=NULL && "UVM_ERROR: DPI_SMTDV, register SMTDV_Transfer is fail");
    ft->push(tt);
  }
  /* dpi get smtdv_transfer if the masmtdvox queue is not empty */
  void* dpi_smtdv_next_smtdv_transfer(void* it) {
    SMTDV_MailBox* ft = reinterpret_cast<SMTDV_MailBox*>(it);
    assert(ft!=NULL && "UVM_ERROR: DPI_SMTDV, next SMTDV_Transfer is fial");
    SMTDV_Transfer* tt = ft->next();
    return reinterpret_cast<void*>(tt);
  }

}
#endif

