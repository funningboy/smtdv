

%{
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <stdlib.h>
#include "dpi_smtdv_wrapper.h"

using namespace std;
using namespace SMTDV;

void* global_ft; /* smtdv_factory ppt */
void* global_mb; /* smtdv_masmtdvox ppt */
void* global_trx; /* smtdv_trx */

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
%}

%{
// function call
void yyerror(const char *s);
char* str2char(std::string str);
%}

%union {
std::string *smtdv_string;
   unsigned long smtdv_long;
int token;
}
%token <token> RETURN
%token <token> BEGIN_CYCLE
%token <token> END_CYCLE
%token <token> BEGIN_TIME
%token <token> END_TIME
%token <token> ID
%token <token> BST_TYPE
%token <token> TRX_SIZE
%token <token> TRX_PRT
%token <token> LOCK
%token <token> RESP
%token <token> RW
%token <token> ADDR
%token <token> DATA
%token <token> BYTEN
%token <token> TLPAREN
%token <token> TRPAREN
%token <token> TCOMMA
%token <token> COMMENT
%token <smtdv_string> TIDENTIFIER
%token <smtdv_string> SIDENTIFIER

%start program
%%
// root
program : top_stmt
        ;

// for sub stmts
top_stmt : instance_stmt RETURN
         | top_stmt header_stmt RETURN
         | top_stmt body_stmt RETURN
         | top_stmt RETURN
         ;

// header
header_stmt : header_ahb
            | header_apb
            | header_xbus
            ;

// xbus trx header
header_xbus : COMMENT
            BEGIN_CYCLE TCOMMA
            END_CYCLE TCOMMA
            BEGIN_TIME TCOMMA
            END_TIME TCOMMA
            RW TCOMMA
            ADDR TCOMMA
            DATA TLPAREN BYTEN TRPAREN TCOMMA
            ;

// apb trx header
header_apb : COMMENT
           BEGIN_CYCLE TCOMMA
           END_CYCLE TCOMMA
           BEGIN_TIME TCOMMA
           END_TIME TCOMMA
           ID TCOMMA
           RW TCOMMA
           RESP TCOMMA
           ADDR TCOMMA
           DATA TCOMMA
           ;

// ahb trx header
header_ahb : COMMENT
          BEGIN_CYCLE TCOMMA
          END_CYCLE TCOMMA
          BEGIN_TIME TCOMMA
          END_TIME TCOMMA
          ID TCOMMA
          RW TCOMMA
          BST_TYPE TCOMMA
          TRX_SIZE TCOMMA
          TRX_PRT TCOMMA
          LOCK TCOMMA
          RESP TCOMMA
          ADDR TCOMMA
          DATA TCOMMA
          ;

instance_stmt : COMMENT SIDENTIFIER
              { global_mb = dpi_smtdv_new_smtdv_mailbox(str2char((*$<smtdv_string>2))); }
;
// body contains, register trx to smtdv mailbox
body_stmt : { global_trx = dpi_smtdv_new_smtdv_transfer();
              dpi_smtdv_register_smtdv_transfer(global_mb, global_trx); } sub_body_stmt;

//sub body, update trx
sub_body_stmt : body_ahb
              | body_apb
              | body_xbus
              ;

data_has_byten : TIDENTIFIER TLPAREN TIDENTIFIER TRPAREN TCOMMA
{
dpi_smtdv_set_smtdv_transfer_data(global_trx, str2char((*$<smtdv_string>1)));
dpi_smtdv_set_smtdv_transfer_byten(global_trx, str2char((*$<smtdv_string>3)));
}
               | data_has_byten TIDENTIFIER TLPAREN TIDENTIFIER TRPAREN TCOMMA
{
dpi_smtdv_set_smtdv_transfer_data(global_trx, str2char((*$<smtdv_string>2)));
dpi_smtdv_set_smtdv_transfer_byten(global_trx, str2char((*$<smtdv_string>4)));
}
               ;

data_no_byten : TIDENTIFIER TCOMMA
{
dpi_smtdv_set_smtdv_transfer_data(global_trx, str2char((*$<smtdv_string>1)));
}
              | data_no_byten TIDENTIFIER TCOMMA
{
dpi_smtdv_set_smtdv_transfer_data(global_trx, str2char((*$<smtdv_string>2)));
}
              ;

