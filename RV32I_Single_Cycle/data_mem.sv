module data_mem #(
    parameter DATA_WIDTH = 32, // Width of data
    parameter ADDR_WIDTH = 12, 
    parameter MEM_SIZE = 4096 
)(
    input clk,
    input WriteEnable,
    input [DATA_WIDTH-1:0] WriteData,
    input [ADDR_WIDTH-1:0] Address,
    output reg [DATA_WIDTH-1:0] ReadData
);
    // Memory declaration
    reg [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1]; // MEM_SIZE words of DATA_WIDTH bits each

    always @(posedge clk) begin
        if (WriteEnable) begin
            memory[Address[ADDR_WIDTH-1:0]] = WriteData; // Write data to memory
        end else begin
            ReadData = memory[Address[ADDR_WIDTH-1:0]]; // Read data from memory
        end
    end
endmodule