module fport_radio
#(
  parameter clock_frequency = 12000000,
  parameter fport_baudrate = 115_200,
  parameter clocks_per_bit = clock_frequency / fport_baudrate
) (
  input clock,
  inout fport,
  output reg channel_changed,
  output reg[3:0] channel_index,
  output reg[10:0] channel_value,
  output debug_pin
);

localparam FPORT_WAIT_FOR_TRANSMISSION_END   = 2'b00;
localparam FPORT_RESPOND                     = 2'b01;
localparam FPORT_WAIT_FOR_TRANSMISSION_START = 2'b10;
localparam FPORT_READ_BYTES                  = 2'b11;

localparam half_clocks_per_bit = clocks_per_bit / 2;

// If 20 zero bits are detected assume transmission is over
localparam clocks_to_dectect_transmission_end = clocks_per_bit * 20;

reg [1:0] state = FPORT_WAIT_FOR_TRANSMISSION_START;
// TODO: figure how many bits are really needed based on clock_frequency
reg [32:0] clocks_to_skip = 0;
reg [2:0] byte_bit_index;
reg [7:0] byte_index = 0;
reg [7:0] received_byte;

reg fport_sending = 0;
wire fport_output;
wire fport_input;

assign fport = fport_sending ? fport_output : 1'bZ;
assign fport_input = fport;

reg send_byte = 0;
reg[7:0] byte_to_send;
wire done;

uart
#(
    .clocks_per_bit(clocks_per_bit),
    .invert(1)
)
uplink_uart
(
    .clock(clock),
    .send(send_byte),
    .byte_to_send(byte_to_send),
    .done(done),
    .pin(fport_output)
);

always @(posedge clock) begin
  if (clocks_to_skip != 0) begin
    clocks_to_skip <= clocks_to_skip - 1;
  end else begin
    //debug_pin <= 0;
    case (state)
      FPORT_WAIT_FOR_TRANSMISSION_END: begin
        state <= FPORT_RESPOND;
        fport_sending <= 1;
        byte_index <= 0;
        byte_to_send <= 'h08;
        send_byte <= 1;
      end
      FPORT_RESPOND: begin
        if (done == 1) begin
          if (byte_index == 0) begin
            byte_index <= 1;
            byte_to_send <= 'h81;
            send_byte <= 1;
          end else if (byte_index == 1) begin
            byte_index <= 2;
            byte_to_send <= 'h10;
            send_byte <= 1;
          end else if (byte_index == 2) begin
            byte_index <= 3;
            byte_to_send <= 'h00;
            send_byte <= 1;
          end else if (byte_index == 3) begin
            byte_index <= 4;
            byte_to_send <= 'h51;
            send_byte <= 1;
          end else if (byte_index == 4) begin
            byte_index <= 5;
            byte_to_send <= 'h01;
            send_byte <= 1;
          end else if (byte_index == 5) begin
            byte_index <= 6;
            byte_to_send <= 'h00;
            send_byte <= 1;
          end else if (byte_index == 6) begin
            byte_index <= 7;
            byte_to_send <= 'h00;
            send_byte <= 1;
          end else if (byte_index == 7) begin
            byte_index <= 8;
            byte_to_send <= 'h00;
            send_byte <= 1;
          end else if (byte_index == 8) begin
            byte_index <= 9;
            byte_to_send <= 20;  // TODO: calculate CRC
            send_byte <= 1;
          end else begin
            fport_sending <= 0;
            state <= FPORT_WAIT_FOR_TRANSMISSION_START;
            byte_index <= 0;
            //debug_pin <= 1;
            //clocks_to_skip <= 36000;  // 3ms
          end
        end else begin
          send_byte <= 0;
        end
      end
      FPORT_WAIT_FOR_TRANSMISSION_START: begin
        if (fport_input == 1) begin
          state <= FPORT_READ_BYTES;
          clocks_to_skip <= half_clocks_per_bit * 3;
          byte_bit_index <= 0;
          //debug_pin <= 1;
        end
      end
      FPORT_READ_BYTES: begin
        received_byte[byte_bit_index] = ~fport_input;
        if (byte_bit_index == 7) begin
          if (byte_index == 0 && received_byte != 'h7E) begin
            // Invalid header
            state <= FPORT_WAIT_FOR_TRANSMISSION_START;
            clocks_to_skip <= clocks_per_bit;
          end else if (byte_index == 1 && received_byte != 'h19) begin
            // Invalid length
            state <= FPORT_WAIT_FOR_TRANSMISSION_START;
            clocks_to_skip <= clocks_per_bit;
            byte_index <= 0;
          end else if (byte_index == 2 && received_byte != 'h00) begin
            // Invalid type
            state <= FPORT_WAIT_FOR_TRANSMISSION_START;
            clocks_to_skip <= clocks_per_bit;
            byte_index <= 0;
          end else if (byte_index == 40) begin
            state <= FPORT_WAIT_FOR_TRANSMISSION_END;
            clocks_to_skip <= clocks_per_bit * 16;
          end else begin
            state <= FPORT_WAIT_FOR_TRANSMISSION_START;
            byte_index <= byte_index + 1;
            clocks_to_skip <= clocks_per_bit;
          end
        end else begin
          byte_bit_index <= byte_bit_index + 1;
          clocks_to_skip <= clocks_per_bit;
        end
      end
    endcase
  end
end

endmodule
