module register_file(A1, A3, WD3, en, clk, RD1);

input [4:0] A1, A3;
input [31:0] WD3;
input en, clk;
output reg [31:0] RD1;


reg [31:0] registers [31:0];

always @(posedge clk) begin
    if (en)begin
        RD1 <= registers[A1];
        registers[A3] <= WD3;
    end
end

endmodule