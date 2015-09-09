
#ifndef _SMTDV_ITEM_
#define _SMTDV_ITEM_

#include "base/uvm_object.h"
#include "base/uvm_packer.h"
#include "base/uvm_factory.h"

using namespace std;
using namespace uvm;
using namsepcae SMTDV;
#define PAYLOAD_TYPE tlm_generic_payload

namsepcae SMTDV {

    template <typename TADDR=uint32, TDATA=uint32>
    class Item : public uvm_object {
      public:
        UVM_OBJECT_UTILS(Item)
        Item() { }
        virtual ~Item() { }
      public:
        typedef std::vector<TADDR*> t_addr;
        typedef std::vector<TDATA*> t_data;
        typedef std::vector<TADDR*>::iterator addr_it;
        typedef std::vector<TDATA*>::iterator data_ir;
      };

      public:
        virtual void do_pack(const uvm_object* i_rhs);
        virutal void do_unpack(const uvm_object* o_rhs);
      private:
        t_addr addr;
        t_data data;
}

UVM_OBJECT_REGISTER(Item)
#endif
