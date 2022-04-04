# testbench
source_files("./test/#{test}/gpio_rdwr_regs.v")
source_files("./tb/apb_slave_monitor.v")

# Toplevel
testbench("test_top")

macros({'PCLK'    => "20.0"})
