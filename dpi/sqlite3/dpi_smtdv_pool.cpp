
#include "dpi_smtdv_pool.h"
using namespace SMTDV;

void SMTDV_Row::clear() {
  for(int i=0; i<m_col.size(); i++) {
    delete m_col[i];
  }
  m_col.clear();
}

void SMTDV_Row::set(SMTDV_Column* i_col) {
  m_col.push_back(i_col);
}

SMTDV_Column* SMTDV_Row::get(int i_indx) {
  return (m_col.size() > i_indx && i_indx >=0)? m_col[i_indx]: NULL;
}

SMTDV_Row::tp_col SMTDV_Row::get() {
  return m_col;
}

void SMTDV_Row::dump() {
  for (tp_col_it it = m_col.begin(); it != m_col.end(); it++) {
    std::cout << (*it)->val << std::endl;
  }
}

void SMTDV_Pool::clear() {
  for(int i=0; i<m_row.size(); i++) {
    m_row[i]->clear();
    delete m_row[i];
  }
}

void SMTDV_Pool::set(SMTDV_Row* i_row) {
  m_row.push_back(i_row);
}

SMTDV_Row* SMTDV_Pool::get(int i_indx) {
  return (m_row.size() > i_indx && i_indx >=0)? m_row[i_indx]: NULL;
}

SMTDV_Pool::tp_row SMTDV_Pool::get() {
  return m_row;
}

void SMTDV_Pool::dump() {
  for(SMTDV_Pool::tp_row_it it = m_row.begin(); it != m_row.end(); it++) {
    (*it)->dump();
  }
}
