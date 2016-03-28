
`ifndef __SMTDV_ABOUT_SVH__
`define __SMTDV_ABOUT_SVH__

typedef struct {
  string name;
  string mail;
} author_t;

typedef struct {
  author_t authors[$];
  string license;
  string version;
  string date;
} about_t;

about_t about = '{
  authors: '{
    '{
        name: "sean.chen",
        mail: "funningboy.gamil.com"
     },
     '{
        name: "tony.shen",
        mail: ""
     }
  },
  date: "2016/03/26",
  version: "1.0",
  license: "Apache License, version 2.0 MIT"
};

`endif // __SMTDV_ABOUT_SVH__
