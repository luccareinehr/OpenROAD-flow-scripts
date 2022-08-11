utl::set_metrics_stage "detailedplace__{}"
source $::env(SCRIPTS_DIR)/load.tcl
load_design 3_4_place_resized.odb 2_floorplan.sdc "Starting detailed placement"

source $::env(PLATFORM_DIR)/setRC.tcl

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)

# identify rows from voltage domain TEMP_ANALOG
set db [ord::get_db]
set tech [$db getTech]
set libs [$db getLibs]
set block [[$db getChip] getBlock]

set has_domain 0
foreach region [$block getRegions] {
  set domain $region
  set domain_name [$region getName]
  set has_domain 1
}

set domain_rows []
if {$has_domain == 1} {
  foreach row [$block getRows] {
    set result [regexp $domain_name [$row getName] match]
    if {$result == 1} {
      lappend domain_rows [list [$row getName] \
                                [$row getSite] \
                                [$row getBBox] \
                                [$row getOrient] \
                          ]
      odb::dbRow_destroy $row
    }
  }
}

foreach row [$block getRows] { puts [$row getName] }

# run detailed_placement only on cells outside TEMP_ANALOG
detailed_placement

# recreate rows from TEMP_ANALOG
foreach row $domain_rows {
  odb::dbRow_create $block [lindex $row 0] \
                           [lindex $row 1] \
                           [[lindex $row 2] xMin] \
                           [[lindex $row 2] yMin] \
                           [lindex $row 3] \
                           "HORIZONTAL" \
                           [expr ([[lindex $row 2] xMax] - [[lindex $row 2] xMin]) / [[lindex $row 1] getWidth]] \
                           [[lindex $row 1] getWidth]
}

# identify rows outside voltage domain TEMP_ANALOG
if {$has_domain == 1} {
  set placed_insts []
  set region_insts [$region getRegionInsts]
  foreach inst [$block getInsts] {
    if {[lsearch -exact $region_insts $inst] >= 0} {
    } else {
      if {[$inst getPlacementStatus] == "FIRM"} {
      } else {
        lappend placed_insts $inst
        $inst setPlacementStatus "FIRM"
      }
    }
  }

  set core_rows []
  foreach row [$block getRows] {
    set result [regexp $domain_name [$row getName] match]
    if {$result == 1} {
    } else {
      lappend core_rows [list [$row getName] \
                              [$row getSite] \
                              [$row getBBox] \
                              [$row getOrient] \
                        ]
      odb::dbRow_destroy $row
    }
  }

  # run detailed_placement only on cells from TEMP_ANALOG
  detailed_placement

  # recreate rows outside TEMP_ANALOG
  foreach row $core_rows {
    odb::dbRow_create $block [lindex $row 0] \
                             [lindex $row 1] \
                             [[lindex $row 2] xMin] \
                             [[lindex $row 2] yMin] \
                             [lindex $row 3] \
                             "HORIZONTAL" \
                             [expr ([[lindex $row 2] xMax] - [[lindex $row 2] xMin]) / [[lindex $row 1] getWidth]] \
                             [[lindex $row 1] getWidth]

  }

  foreach inst $placed_insts {
    $inst setPlacementStatus "PLACED"
  }
}

#if {[info exists ::env(ENABLE_DPO)] && $::env(ENABLE_DPO)} {
#  if {[info exist ::env(DPO_MAX_DISPLACEMENT)]} {
#    improve_placement -max_displacement $::env(DPO_MAX_DISPLACEMENT)
#  } else {
#    improve_placement
#  }
#}
#optimize_mirroring

#utl::info FLW 12 "Placement violations [check_placement -verbose]."

#estimate_parasitics -placement

#source $::env(SCRIPTS_DIR)/report_metrics.tcl
#report_metrics "detailed place"

if {![info exists save_checkpoint] || $save_checkpoint} {
  write_db $::env(RESULTS_DIR)/3_5_place_dp.odb
}
