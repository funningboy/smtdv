The examples directory contains various tests demonstrating the UVM-ML OA
capabilities.
Every test has Makefiles to run in various mode with several simulators.


README.txt - this file
use_cases/            - Complex examples demonstrating multiple features
  e_over_sv/                - Sequence layering in hierarchical environment
  side_by_side/             - Multiple verification components communicating via TLM
    sc_sv/                  - producer consumer example
    sc_sv_e/                - producer consumer example with 3 frameworks
    sv_e/                   - producer consumer example
  sv_over_e/                - Sequence layering in hierarchical environment
features/             - Simple examples demonstrating specific features
  cdns_addons/           - Using CDNS UVM-SV addon features in ML environment
    nowarn/                 - Turn off specific warning
    tcl/                    - Using Tcl commands
    trans_recording/        - Transaction recording
  configuration/         - ML configuration
    e_sv/                        - e code configuring SystemVerilog
      generation_control/        - e code configuring build time parameters of SV
    sv_e/                        - SystemVerilog code configuring e
      sv_get_config/             - e code configuring SV
      sv_set_config/             - SV code configuring e
    sv_sc/                       - SystemVerilog code configuring SystemC
      sc_top_sv_subtree/         - SC code configuring SV
      sv_top_config_db_ud_types/ - SV code configuring SS using uvm_config_db
      sv_top_sc_subtree/         - SV code configuring SC
  phasing/               - ML phasing
    sv_sc/
      sc_phasing/
  sequences/             - Pointer to sequence layering examples in use_cases
  stub_unit/             - Stub unit example for e environment instantiated under SV
    sv_e/
  synchronization/       - ML synchronization capabilities
    sc_sv/
      barrier/              - Using barries
      event/                - Using events
  tcl_debug/             - Debug capabilities
    print_tree/             - Printing the ML hierarchy
    stop_phase/             - Managing phase breakpoints
  tlm1/                  - TLM1 communication between frameworks
    prod_cons/              - side by side producer consumer examples
      e_sv_tlm1/            - blocking and non-blocking from e to SV
      sc_sv_tlm1/           - blocking and non-blocking from SC to SV
      sv_e_tlm1/            - blocking and non-blocking from SV to e
      sv_sc_tlm1/           - blocking and non-blocking from SV to SC
    sc_sv/
      TLM1_all_if/          - all TLM1 interfaces
      analysis_if/          - simple example of analysis port
      sv_with_sc_ref_model/ - SystemC reference model in SV environment
    sv_e/
      e_sv_blocking_get/    - e code getting packet from SV
      queue_template/       - e code transferring complex data structure containing queue
  tlm2/                  - TLM2 communication between frameworks
    prod_cons/              - side by side producer consumer examples
      e_sv_tlm2/            - blocking and non-blocking from e to SV
      sc_sv_tlm2/           - blocking and non-blocking from SC to SV
      sv_e_tlm2/            - blocking and non-blocking from SV to e
      sv_sc_tlm2/           - blocking and non-blocking from SV to SC
    sc_sv/
      sc_initiator_sv_target/                        - blocking and non-blocking from SC to SV
      sc_initiator_sv_target_sc_connect/             - connect in constructor
      sc_initiator_sv_target_sc_connect_static_vars/ - using DPI-C to coordinate end of test
      sc_initiator_sv_target_w_ext/                  - using generic payload extentions
      sv_initiator_sc_target/                        - blocking and non-blocking from SV to SC
    sv_e/
      e_initiator_sv_target/                         - non-blocking transaction from e to SV
    sv_sv/                   - TLM2 between two SV environments
      sv_sv_blocking/        - blocking transactions
      sv_sv_nonblocking/     - non-blocking transactions
  unified_hierarchy/       - Unified hierarchy demonstrated
    sc_e/
      e_top_sc_subtree/      - SC component in e environment with analysis port
      sc_top_e_subtree/      - e code instantiated under SC with analysis port
    sc_sv/
      prod_cons/             - SC component in SV environment with TLM2
      sc_top_sv_subtree/     - SV verification component in SC environment with analysis port
      sv_top_sc_subtree/     - SC verification component in SV environment with analysis port
    sv_e/
      e_top_sv_subtree/      - SV verification component in e environment with analysis port
      prod_cons/             - e verification component in SV environment with TLM2
      sv_top_e_subtree/      - e verification component in SV environment with analysis port
      e_top_sv_tlm2          - SV code in e environment using TLM2 
ex_single_lang_uvcs_lib/  - Example UVCs used in other examples
  ubus_sv/                - UBUS from UVM-SV
  xbus_simple/            - XBUS from UVM-e
