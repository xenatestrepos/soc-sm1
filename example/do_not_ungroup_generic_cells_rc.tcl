#require for change_link
source load_etc.tcl
uniquify $my_design

foreach a {delay_gea0 or2_gea0 nor2_gea1 inv_gea1 mux_n2x1_gea0 buf_gea1 nand2_gea1 and2_gea1 mux_n4x1_aua0 mux_nmx1_gea0} {
  if {[find /des* -subdesign $a] != ""} {
    set count 1

    foreach i [get_attribute instances [ find /des* -subdesign $a ]] {
      # create new design
      echo "XPack: Derive instance" $i
      derive_environment $i -name ${a}_${count}_d

      # precompile design
      echo "XPack: Synthesize design" /designs/${a}_${count}_d
      synthesize -to_mapped /designs/${a}_${count}_d

      # change link and preserve/dont_touch precompiled cell
      echo "XPack: Change link" $i "design" /designs/${a}_${count}_d
      change_link -instances $i -design_name /designs/${a}_${count}_d
      
      set ui [get_attribute instances [ find /des* -subdesign ${a}_${count}_d* ]]
      echo "XPack: Preserve instance" $ui
      set_attribute preserve true $ui

      incr count
    }

    # remove designs
    foreach d [find -design /designs/$a* ] {
      echo "XPack: Remove" $d
      rm $d
    }
  }
}
