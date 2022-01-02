`include "dynamixel.v"
`include "fport_radio.v"
`include "iceFUN/ledscan.v"

module naminukas
#(
  parameter clock_frequency = 12000000,
  parameter dynamixel_baudrate = 4000000
)
(
  input clock,
  inout fport,
  inout dynamixel,
	output led1,
	output led2,
	output led3,
	output led4,
	output led5,
	output led6,
	output led7,
	output led8,
	output lcol1,
	output lcol2,
	output lcol3,
	output lcol4,
  output debug_pin
);

// LED holding registers, what is writed to these appears on the led display
reg [7:0] leds1;
reg [7:0] leds2;
reg [7:0] leds3;
reg [7:0] leds4;

// The output from the ledscan module
wire [7:0] leds;
wire [3:0] lcol;

// Map the output of ledscan to the port pins
assign { led8, led7, led6, led5, led4, led3, led2, led1 } = leds[7:0];
assign { lcol4, lcol3, lcol2, lcol1 } = lcol[3:0];

// Instantiate the led scan module
LedScan scan (
  .clk12MHz(clock),
  .leds1(leds1),
  .leds2(leds2),
  .leds3(leds3),
  .leds4(leds4),
  .leds(leds),
  .lcol(lcol)
);

wire channel_changed;
wire[3:0] channel_index;
wire[10:0] channel_value;

fport_radio
#(
  .clock_frequency(clock_frequency)
)
rc_radio
(
  .clock(clock),
  .fport(fport),
  .channel_changed(channel_changed),
  .channel_index(channel_index),
  .channel_value(channel_value),
  .debug_pin(debug_pin)
);

reg[15:0] address;
reg[15:0] data_len;
reg[31:0] value1;
reg[31:0] value2;
reg[31:0] value3;
reg[31:0] value4;

reg dynamixel_trigger_sending;
wire dynamixel_sending;
wire dynamixel_output;
wire dynamixel_input;

assign dynamixel = dynamixel_sending ? dynamixel_output : 1'bZ;
assign dynamixel_input = dynamixel;

dynamixel_sync_write #(
    .clocks_per_bit(clock_frequency / dynamixel_baudrate)
)
dynamixel_sync_writer
(
    .clock(clock),
    .send(dynamixel_trigger_sending),
    .address(address),
    .data_len(data_len),
    .value1(value1),
    .value2(value2),
    .value3(value3),
    .value4(value4),
    .sending(dynamixel_sending),
    .pin(dynamixel_output)
);

reg[31:0] counter;

always @ (*) begin

end

initial begin
    counter = 0;
    /* // Position
    address = 8'h0074;
    data_len = 4;
    value1 = 0;
    value2 = 256;
    value3 = 256;
    value4 = 0;*/
    // Torque Enable
    address = 64;
    data_len = 1;
    value1 = 0;
    value2 = 0;
    value3 = 0;
    value4 = 0;
end

always @(posedge clock) begin
    if (channel_changed == 1) begin
        if (channel_index == 0)
            leds1[7:0] = ~channel_value[7:0];
        else if (channel_index == 1)
            leds2[7:0] = ~channel_value[7:0];
        else if (channel_index == 2)
            leds3[7:0] = ~channel_value[7:0];
        else if (channel_index == 3)
            leds4[7:0] = ~channel_value[7:0];
        /*if (channel_index == 0)
            leds1[3:0] = ~channel_index;
        else if (channel_index == 1)
            leds2[3:0] = ~channel_index;
        else if (channel_index == 2)
            leds3[3:0] = ~channel_index;
        else if (channel_index == 3)
            leds4[3:0] = ~channel_index;*/
    end
    if (counter == clock_frequency * 3) begin  // Every 3 seconds toggle Torque Enable flag
        counter <= 0;
        if (value1 == 0) begin
              value1 <= 1;
              value2 <= 1;
              value3 <= 1;
              value4 <= 1;
        end else begin
              value1 <= 0;
              value2 <= 0;
              value3 <= 0;
              value4 <= 0;
        end
        dynamixel_trigger_sending <= 1;
    end else begin
        counter <= counter + 1;
        dynamixel_trigger_sending <= 0;
    end
end

endmodule
