`include "dynamixel.v"
//`include "fport_radio.v"

module naminukas
#(
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
reg[31:0] position1;
reg[31:0] position2;
reg[31:0] position3;
reg[31:0] position4;

reg[7:0] dyn_test;
reg dyn_send;

dynamixel_sync_write_4bytes
#(
    .clocks_per_bit(3)
)
dynamixel_4bytes_writer
(
    .clock(clock),
    .send(dyn_send),
    .address(address),
    .data_len(data_len),
    .value1(position1),
    .value2(position2),
    .value3(position3),
    .value4(position4),
    .pin(dynamixel)
);

reg[15:0] counter;

initial begin
    counter = 0;
    address = 8'h0074;
    data_len = 4;
    position1 = 0;
    position2 = 256;
    position3 = 256;
    position4 = 0;
end

always @(posedge clock)
  begin
      if (counter == 2000) begin
          counter <= 0;
          fport <= 1;
          dyn_send <= 1;
      end else begin
          counter <= counter + 1;
          fport <= 0;
          dyn_send <= 0;
      end
  end

endmodule
