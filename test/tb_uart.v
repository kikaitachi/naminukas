module test_uart();

reg clock;
reg send;
reg [7:0] byte_to_send;
wire done;
wire pin;

uart
#(
    .clocks_per_bit(3)
)
uart_dut
(
    .clock(clock),
    .send(send),
    .byte_to_send(byte_to_send),
    .done(done),
    .pin(pin)
);

initial begin
    $monitor("time=%3d, clock=%b, dend=%b, done=%2b, pin=%2b\n",
        $time, clock, send, done, pin);
    clock = 1;
    send = 1;
    byte_to_send = 8'b10111001;
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
end

endmodule
