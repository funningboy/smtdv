#!/bin/bash
full_ies_version="UNKNOWN"

SN_EXEC_PATH=$(/usr/bin/which specman 2>/dev/null)
if [[ "X${SN_EXEC_PATH}" != "X"  ]]; then
    full_ies_version=$(specman -version)
else
    if  [[ $# -gt 0 ]];then 
        full_ies_version=$($*/irun -version)
    else
        NCROOT_PATH=$(/usr/bin/which ncroot 2>/dev/null)
        if [[ X${NCROOT_PATH} != X ]]; then
            full_ies_version=$(irun -version)
        fi

    fi

fi


regex="([0-9][0-9]\.[0-9][0-9])"
if [[ ${full_ies_version} =~ ${regex} ]]; then
    echo ${BASH_REMATCH[1]}
else
    echo ${full_ies_version}
fi
