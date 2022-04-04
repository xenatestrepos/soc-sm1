
# do not ungroup generic cells
foreach a {delay_gea0 or2_gea0 nor2_gea1 inv_gea1 mux_n2x1_gea0 buf_gea1 nand2_gea1 and2_gea1 mux_n4x1_aua0 mux_nmx1_gea0} {
  if {[get_designs -quiet $a] != ""} {
      echo "do not ungroup module " $a
      set_ungroup $a false
  }
}
