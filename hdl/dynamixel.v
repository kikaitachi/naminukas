`include "uart.v"

`define dynamixel_send_byte(BYTE) \
begin \
    if (done == 1) begin \
        send_byte <= 1; \
        byte_to_send <= BYTE; \
        crc <= crc16(BYTE, crc); \
        state <= state + 1; \
    end else begin \
        send_byte <= 0; \
    end \
end

`define dynamixel_send_only_1byte(BYTE) \
begin \
    if (done == 1) begin \
        send_byte <= 1; \
        byte_to_send <= BYTE; \
        crc <= crc16(BYTE, crc); \
        state <= state + 4; \
    end else begin \
        send_byte <= 0; \
    end \
end

`define dynamixel_send_only_2bytes(BYTE) \
begin \
    if (done == 1) begin \
        send_byte <= 1; \
        byte_to_send <= BYTE; \
        crc <= crc16(BYTE, crc); \
        state <= state + 3; \
    end else begin \
        send_byte <= 0; \
    end \
end

`define dynamixel_send_byte_no_crc(BYTE) \
begin \
    if (done == 1) begin \
        send_byte <= 1; \
        byte_to_send <= BYTE; \
        state <= state + 1; \
    end else begin \
        send_byte <= 0; \
    end \
end

// See https://emanual.robotis.com/docs/en/dxl/protocol2/
module dynamixel_sync_write
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
    input[15:0] data_len,
    input[31:0] value1,
    input[31:0] value2,
    input[31:0] value3,
    input[31:0] value4,
    output reg sending,
    inout pin
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
wire done;
reg[7:0] state;
reg[15:0] packet_len;
reg[15:0] crc;

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
    sending = 0;
end

always @(posedge clock)
begin
    case (state)
        // Header
        0: begin
            if (send == 1) begin
                sending <= 1;
                send_byte <= 1;
                byte_to_send <= 8'hFF;
                state <= 1;
                crc <= crc16(8'hFF, crc);
                packet_len <= (data_len + 1) * 4 + 7;
            end
        end
        1: `dynamixel_send_byte(8'hFF)
        2: `dynamixel_send_byte(8'hFD)
        // Reserved
        3: `dynamixel_send_byte(8'h00)
        // Packet ID
        4: `dynamixel_send_byte(8'hFE)  // Broadcast ID
        // Packet length
        5: `dynamixel_send_byte(packet_len[ 7:0])  // The least significant byte
        6: `dynamixel_send_byte(packet_len[15:8])  // the most significant byte
        // Instruction
        7: `dynamixel_send_byte(8'h83)  // Sync Write
        // Address
        8: `dynamixel_send_byte(address[ 7:0])  // The least significant byte
        9: `dynamixel_send_byte(address[15:8])  // The most significant byte
        // Data length
        10: `dynamixel_send_byte(data_len[ 7:0])  // The least significant byte
        11: `dynamixel_send_byte(data_len[15:8])  // The most significant byte
        // 1st device ID
        12: `dynamixel_send_byte(id1)
        // value1
        13: if (data_len == 1) `dynamixel_send_only_1byte(value1[7:0]) else `dynamixel_send_byte(value1[7:0])
        14: if (data_len == 2) `dynamixel_send_only_2bytes(value1[15:8]) else `dynamixel_send_byte(value1[15:8])
        15: `dynamixel_send_byte(value1[23:16])
        16: `dynamixel_send_byte(value1[31:24])
        // 2nd device ID
        17: `dynamixel_send_byte(id2)
        // value2
        18: if (data_len == 1) `dynamixel_send_only_1byte(value2[7:0]) else `dynamixel_send_byte(value2[7:0])
        19: if (data_len == 2) `dynamixel_send_only_2bytes(value2[15:8]) else `dynamixel_send_byte(value2[15:8])
        20: `dynamixel_send_byte(value2[23:16])
        21: `dynamixel_send_byte(value2[31:24])
        // 3rd device ID
        22: `dynamixel_send_byte(id3)
        // value3
        23: if (data_len == 1) `dynamixel_send_only_1byte(value3[7:0]) else `dynamixel_send_byte(value3[7:0])
        24: if (data_len == 2) `dynamixel_send_only_2bytes(value3[15:8]) else `dynamixel_send_byte(value3[15:8])
        25: `dynamixel_send_byte(value3[23:16])
        26: `dynamixel_send_byte(value3[31:24])
        // 4th device ID
        27: `dynamixel_send_byte(id4)
        // value4
        28: if (data_len == 1) `dynamixel_send_only_1byte(value4[7:0]) else `dynamixel_send_byte(value4[7:0])
        29: if (data_len == 2) `dynamixel_send_only_2bytes(value4[15:8]) else `dynamixel_send_byte(value4[15:8])
        30: `dynamixel_send_byte(value4[23:16])
        31: `dynamixel_send_byte(value4[31:24])
        // CRC
        32: `dynamixel_send_byte_no_crc(crc[ 7:0])  // The least significant byte
        33: `dynamixel_send_byte_no_crc(crc[15:8])  // The most significant byte
        default: begin
            if (done == 1) begin
                state <= 0;
                send_byte <= 0;
                crc <= 0;
                sending <= 0;
            end
        end
    endcase
end

endmodule
