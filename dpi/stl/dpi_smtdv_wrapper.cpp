
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
  void* dpi_smtdv_new_smtdv_mailbox(char* inst_name) {
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
  /* set id */
  void dpi_smtdv_set_smtdv_transfer_id(void* ip, char* id) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer id fail");
    tt->id = dpi_hexstr_2_longint(id);
  }
  /* get id */
  char* dpi_smtdv_get_smtdv_transfer_id(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer id fail");
    return dpi_longint_2_hexstr(tt->id);
  }
  /* set resp */
  void dpi_smtdv_set_smtdv_transfer_resp(void* ip, char* resp) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer resp fail");
    tt->resp = resp;
  }
  /* get resp */
  char* dpi_smtdv_get_smtdv_transfer_resp(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer resp fail");
    char *cstr = new char[tt->resp.length() + 1];
    strcpy(cstr, tt->resp.c_str());
    return cstr;
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
  /* set bst_type */
  void dpi_smtdv_set_smtdv_transfer_bst_type(void* ip, char* bst_type) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer bst_type fail");
    tt->bst_type = bst_type;
  }
  /* get bst_type */
  char* dpi_smtdv_get_smtdv_transfer_bst_type(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer bst_type fail");
    char *cstr = new char[tt->bst_type.length() + 1];
    strcpy(cstr, tt->bst_type.c_str());
    return cstr;
  }
  /* set trx_size */
  void dpi_smtdv_set_smtdv_transfer_trx_size(void* ip, char* trx_size) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer trx_size fail");
    tt->trx_size = trx_size;
  }
  /* get trx_size */
  char* dpi_smtdv_get_smtdv_transfer_trx_size(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer trx_size fail");
    char *cstr = new char[tt->trx_size.length() + 1];
    strcpy(cstr, tt->trx_size.c_str());
    return cstr;
  }
  /* set trx_prt */
  void dpi_smtdv_set_smtdv_transfer_trx_prt(void* ip, char* trx_prt) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer trx_prt fail");
    tt->trx_prt = trx_prt;
  }
  /* get trx_prt */
  char* dpi_smtdv_get_smtdv_transfer_trx_prt(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer trx_prt fail");
    char *cstr = new char[tt->trx_prt.length() + 1];
    strcpy(cstr, tt->trx_prt.c_str());
    return cstr;
  }
  /* set lock */
  void dpi_smtdv_set_smtdv_transfer_lock(void* ip, char* lock) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer lock fail");
    tt->id = dpi_hexstr_2_longint(lock);
  }
  /* get lock */
  char* dpi_smtdv_get_smtdv_transfer_lock(void* ip) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer lock fail");
    return dpi_longint_2_hexstr(tt->lock);
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
    tt->data.push_back(dpi_hexstr_2_longint(data));
  }
  /* get data */
  char* dpi_smtdv_get_smtdv_transfer_data(void* ip, int i) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer data fail");
    int size = tt->data.size();
    assert(size > 0 && i < size && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer data fail");
    return dpi_longint_2_hexstr(tt->data[i]);
  }
  /* set byten */
  void dpi_smtdv_set_smtdv_transfer_byten(void* ip, char* data) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, set_SMTDV_Transfer byten fail");
    tt->byten.push_back(dpi_hexstr_2_longint(data));
  }
  /* get byten */
  char* dpi_smtdv_get_smtdv_transfer_byten(void* ip, int i) {
    SMTDV_Transfer* tt = reinterpret_cast<SMTDV_Transfer*>(ip);
    assert(tt!=NULL && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer byten fail");
    int size = tt->byten.size();
    assert(size > 0 && i < size && "UVM_ERROR DPI_SMTDV, get_SMTDV_Transfer byten fail");
    return dpi_longint_2_hexstr(tt->byten[i]);
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

