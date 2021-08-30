`include "dynamixel.v"
//`include "fport_radio.v"

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

/*reg channel_changed;
reg[3:0] channel_index;
reg[10:0] channel_value;

fport_radio
#(
    //
)
rc_radio
(
    .clock(clock),
    .fport(fport),
    .channel_changed(channel_changed),
    .channel_index(channel_index),
    .channel_value(channel_value)
);
*/

reg[15:0] address;
reg[15:0] data_len;
reg[31:0] value1;
reg[31:0] value2;
reg[31:0] value3;
reg[31:0] value4;

reg[7:0] dyn_test;
reg dyn_send;

dynamixel_sync_write #(
    .clocks_per_bit(clock_frequency / dynamixel_baudrate)
)
dynamixel_sync_writer
(
    .clock(clock),
    .send(dyn_send),
    .address(address),
    .data_len(data_len),
    .value1(value1),
    .value2(value2),
    .value3(value3),
    .value4(value4),
    .pin(dynamixel)
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
      /*if (counter == 2000) begin
          counter <= 0;
          fport <= 1;
          dyn_send <= 1;
      end else begin
          counter <= counter + 1;
          fport <= 0;
          dyn_send <= 0;
      end*/
      if (counter == clock_frequency * 3) begin  // Every 3 seconds toggle Torque Enable flag
          counter <= 0;
          fport <= 1;
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
          dyn_send <= 1;
      end else begin
          counter <= counter + 1;
          fport <= 0;
          dyn_send <= 0;
      end
  end

endmodule
