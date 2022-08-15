# NDR rules
source scripts/openfasoc/add_ndr_rules.tcl

# Custom connections
source scripts/openfasoc/create_custom_connections.tcl
if {[info exist ::env(CUSTOM_CONNECTION)]} {
  create_custom_connections $::env(CUSTOM_CONNECTION)
}
