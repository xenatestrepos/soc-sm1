#list of all peripherals
lib_modules = ['aai','i2c','usart','can','gpio','i2s','mwspi','mftx','miwux','rtc','smcard','twm','vtu']

# @core set to current core (set in datasheet)
amodule = lib_modules.detect { |mod|  @core =~ /#{mod}/ }

raise_error "can not find #{@core}" unless amodule

if manifest.core_is_VHDL?
  raise_error "VHDL unsupported"
else
  source_files("../src/#{amodule}/ck_gpio_xt_geh0_params.v")
  Dir["../src/#{amodule}/*.v"].each { |rtl|
    source_files("../src/#{rtl}") if not rtl =~/params/ and not rtl =~ /undef/
  }

  # generic cells (common to all peripherals)
  source_files("../src/generic_cells/inv_gea1.v")
  source_files("../src/generic_cells/mux_n2x1_gea0.v")
  source_files("../src/generic_cells/buf_gea1.v")
  source_files("../src/generic_cells/nand2_gea1.v")

  # define additional generic cells
  case amodule
  when "i2c" then
    source_files("../src/generic_cells/and2_gea1.v")
    source_files("../src/generic_cells/delay_gea0.v")
  end
end
