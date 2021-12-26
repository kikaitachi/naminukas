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
    output reg[10:0] channel_value
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
reg [32:0] clocks_to_skip = clocks_to_dectect_transmission_end;
reg [3:0] byte_bit_index;
reg [7:0] byte_index = 0;
reg [7:0] received_byte;

reg fport_sending = 0;
wire fport_output;
wire fport_input;

assign fport = fport_sending ? fport_output : 1'bZ;
assign fport_input = fport;

always @(posedge clock) begin
    case (state)
        FPORT_WAIT_FOR_TRANSMISSION_END: begin
            // Not used in new imlementation
        end
        FPORT_RESPOND: begin
            // TODO: send telemetry
            if (clocks_to_skip != 0) begin
                clocks_to_skip <= clocks_to_skip - 1;
            end else begin
              fport_sending <= 0;
              state <= FPORT_WAIT_FOR_TRANSMISSION_START;
              byte_index <= 0;
            end
        end
        FPORT_WAIT_FOR_TRANSMISSION_START: begin
            channel_changed <= 0;
            if (fport_input == 1) begin
                state <= FPORT_READ_BYTES;
                clocks_to_skip <= half_clocks_per_bit * 3;
                byte_bit_index <= 0;
            end
        end
        FPORT_READ_BYTES: begin
            if (clocks_to_skip != 0) begin
                clocks_to_skip <= clocks_to_skip - 1;
                channel_changed <= 0;
            end else begin
                if (byte_bit_index == 8) begin
                  if (byte_index == 0 && received_byte != 'h7E) begin
                    // Invalid header
                    state <= FPORT_WAIT_FOR_TRANSMISSION_START;
                  end else if (byte_index == 1 && received_byte != 'h19) begin
                    // Invalid length
                    state <= FPORT_WAIT_FOR_TRANSMISSION_START;
                    byte_index <= 0;
                  end else if (byte_index == 2 && received_byte != 'h00) begin
                    // Invalid type
                    state <= FPORT_WAIT_FOR_TRANSMISSION_START;
                    byte_index <= 0;
                  end else begin
                    if (byte_index == 39) begin
                      channel_changed <= 1;
                      channel_index = 0;
                      channel_value[10:8] <= 3'b000;
                      channel_value[7:0] <= received_byte;
                    end else if (byte_index == 40) begin
                      channel_changed <= 1;
                      channel_index = 1;
                      channel_value[10:8] <= 3'b000;
                      channel_value[7:0] <= received_byte;
                    end else if (byte_index == 41) begin
                      channel_changed <= 1;
                      channel_index = 2;
                      channel_value[10:8] <= 3'b000;
                      channel_value[7:0] <= received_byte;
                    end else if (byte_index == 42) begin
                      channel_changed <= 1;
                      channel_index = 3;
                      channel_value[10:8] <= 3'b000;
                      channel_value[7:0] <= received_byte;
                    end
                    //channel_value[10:4] <= 7'b0000000;
                    //channel_value[3:0] <= channel_index;
                    if (byte_index == 42) begin
                        state <= FPORT_RESPOND;
                        fport_sending <= 1;
                        clocks_to_skip <= 36000;  // 3ms
                    end else begin
                        byte_index <= byte_index + 1;
                        state <= FPORT_WAIT_FOR_TRANSMISSION_START;
                    end
                  end
                end else begin
                    received_byte[byte_bit_index[2:0]] <= ~fport_input;
                    byte_bit_index <= byte_bit_index + 1;
                    clocks_to_skip <= clocks_per_bit;
                end
            end
        end
    endcase
end

endmodule
