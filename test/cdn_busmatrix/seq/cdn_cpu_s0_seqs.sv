`ifndef __CDN_CPU_S0_SEQS_SV__
`define __CDN_CPU_S0_SEQS_SV__


class cdn_cpu_s0_stl_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  `AHB_MASTER_STL_SEQ;

    static string m_file = "../stl/cdn_cpu_s0.stl";

    `uvm_sequence_utils(`CDN_CPU_S0_STL_SEQ, `AHB_MASTER_SEQUENCER)

    function new(string name = "cdn_cpu_s0_stl_seq");
      super.new(name);
    endfunction

endclass

`endif // __CDN_CPU_S0_SEQS_SV__

