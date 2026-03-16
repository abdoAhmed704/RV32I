`timescale 1ns/1ps

module register_file_tb;

reg [4:0] A1, A2, A3;
reg [31:0] WD3;
reg w_en;
reg clk;

wire [31:0] RD1, RD2;

register_file uut (
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WD3(WD3),
    .w_en(w_en),
    .clk(clk),
    .RD1(RD1),
    .RD2(RD2)
);

// clock
always #5 clk = ~clk;

initial begin

    clk = 0;
    w_en = 0;
    A1 = 0;
    A2 = 0;
    A3 = 0;
    WD3 = 0;

    $display("===== Register File Test Start =====");

    #10;

    // write register 5
    $display("Writing DEADBEEF to register 5");
    w_en = 1;
    A3 = 5;
    WD3 = 32'hDEADBEEF;

    #10;

    // read register 5
    w_en = 0;
    A1 = 5;
    A2 = 5;

    #2;
    $display("Read R5 -> RD1 = %h , RD2 = %h", RD1, RD2);

    #10;

    // write register 10
    $display("Writing 12345678 to register 10");
    w_en = 1;
    A3 = 10;
    WD3 = 32'h12345678;

    #10;

    // read registers
    w_en = 0;
    A1 = 10;
    A2 = 5;

    #2;
    $display("Read R10 -> RD1 = %h", RD1);
    $display("Read R5  -> RD2 = %h", RD2);

    #10;

    $display("===== Test Finished =====");

    $finish;

end

endmodule