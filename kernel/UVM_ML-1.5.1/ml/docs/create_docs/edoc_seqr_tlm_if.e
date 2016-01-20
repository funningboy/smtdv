specman -c "load edoc_seqr_tlm_if.e;write doc -no_source_links -hide_creation_command  @seqr_tlm_interface"
<'
import ../../primitives/sequence_layering/e/seqr_tlm_interface.e;

struct user_trans_type like any_sequence_item { };
sequence user_sequence using 
        item = user_trans_type,
        created_driver = user_driver_u;
extend user_sequence_kind : [ML_MASTER_SERVICE_SEQ];
extend ML_MASTER_SERVICE_SEQ user_sequence {
   do_user_seq(p : ml_seq) @ driver.clock is empty;
};
extend user_driver_u {
   tlm_if: ml_seqr_tlm_if of (user_trans_type,ML_MASTER_SERVICE_SEQ user_sequence) is instance;
     keep tlm_if.sequencer == me;
}; // extend user_master_driver_u
'>