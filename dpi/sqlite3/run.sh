#!/bin/csh -f

g++ -I/stec/tw/users/schen/local/include -L/stec/tw/users/schen/local/lib -lsqlite3 -Wwrite-strings dpi_smtdv_pool.cpp dpi_smtdv_table.cpp dpi_smtdv_sqlite3.cpp dpi_smtdv_lib.cpp -o dpi_smtdv_lib.so -shared  -lfl -fPIC -Wall

g++ -I/stec/tw/users/schen/local/include -L/stec/tw/users/schen/local/lib -lsqlite3 -Wwrite-strings dpi_smtdv_pool.cpp dpi_smtdv_table.cpp dpi_smtdv_sqlite3.cpp dpi_smtdv_lib.cpp test_dpi_smtdv.cpp

