.PHONY: build
build: lint
	mkdir -p build && \
    yosys -p "synth_ice40 -top naminukas -json build/naminukas.json" hdl/naminukas.v && \
	nextpnr-ice40 -r --hx8k --json build/naminukas.json --package cb132 --asc build/naminukas.asc --opt-timing --pcf synthesis/iceFUN.pcf && \
	icepack build/naminukas.asc build/naminukas.bin

flash: build
	iceFUNprog build/naminukas.bin

lint:
	cd hdl && verilator --lint-only naminukas.v

.PHONY: test
test:
	iverilog -o uart_test hdl/uart.v test/tb_uart.v && \
    vvp uart_test && \
    rm uart_test
