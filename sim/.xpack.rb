#list of all peripherals
lib_modules = ['aai','i2c','uart','can','gpio','i2s','mwspi','mftx','miwux','rtc','smcard','twm','vtu']

# test is set to current test
amodule = lib_modules.detect { |mod| test =~ /^tp-#{mod}/ }

raise_error "can not find #{test}" unless amodule

# include files
Dir["../src/#{amodule}/*_params.v"].each { |rtl|
  source_files("../src/#{amodule}/" << File.basename("#{rtl}"))
}
# source files
Dir["../src/#{amodule}/*.v"].each { |rtl|
  source_files("../src/#{amodule}/" << File.basename("#{rtl}")) if not rtl =~/params/ and not rtl =~ /undef/
}

# generic cells (common to all peripherals)
source_files("../src/generic_cells/inv_gea1.v")
source_files("../src/generic_cells/mux_n2x1_gea0.v")
source_files("../src/generic_cells/buf_gea1.v")
source_files("../src/generic_cells/nand2_gea1.v")

# RTL configuration for SRC license (in order to enable Clock Gating)
#macros({'GATED_CLOCK' => "1"}) #boolean 
# RTL configuration for SRC license (in order to change GPIO channels)
#macros({'GPIO_CH' => "16"}) # integer

# List of include directories
include_directories("../src/#{amodule}", "./tb/")
  
