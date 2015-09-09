#!/bin/sh
specman -c "load edoc_seqr_proxy.e;write doc -no_source_links -hide_creation_command -dir=../html_docs/sequence_layering_e_proxy -overwrite @ml_base_seqr_proxy"
specman -c "load edoc_seqr_tlm_if.e;write doc -no_source_links -hide_creation_command -dir=../html_docs/sequence_layering_e_tlm_if -overwrite @seqr_tlm_interface"
