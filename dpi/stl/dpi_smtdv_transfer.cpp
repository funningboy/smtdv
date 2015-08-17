

#include "dpi_smtdv_transfer.h"
using namespace SMTDV;

void SMTDV_MailBox::push(SMTDV_Transfer* tt) {
  m_vec.push_back(tt);
  m_it = m_vec.begin();
}

bool SMTDV_MailBox::is_empty() {
  return m_vec.empty();
}

SMTDV_Transfer* SMTDV_MailBox::next() {
  SMTDV_Transfer* tt;
  if (m_it != m_vec.end()){
    tt = *m_it;
    m_it++;
    return tt;
  }
  return NULL;
}

int SMTDV_MailBox::size() {
  return m_vec.size();
}

