`include "uart.v"

// See https://emanual.robotis.com/docs/en/dxl/protocol2/
module dynamixel_sync_write_4bytes
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
    input[15:0] address,
    input[31:0] value1,
    input[31:0] value2,
    input[31:0] value3,
    input[31:0] value4,
    output pin
);

function [15:0] crc16(input [7:0] data, input [15:0] crc);
    reg [7:0] d;
    reg [15:0] c;
    reg [15:0] updated_crc;
    begin
        d = data;
        c = crc;
        updated_crc[0] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ d[0] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15];
        updated_crc[1] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15];
        updated_crc[2] = d[1] ^ d[0] ^ c[8] ^ c[9];
        updated_crc[3] = d[2] ^ d[1] ^ c[9] ^ c[10];
        updated_crc[4] = d[3] ^ d[2] ^ c[10] ^ c[11];
        updated_crc[5] = d[4] ^ d[3] ^ c[11] ^ c[12];
        updated_crc[6] = d[5] ^ d[4] ^ c[12] ^ c[13];
        updated_crc[7] = d[6] ^ d[5] ^ c[13] ^ c[14];
        updated_crc[8] = d[7] ^ d[6] ^ c[0] ^ c[14] ^ c[15];
        updated_crc[9] = d[7] ^ c[1] ^ c[15];
        updated_crc[10] = c[2];
        updated_crc[11] = c[3];
        updated_crc[12] = c[4];
        updated_crc[13] = c[5];
        updated_crc[14] = c[6];
        updated_crc[15] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[2] ^ d[1] ^ d[0] ^ c[7] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15];
        crc16 = updated_crc;
    end
endfunction

reg send_byte;
reg[7:0] byte_to_send;
reg done;
reg[7:0] state;
reg [15:0] crc;

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
    crc = 0;
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
                crc <= crc16(8'hFF, crc);
            end
        end
        // Header 2
        1: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= 8'hFF;
                state <= 2;
                crc <= crc16(8'hFF, crc);
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
                crc <= crc16(8'hFD, crc);
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
                crc <= crc16(8'h00, crc);
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
                crc <= crc16(8'hFE, crc);
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
                crc <= crc16(8'h1B, crc);
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
                crc <= crc16(8'h00, crc);
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
                crc <= crc16(8'h83, crc);
            end else begin
                send_byte <= 0;
            end
        end
        // Address: the least significant byte
        8: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= address[7:0];
                state <= 9;
                crc <= crc16(8'h74, crc);
            end else begin
                send_byte <= 0;
            end
        end
        // Address: the most significant byte
        9: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= address[15:8];
                state <= 10;
                crc <= crc16(8'h00, crc);
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
                crc <= crc16(8'h04, crc);
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
                crc <= crc16(8'h00, crc);
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
                crc <= crc16(id1, crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value1: byte 1
        13: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value1[7:0];
                state <= 14;
                crc <= crc16(value1[7:0], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value1: byte 2
        14: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value1[15:8];
                state <= 15;
                crc <= crc16(value1[15:8], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value1: byte 3
        15: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value1[23:16];
                state <= 16;
                crc <= crc16(value1[23:16], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value1: byte 4
        16: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value1[31:24];
                state <= 17;
                crc <= crc16(value1[31:24], crc);
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
                crc <= crc16(id2, crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value2: byte 1
        18: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value2[7:0];
                state <= 19;
                crc <= crc16(value2[7:0], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value2: byte 2
        19: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value2[15:8];
                state <= 20;
                crc <= crc16(value2[15:8], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value2: byte 3
        20: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value2[23:16];
                state <= 21;
                crc <= crc16(value2[23:16], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value2: byte 4
        21: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value2[31:24];
                state <= 22;
                crc <= crc16(value2[31:24], crc);
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
                crc <= crc16(id3, crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value3: byte 1
        23: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value3[7:0];
                state <= 24;
                crc <= crc16(value3[7:0], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value3: byte 2
        24: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value3[15:8];
                state <= 25;
                crc <= crc16(value3[15:8], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value3: byte 3
        25: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value3[23:16];
                state <= 26;
                crc <= crc16(value3[23:16], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value3: byte 4
        26: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value3[31:24];
                state <= 27;
                crc <= crc16(value3[31:24], crc);
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
                crc <= crc16(id4, crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value4: byte 1
        28: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value4[7:0];
                state <= 29;
                crc <= crc16(value4[7:0], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value4: byte 2
        29: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value4[15:8];
                state <= 30;
                crc <= crc16(value4[15:8], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value4: byte 3
        30: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value4[23:16];
                state <= 31;
                crc <= crc16(value4[23:16], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // value4: byte 4
        31: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= value4[31:24];
                state <= 32;
                crc <= crc16(value4[31:24], crc);
            end else begin
                send_byte <= 0;
            end
        end
        // CRC: the least significant byte
        32: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= crc[7:0];
                state <= 33;
            end else begin
                send_byte <= 0;
            end
        end
        // CRC: the most significant byte
        33: begin
            if (done == 1) begin
                send_byte <= 1;
                byte_to_send <= crc[15:8];
                state <= 34;
            end else begin
                send_byte <= 0;
            end
        end
        default: begin
            state <= 0;
            send_byte <= 0;
            crc <= 0;
        end
    endcase
end

endmodule
