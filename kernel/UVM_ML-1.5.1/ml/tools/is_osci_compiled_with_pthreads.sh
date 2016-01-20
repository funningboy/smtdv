#!/bin/bash

result=$(nm -A ${OSCI_INSTALL}/lib-linux64/libsystemc.a ${OSCI_INSTALL}/lib-linux/libsystemc.a 2>/dev/null | grep sc_cor_pthread | wc -l )

if [[ $result -eq 0 ]];then
    echo no
else
    echo yes
fi
