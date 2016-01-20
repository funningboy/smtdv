
#include "dpi_smtdv_table.h"

using namespace SMTDV;

/* register field */
void SMTDV_Table::iregister(int i_typ, std::string i_fd_nm){
  SMTDV_Data *dt = new SMTDV_Data(i_typ, "", "");
  m_record[i_fd_nm] = std::make_pair(SMTDV_Table::T_NONE, dt);
}

/* is string typ */
bool SMTDV_Table::is_string(std::string i_fd_nm) {
  if (m_record.find(i_fd_nm)!=m_record.end()) {
      return m_record[i_fd_nm].second->typ == SMTDV_Data::T_STRING;
  } else {
    std::cout << "[Warning] table: " << m_tb_nm << " not found the field: " << i_fd_nm  << std::endl;
  }
  return false;
}

/* is longint typ */
bool SMTDV_Table::is_longint(std::string i_fd_nm) {
  if (m_record.find(i_fd_nm)!=m_record.end()) {
      return m_record[i_fd_nm].second->typ == SMTDV_Data::T_LONGINT;
  } else {
    std::cout << "[Warning] table: " << m_tb_nm << " not found the field: " << i_fd_nm  << std::endl;
  }
  return false;
}

/* is longlong typ */
bool SMTDV_Table::is_longlong(std::string i_fd_nm) {
  if (m_record.find(i_fd_nm)!=m_record.end()) {
      return m_record[i_fd_nm].second->typ == SMTDV_Data::T_LONGLONG;
  } else {
    std::cout << "[Warning] table: " << m_tb_nm << " not found the field: " << i_fd_nm  << std::endl;
  }
  return false;
}

/* insert value to field */
void SMTDV_Table::insert(std::string i_fd_nm, std::string i_val) {
  if (m_record.find(i_fd_nm)!=m_record.end()) {
    m_record[i_fd_nm].first       = SMTDV_Table::T_WRITE;
    m_record[i_fd_nm].second->val = i_val;
  } else {
    std::cout << "[Warning] table: " << m_tb_nm << " not found the field: " << i_fd_nm  << std::endl;
  }
}

/* get field and value */
std::string SMTDV_Table::get(std::string i_fd_nm) {
   if (m_record.find(i_fd_nm)!=m_record.end()) {
     m_record[i_fd_nm].first = SMTDV_Table::T_READ;
  } else {
    std::cout << "[Warning] table: " << m_tb_nm << " not found the field: " << i_fd_nm  << std::endl;
  }
}

/*dump */
void SMTDV_Table::dump() {
  for (tp_it it = m_record.begin(); it!=m_record.end(); it++){
    it->first;
    it->second;
  }
}

/* flush field update status */
void SMTDV_Table::flush() {
  for (tp_it it = m_record.begin(); it!=m_record.end(); it++){
    it->second.first = SMTDV_Table::T_NONE;
    it->second.second->val = "";
  }
}

/* return header stmt */
std::string SMTDV_Table::return_table_items() {
  std::stringstream out;
  tp_it ed_it = m_record.end();
  --ed_it;
  for (tp_it it = m_record.begin(); it != m_record.end(); it++) {
    out << it->first << ((it->second.second->typ==SMTDV_Data::T_STRING)?   " TEXT"    :
                         (it->second.second->typ==SMTDV_Data::T_LONGINT)?  " INTEGER" :
                         (it->second.second->typ==SMTDV_Data::T_LONGLONG)? " INTEGER" : " NULL") <<
    ((it==ed_it)? "": ",") ;
  }
  return out.str();
}

/* return body stmt */
std::string SMTDV_Table::return_body_items() {
  std::stringstream out;
  tp_it ed_it = m_record.end();
  --ed_it;
   for (tp_it it = m_record.begin(); it != m_record.end(); it++) {
        out << it->first << ((it==ed_it)? "": "," );
  }
  return out.str();
}

/*return body values */
std::string SMTDV_Table::return_body_values() {
  std::stringstream out;
  tp_it ed_it = m_record.end();
  --ed_it;
   for (tp_it it = m_record.begin(); it != m_record.end(); it++) {
       if (it->second.second->typ==SMTDV_Data::T_LONGINT ||
           it->second.second->typ==SMTDV_Data::T_LONGLONG)
            out << str_2_longint(it->second.second->val);
            //out << hexstr_2_longint(it->second.second->val);
       else
            out << "'" << it->second.second->val << "'";

       out << ((it==ed_it)? "": "," );
  }
  return out.str();
}

/* exec to sqlite3 create table command */
std::string SMTDV_Table::exec_field() {
  std::stringstream out;
  out << "CREATE TABLE " << m_tb_nm << " (" << return_table_items() << " );";
  return out.str();
}

/* exec to sqlite3 insert data to table command */
std::string SMTDV_Table::exec_value() {
  std::stringstream out;
  out << "INSERT INTO " << m_tb_nm << " (" << return_body_items() << " )" << "VALUES" << " (" << return_body_values() << " );";
  return out.str();
}

///* clear */
//oid SMTDV_Table::clear() {
//
//}

