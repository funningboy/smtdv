#!/bin/sh
mkdir -p uvm_sv_proj
mkdir -p ../html_docs/uvm_sv_adapter
NaturalDocs -i uvm_sv_adapter -o HTML ../html_docs/uvm_sv_adapter -p uvm_sv_proj
mkdir -p svdoc_data
mkdir -p ../html_docs/sequence_layering_sv
NaturalDocs -i ../../primitives/sequence_layering/sv -o HTML ../html_docs/sequence_layering_sv -p svdoc_data
