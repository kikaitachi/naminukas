module uart
#(
    parameter clocks_per_bit = 1
)
(
    input clock,
    input send,
    input[7:0] byte_to_send,
    output done,
    output pin
);

reg sending;
reg [3:0] bit_index;
reg[$clog2(clocks_per_bit):0] clocks;

initial begin
    sending = 0;
end

always @(posedge clock)
begin
    if (sending) begin
        if (clocks == clocks_per_bit - 1) begin
            if (bit_index == 9) begin
                done <= 1;
                sending <= 0;
            end else if (bit_index == 8) begin
                pin <= 1;
            end else begin
                pin <= byte_to_send[bit_index[2:0]];
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
        pin <= 0;
        clocks <= 0;
    end else begin
        done <= 0;
    end
end

endmodule
