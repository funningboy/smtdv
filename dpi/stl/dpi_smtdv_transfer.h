
#ifndef _SMTDV_TRANSFER_
#define _SMTDV_TRANSFER_

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

namespace SMTDV {
  /* Base transfer */
  class Base_Transfer {
    public:
      Base_Transfer(){}
      ~Base_Transfer(){}
  };
  /* SMTDV Transfer */
  class SMTDV_Transfer : public Base_Transfer{
    public :
      SMTDV_Transfer(){}
      ~SMTDV_Transfer(){}
    public :
      unsigned long int begin_cycle;
      unsigned long int end_cycle;
      unsigned long int begin_time;
      unsigned long int end_time;
      unsigned long int addr;
      std::vector<unsigned long int> data;
      std::vector<unsigned int> byten;
      unsigned int id;
      string resp;
      string rw;
      string bst_type;
      string trx_size;
      string trx_prt;
      unsigned int lock;
  };

  template <class T>
    class Base_MailBox {
      public:
        Base_MailBox(){}
        ~Base_MailBox(){}
      public:
        typedef typename std::vector<T*>::iterator m_it;
        virtual void push(T*) = 0;
        virtual bool is_empty() = 0;
        virtual T* next() = 0;
        virtual int size() = 0;
      private:
        std::vector<T*> m_vec;
    };

  /* SMTDV MailBox */
  class SMTDV_MailBox : public Base_MailBox<SMTDV_Transfer>{
    public:
      SMTDV_MailBox(std::string inst_name): inst_name(inst_name){}
      ~SMTDV_MailBox(){}
    public:
      typedef std::vector<SMTDV_Transfer*>::iterator iter_vec;
      iter_vec m_it;
      void push(SMTDV_Transfer*);
      bool is_empty();
      SMTDV_Transfer* next();
      int size();
    private:
      std::vector<SMTDV_Transfer*> m_vec;
      std::string inst_name;
  };
}

#endif
