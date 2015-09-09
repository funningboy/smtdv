specman -c "load edoc_seqr_proxy.e;write doc -no_source_links -hide_creation_command @ml_base_seqr_proxy"

<'
import ../../primitives/sequence_layering/e/ml_base_seqr_proxy;

struct user_base_sequence like any_sequence_item { };
struct user_transfer like any_sequence_item { };
sequence user_master_sequence using 
  item = user_transfer,
  sequence_driver_type = ml_base_seqr_proxy of (user_base_sequence),
  created_driver = user_seqr_proxy
  ;
'>