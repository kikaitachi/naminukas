module test_uart();

reg clock;
reg send;
reg [7:0] byte_to_send;
wire done;
wire pin;
wire inverted_pin;

uart
#(
    .clocks_per_bit(1)
)
uart_dut
(
    .clock(clock),
    .send(send),
    .byte_to_send(byte_to_send),
    .done(done),
    .pin(pin)
);

uart
#(
    .clocks_per_bit(1),
    .invert(1)
)
uart_inverted_dut
(
    .clock(clock),
    .send(send),
    .byte_to_send(byte_to_send),
    .done(done),
    .pin(inverted_pin)
);

initial begin
    $monitor("time=%3d, clock=%b, send=%b, done=%2b, pin=%2b, inverted_pin=%2b\n",
        $time, clock, send, done, pin, inverted_pin);
    clock = 1;
    send = 1;
    byte_to_send = 8'b10111001;
    #1
    clock = 0;
    send = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
    #1
    clock = 1;
    #1
    clock = 0;
end

endmodule
