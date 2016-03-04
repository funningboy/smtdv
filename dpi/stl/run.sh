

# build up dpi_smtdv_stl.so
bison -d dpi_smtdv_parser.y
flex dpi_smtdv_parser.l
g++ dpi_smtdv_parser.tab.c lex.yy.c dpi_smtdv_transfer.cpp dpi_smtdv_wrapper.cpp -I./ -shared -o dpi_smtdv_stl.so -lfl -fPIC -Wall
