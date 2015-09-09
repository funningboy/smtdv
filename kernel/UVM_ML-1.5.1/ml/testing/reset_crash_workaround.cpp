#include <iostream>
#include <streambuf>
using namespace std;

volatile static struct s1 { 
    streambuf *cout_buf;
    streambuf *cerr_buf;
    s1() { 
        cout_buf = cout.rdbuf();
        cerr_buf = cerr.rdbuf();
    }

    ~s1() { 
        cout.rdbuf(cout_buf);
        cerr.rdbuf(cerr_buf);
    }

} v1;
