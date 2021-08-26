`include "uart.v"

module dynamixel_sync_write_position
#(
    parameter clocks_per_bit = 1,
    parameter id1 = 2,
    parameter id2 = 3,
    parameter id3 = 4,
    parameter id4 = 5
)
(
    input clock,
    input send,
    input[31:0] position1,
    input[31:0] position2,
    input[31:0] position3,
    input[31:0] position4,
    output pin
);

reg send_byte;
reg[7:0] byte_to_send;
reg done;
reg[7:0] state;

uart
#(
    .clocks_per_bit(clocks_per_bit)
)
dynamixel_uart
(
    .clock(clock),
    .send(send_byte),
    .byte_to_send(byte_to_send),
    .done(done),
    .pin(pin)
);

initial begin
    send_byte = 0;
    state = 0;
end

always @(posedge clock)
begin
    case (state)
        // Header 1
        0: begin
            if (send == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'hFF;
                state <= 1;
            end
        end
        // Header 2
        1: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'hFF;
                state <= 2;
            end else begin
                send_byte <= 0;
            end
        end
        // Header 3
        2: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'hFD;
                state <= 3;
            end else begin
                send_byte <= 0;
            end
        end
        // Reserved
        3: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h00;
                state <= 4;
            end else begin
                send_byte <= 0;
            end
        end
        // Packet ID
        4: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'hFE;  // Broadcast ID
                state <= 5;
            end else begin
                send_byte <= 0;
            end
        end
        // Packet length: the least significant byte
        5: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h1B;
                state <= 6;
            end else begin
                send_byte <= 0;
            end
        end
        // Packet length: the most significant byte
        6: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h00;
                state <= 7;
            end else begin
                send_byte <= 0;
            end
        end
        // Instruction
        7: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h83;  // Sync Write
                state <= 8;
            end else begin
                send_byte <= 0;
            end
        end
        // Address: the least significant byte
        8: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h74;
                state <= 9;
            end else begin
                send_byte <= 0;
            end
        end
        // Address: the most significant byte
        9: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h00;
                state <= 10;
            end else begin
                send_byte <= 0;
            end
        end
        // Data length: the least significant byte
        10: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h04;
                state <= 11;
            end else begin
                send_byte <= 0;
            end
        end
        // Data length: the most significant byte
        11: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h00;
                state <= 12;
            end else begin
                send_byte <= 0;
            end
        end
        // 1st device ID
        12: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= id1;
                state <= 13;
            end else begin
                send_byte <= 0;
            end
        end
        // Position1: byte 1
        13: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position1[7:0];
                state <= 14;
            end else begin
                send_byte <= 0;
            end
        end
        // Position1: byte 2
        14: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position1[15:8];
                state <= 15;
            end else begin
                send_byte <= 0;
            end
        end
        // Position1: byte 3
        15: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position1[23:16];
                state <= 16;
            end else begin
                send_byte <= 0;
            end
        end
        // Position1: byte 4
        16: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position1[31:24];
                state <= 17;
            end else begin
                send_byte <= 0;
            end
        end
        // 2nd device ID
        17: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= id2;
                state <= 18;
            end else begin
                send_byte <= 0;
            end
        end
        // Position2: byte 1
        18: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position2[7:0];
                state <= 19;
            end else begin
                send_byte <= 0;
            end
        end
        // Position2: byte 2
        19: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position2[15:8];
                state <= 20;
            end else begin
                send_byte <= 0;
            end
        end
        // Position2: byte 3
        20: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position2[23:16];
                state <= 21;
            end else begin
                send_byte <= 0;
            end
        end
        // Position2: byte 4
        21: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position2[31:24];
                state <= 22;
            end else begin
                send_byte <= 0;
            end
        end
        // 3rd device ID
        22: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= id3;
                state <= 23;
            end else begin
                send_byte <= 0;
            end
        end
        // Position3: byte 1
        23: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position3[7:0];
                state <= 24;
            end else begin
                send_byte <= 0;
            end
        end
        // Position3: byte 2
        24: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position3[15:8];
                state <= 25;
            end else begin
                send_byte <= 0;
            end
        end
        // Position3: byte 3
        25: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position3[23:16];
                state <= 26;
            end else begin
                send_byte <= 0;
            end
        end
        // Position3: byte 4
        26: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position3[31:24];
                state <= 27;
            end else begin
                send_byte <= 0;
            end
        end
        // 4th device ID
        27: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= id4;
                state <= 28;
            end else begin
                send_byte <= 0;
            end
        end
        // Position4: byte 1
        28: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position4[7:0];
                state <= 29;
            end else begin
                send_byte <= 0;
            end
        end
        // Position4: byte 2
        29: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position4[15:8];
                state <= 30;
            end else begin
                send_byte <= 0;
            end
        end
        // Position4: byte 3
        30: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position4[23:16];
                state <= 31;
            end else begin
                send_byte <= 0;
            end
        end
        // Position4: byte 4
        31: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= position4[31:24];
                state <= 32;
            end else begin
                send_byte <= 0;
            end
        end
        // CRC: the least significant byte
        32: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h04;  // TODO: calculate
                state <= 33;
            end else begin
                send_byte <= 0;
            end
        end
        // CRC: the most significant byte
        33: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'h00;  // TODO: calculate
                state <= 34;
            end else begin
                send_byte <= 0;
            end
        end
        default: begin
            state <= 0;
            send_byte <= 0;
        end
    endcase
end

endmodule
