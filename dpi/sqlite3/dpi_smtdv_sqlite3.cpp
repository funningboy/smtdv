
#include "dpi_smtdv_sqlite3.h"

using namespace std;
using namespace SMTDV;

std::string m_tb_nm;
sqlite3 *SMTDV_Sqlite3::m_db;

void SMTDV_Sqlite3::create_db(std::string i_db_nm) {
  int rc = sqlite3_open(i_db_nm.c_str(), &m_db);
  if (rc) { std::cout << "[Error] can't open database: " << sqlite3_errmsg(m_db) << std::endl; exit(-1); }
  else    { std::cout << "opened database " <<  i_db_nm << " successfully" << std::endl; }
}

void SMTDV_Sqlite3::delete_db(std::string i_db_nm) {
  if (std::remove(i_db_nm.c_str()) != 0)
    std::cout << "[Warning] delete " << i_db_nm <<  " fail" << std::endl;
}

void SMTDV_Sqlite3::close_db() {
  sqlite3_close(m_db);
}

void SMTDV_Sqlite3::create_tb(std::string i_tb_nm) {
  get_tb()[i_tb_nm] = new SMTDV_Table(i_tb_nm);
}

void SMTDV_Sqlite3::delete_tb(std::string i_tb_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      SMTDV_Table* tb = (SMTDV_Table*) get_tb()[i_tb_nm];
      delete tb;
      get_tb().erase(i_tb_nm);
  }
}

void SMTDV_Sqlite3::create_pl(std::string i_tb_nm) {
  get_pl()[i_tb_nm] = new SMTDV_Pool(i_tb_nm);
}

void SMTDV_Sqlite3::delete_pl(std::string i_tb_nm) {
  if (get_pl().find(i_tb_nm)!=get_pl().end()) {
      SMTDV_Pool* pl = (SMTDV_Pool*) get_pl()[i_tb_nm];
      pl->clear();
      delete pl;
      get_pl().erase(i_tb_nm);
  }
}

void SMTDV_Sqlite3::register_string_field(std::string i_tb_nm, std::string i_fd_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      get_tb()[i_tb_nm]->iregister(SMTDV_Data::T_STRING, i_fd_nm);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
}

bool SMTDV_Sqlite3::is_string_field(std::string i_tb_nm, std::string i_fd_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      return get_tb()[i_tb_nm]->is_string(i_fd_nm);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
  return false;
}

void SMTDV_Sqlite3::register_longint_field(std::string i_tb_nm, std::string i_fd_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      get_tb()[i_tb_nm]->iregister(SMTDV_Data::T_LONGINT, i_fd_nm);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
}

bool SMTDV_Sqlite3::is_longint_field(std::string i_tb_nm, std::string i_fd_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      return get_tb()[i_tb_nm]->is_longint(i_fd_nm);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
  return false;
}

void SMTDV_Sqlite3::register_longlong_field(std::string i_tb_nm, std::string i_fd_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      get_tb()[i_tb_nm]->iregister(SMTDV_Data::T_LONGLONG, i_fd_nm);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
}

bool SMTDV_Sqlite3::is_longlong_field(std::string i_tb_nm, std::string i_fd_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
      return get_tb()[i_tb_nm]->is_longlong(i_fd_nm);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
  return false;
}

void SMTDV_Sqlite3::exec_field(std::string i_tb_nm) {
  char* error;
  std::string query;
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
    query = get_tb()[i_tb_nm]->exec_field();
    if (SMTDV_SQLITE3_DEBUG) std::cout << query << std::endl;
    int rc = sqlite3_exec(m_db, query.c_str(), NULL, 0, &error);
    if (rc!=SQLITE_OK) { std::cout << "[Error] sqlite3 error " << error << std::endl; exit(-1); }
  } else {
      std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
    }
}

void SMTDV_Sqlite3::insert_value(std::string i_tb_nm, std::string i_fd_nm, std::string i_val) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
    get_tb()[i_tb_nm]->insert(i_fd_nm, i_val);
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
}

void SMTDV_Sqlite3::exec_value(std::string i_tb_nm) {
  char* error;
  std::string query;
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
    query = get_tb()[i_tb_nm]->exec_value();
    if (SMTDV_SQLITE3_DEBUG) std::cout << query << std::endl;
    int rc = sqlite3_exec(m_db, query.c_str(), NULL, 0, &error);
    if (rc!=SQLITE_OK) { std::cout << "[Error] sqlite3 error " << error << std::endl; exit(-1); }
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
}

void SMTDV_Sqlite3::flush_value(std::string i_tb_nm) {
  if (get_tb().find(i_tb_nm)!=get_tb().end()) {
    get_tb()[i_tb_nm]->flush();
  } else {
    std::cout << "[Warning] table: " << i_tb_nm << " not found" << std::endl;
  }
}

SMTDV_Data::type SMTDV_Sqlite3::get_field_typ(std::string i_tb_nm, std::string i_fd_nm) {
     return is_string_field(i_tb_nm, i_fd_nm)?    SMTDV_Data::T_STRING     :
            is_longint_field(i_tb_nm, i_fd_nm)?   SMTDV_Data::T_LONGINT    :
            is_longlong_field(i_tb_nm, i_fd_nm)?  SMTDV_Data::T_LONGLONG   : SMTDV_Data::T_STRING;
}

int SMTDV_Sqlite3::exec_callback(void *data, int argc, char **argv, char **col_nm){
  SMTDV_Row* row = new SMTDV_Row();
  std::stringstream ss_nm, ss_val;
  std::string nm, val;

  for(int i=0; i<argc; i++){
    ss_nm  << col_nm[i]; ss_nm >> nm;
    ss_val << argv[i];   ss_val >> val;
    SMTDV_Column* dt = new SMTDV_Column(get_field_typ(m_tb_nm, nm), val);
    if (SMTDV_SQLITE3_DEBUG) std::cout << nm << '=' << val << std::endl;
    row->set(dt);
  }
  get_pl()[m_tb_nm]->set(row);
  return 0;
}

SMTDV_Pool* SMTDV_Sqlite3::exec_query(std::string i_tb_nm, std::string i_query) {
  char* error;
  m_tb_nm = i_tb_nm;
  if (SMTDV_SQLITE3_DEBUG) std::cout << i_query << std::endl;
  int rc = sqlite3_exec(m_db, i_query.c_str(), exec_callback, 0, &error);
  if (rc!=SQLITE_OK) { std::cout << "[Error] sqlite3 error " << error << std::endl; exit(-1); }
  if (SMTDV_SQLITE3_DEBUG) get_pl()[i_tb_nm]->dump();
  return get_pl()[i_tb_nm];
}

int SMTDV_Sqlite3::exec_row_size(SMTDV_Pool* i_pl) {
    return i_pl->get().size();
}

SMTDV_Row* SMTDV_Sqlite3::exec_row_step(SMTDV_Pool* i_pl, int i_indx) {
    return i_pl->get(i_indx);
}

int SMTDV_Sqlite3::exec_column_size(SMTDV_Row* i_row) {
    return i_row->get().size();
}

SMTDV_Column* SMTDV_Sqlite3::exec_column_step(SMTDV_Row* i_row, int i_indx) {
    return i_row->get(i_indx);
}


