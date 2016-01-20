
irun \
-uvmhome $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml \
-ml_uvm \
$UVM_ML_HOME/ml/examples/uvcs/ubus_sv/examples/ubus_tb_top.sv \
+incdir+./sv \
+incdir+$UVM_ML_HOME/ml/examples/uvcs/ubus_sv/sv \
+incdir+$UVM_ML_HOME/ml/examples/uvcs/ubus_sv/examples \
-mltypemap_input ./do.tcl




