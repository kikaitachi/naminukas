module fport_radio
#(
    parameter clock_frequency = 12000000,
    parameter fport_baudrate = 115_200,
    parameter clocks_per_bit = clock_frequency / fport_baudrate
) (
    input clock,
    inout fport,
    output channel_changed,
    output reg[3:0] channel_index,
    output reg[10:0] channel_value
);

reg fport_sending;
wire fport_output;
wire fport_input;

assign fport = fport_sending ? fport_output : 1'bZ;
assign fport_input = fport;

always @(posedge clock)
begin
    // TODO: implement
end

endmodule
