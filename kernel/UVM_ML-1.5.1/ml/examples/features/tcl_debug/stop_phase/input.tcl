uvm_ml_phase -stop_at -end connect
run
uvm_ml_phase -stop_at -end start_of_simulation
run
uvm_component -describe svtop -depth -1
run
uvm_ml_phase -list_stop
quit
