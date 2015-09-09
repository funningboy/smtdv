#!/bin/csh -f 


#	OSCI_INSTALL (if relevant)
#	OSCI_SRC (if relevant)
#	UVM_ML_CC
#	UVM_ML_LD
#	UVM_ML_COMPILER_VERSION (4.1, 4.4 etc)
#	UVM_ML_OVERRIDE
#	UNILANG_OVERRIDE
#	IES_VERSION (if relevant)
#	OSCI_VERSION (if relevant)
#       SPECMAN_PATH (if relevant)

set var_list="UVM_ML_CXX_OPTS UVM_ML_HOME OSCI_INSTALL OSCI_SRC TLM2_INSTALL UVM_ML_CC UVM_ML_LD UVM_ML_SVDPI_DIR UVM_ML_COMPILER_VERSION UVM_ML_OVERRIDE UNILANG_OVERRIDE IES_VERSION OSCI_VERSION SPECMAN_DLIB SPECMAN_PATH UVM_ML_CDS_INST_DIR"


if ( ! $?UVM_ML_SETUP_BASE_NAME )  then
set UVM_ML_SETUP_BASE_NAME=setup
endif

set link_base_name=${UVM_ML_HOME}/ml/setup_latest_${BITS}

##########################################################
#
# CSH format
# 
##########################################################



set dump_file=$UVM_ML_HOME/ml/${UVM_ML_SETUP_BASE_NAME}_${BITS}.csh
\rm -f $dump_file

echo '# UVM_ML setup capture' > $dump_file
echo '# Performed at' `date` >> $dump_file
echo >> $dump_file
echo "setenv UVM_ML_BITS ${BITS}" >> $dump_file
echo >> $dump_file

foreach env_var ( $var_list )
if ( `eval echo \$\?$env_var` ) then
    set value=`eval echo \${${env_var}}`

#    echo 'if ( \! ' \$\?$env_var ' ) then ' >> $dump_file
    echo "setenv  $env_var '$value' " >> $dump_file
#    echo 'endif' >> $dump_file
    echo >>  $dump_file

endif
end

ln -sf ${dump_file} ${link_base_name}.csh

##########################################################
#
# Bourne shell format
# 
##########################################################

set dump_file=$UVM_ML_HOME/ml/${UVM_ML_SETUP_BASE_NAME}_${BITS}.sh
\rm -f $dump_file

echo '# UVM_ML setup capture' > $dump_file
echo '# Performed at' `date` >> $dump_file
echo >> $dump_file
echo 'UVM_ML_BITS='${BITS} >> $dump_file;
echo "export UVM_ML_BITS" >> $dump_file;
echo >> $dump_file


foreach env_var ( $var_list )
if ( `eval echo \$\?$env_var` ) then
    set value=`eval echo \${${env_var}}`

    echo ${env_var}'='${value} >> $dump_file;
    echo "export $env_var" >> $dump_file;
endif
end

ln -sf ${dump_file} ${link_base_name}.sh






####################################################################
# 
# Makefile format
#
####################################################################


set dump_file=$UVM_ML_HOME/ml/${UVM_ML_SETUP_BASE_NAME}_${BITS}.mk

\rm -f $dump_file

echo '# UVM_ML setup capture' > $dump_file
echo '# Performed at' `date` >> $dump_file
echo >> $dump_file
echo "UVM_ML_BITS := " ${BITS} >> $dump_file
echo "export UVM_ML_BITS" >> $dump_file
echo >> $dump_file

foreach env_var ($var_list )
if ( `eval echo \$\?$env_var` ) then
    set value=`eval echo \${${env_var}}`
#    echo "ifndef $env_var" >> $dump_file
    echo "$env_var := " $value >> $dump_file
    echo "export $env_var" >> $dump_file
#    echo 'endif' >> $dump_file
    echo >>  $dump_file
endif
end

ln -sf ${dump_file} ${link_base_name}.mk