body_xbus:
         TIDENTIFIER TCOMMA
         TIDENTIFIER TCOMMA
         TIDENTIFIER TCOMMA
         TIDENTIFIER TCOMMA
         SIDENTIFIER TCOMMA
         TIDENTIFIER TCOMMA
         data_has_byten {
dpi_smtdv_set_smtdv_transfer_begin_cycle(global_trx, str2char((*$<smtdv_string>1)));
dpi_smtdv_set_smtdv_transfer_end_cycle(global_trx, str2char((*$<smtdv_string>3)));
dpi_smtdv_set_smtdv_transfer_begin_time(global_trx, str2char((*$<smtdv_string>5)));
dpi_smtdv_set_smtdv_transfer_end_time(global_trx, str2char((*$<smtdv_string>7)));
dpi_smtdv_set_smtdv_transfer_rw(global_trx, str2char((*$<smtdv_string>9)));
dpi_smtdv_set_smtdv_transfer_addr(global_trx, str2char((*$<smtdv_string>11)));
};

body_apb:
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        data_no_byten {
dpi_smtdv_set_smtdv_transfer_begin_cycle(global_trx, str2char((*$<smtdv_string>1)));
dpi_smtdv_set_smtdv_transfer_end_cycle(global_trx, str2char((*$<smtdv_string>3)));
dpi_smtdv_set_smtdv_transfer_begin_time(global_trx, str2char((*$<smtdv_string>5)));
dpi_smtdv_set_smtdv_transfer_end_time(global_trx, str2char((*$<smtdv_string>7)));
dpi_smtdv_set_smtdv_transfer_id(global_trx, str2char((*$<smtdv_string>9)));
dpi_smtdv_set_smtdv_transfer_rw(global_trx, str2char((*$<smtdv_string>11)));
dpi_smtdv_set_smtdv_transfer_resp(global_trx, str2char((*$<smtdv_string>13)));
dpi_smtdv_set_smtdv_transfer_addr(global_trx, str2char((*$<smtdv_string>15)));
};


body_ahb:
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        SIDENTIFIER TCOMMA
        TIDENTIFIER TCOMMA
        data_no_byten
 {
dpi_smtdv_set_smtdv_transfer_begin_cycle(global_trx, str2char((*$<smtdv_string>1)));
dpi_smtdv_set_smtdv_transfer_end_cycle(global_trx, str2char((*$<smtdv_string>3)));
dpi_smtdv_set_smtdv_transfer_begin_time(global_trx, str2char((*$<smtdv_string>5)));
dpi_smtdv_set_smtdv_transfer_end_time(global_trx, str2char((*$<smtdv_string>7)));
dpi_smtdv_set_smtdv_transfer_id(global_trx, str2char((*$<smtdv_string>9)));
dpi_smtdv_set_smtdv_transfer_rw(global_trx, str2char((*$<smtdv_string>11)));
dpi_smtdv_set_smtdv_transfer_bst_type(global_trx, str2char((*$<smtdv_string>13)));
dpi_smtdv_set_smtdv_transfer_trx_size(global_trx, str2char((*$<smtdv_string>15)));
dpi_smtdv_set_smtdv_transfer_trx_prt(global_trx, str2char((*$<smtdv_string>17)));
dpi_smtdv_set_smtdv_transfer_lock(global_trx, str2char((*$<smtdv_string>19)));
dpi_smtdv_set_smtdv_transfer_resp(global_trx, str2char((*$<smtdv_string>21)));
dpi_smtdv_set_smtdv_transfer_addr(global_trx, str2char((*$<smtdv_string>23)));
};

%%

#ifdef __cplusplus
extern "C" {
  /* parser smtdv.trx file */
  void* dpi_smtdv_parse_file(char* name) {
  FILE *file = fopen(name, "r");

  if (!file) {
    std::cout << "UVM_ERROR: DPI_SMTDV. can't open " << file << std::endl;
    exit(-1);
  }

  yyin = file;

  do {
    yyparse();
  } while (!feof(yyin));
    return global_mb;
  }
}
#endif
// selftest
/*
main() {

FILE *file = fopen("00001563.trx", "r");
if (!file) {
std::cout << "I can't open a.snazzle.file!" << std::endl;
   return -1;
}
yyin = file;
do {
yyparse();
} while (!feof(yyin));
void* trx = dpi_smtdv_next_smtdv_transfer(global_mb);
std::cout << dpi_smtdv_get_smtdv_transfer_begin_time(trx) << std::endl;
   }
*/

char* str2char(std::string str) {
  char *cstr = new char[str.length() + 1];
  strcpy(cstr, str.c_str());
  return cstr;
}

void yyerror(const char *s) {
  std::cout << "smtdv parse error! : " << s << std::endl;
   // might as well halt now:
  exit(-1);
}
