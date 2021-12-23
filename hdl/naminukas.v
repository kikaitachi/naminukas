`include "dynamixel.v"
`include "fport_radio.v"

module naminukas
#(
    parameter clock_frequency = 12000000,
    parameter dynamixel_baudrate = 4000000
)
(
    input clock,
    inout fport,
    inout dynamixel
);

wire channel_changed;
reg[3:0] channel_index;
reg[10:0] channel_value;

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
    .channel_value(channel_value)
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

always @(posedge clock)
  begin
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
