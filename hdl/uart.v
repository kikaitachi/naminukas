module uart
#(
    parameter clocks_per_bit = 1,
    parameter invert = 0
)
(
    input clock,
    input send,
    input[7:0] byte_to_send,
    output reg done,
    output reg pin
);

reg sending;
reg [3:0] bit_index;
reg[$clog2(clocks_per_bit):0] clocks;

initial begin
    sending = 0;
end

localparam last_clock = clocks_per_bit - 1;

always @(posedge clock)
begin
    if (sending) begin
        if (clocks == last_clock[$clog2(clocks_per_bit):0]) begin
            if (bit_index == 9) begin
                done <= 1;
                sending <= 0;
            end else if (bit_index == 8) begin
                pin <= invert == 1 ? 0 : 1;
            end else begin
                pin <= invert == 1 ? ~byte_to_send[bit_index[2:0]] : byte_to_send[bit_index[2:0]];
            end
            clocks <= 0;
            bit_index <= bit_index + 1;
        end else begin
            clocks <= clocks + 1;
        end
    end else if (send) begin
        sending <= 1;
        done <= 0;
        bit_index <= 0;
        pin <= invert == 1 ? 1 : 0;
        clocks <= 0;
    end else begin
        done <= 0;
    end
end

endmodule
