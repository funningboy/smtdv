
#include "smtdv_item.h"
using namespace SMTDV;

void SMTDV::do_pack(const uvm_object* i_rhs) {
  const Item* rhs = DCAST<const Item*>(i_rhs);
  assert(rhs!=NULL && "ERROR: smtdv::do_pack fail");
  for(int i=0; i < rhs->data.size(); i++) {
      try {
          data.at(i) = rhs->data[i];
      }
      catch (const std::out_of_range& oor) {
          data.resize(i+1);
          data[i] = ths->data[i];
      }
  }
}

void SMTDV::do_unpack(const uvm_object* o_rhs) {
  const Item* rhs = DCAST<const Item*>(o_rhs);
  assert(rhs!=NULL && "ERROR: smtdv::do_unpack fail");
  for(int i=0; i < data.size(); i++) {
    rhs->data[i] = data[i];
  }
}
