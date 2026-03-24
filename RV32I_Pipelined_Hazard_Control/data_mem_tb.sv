module data_mem_tb;

    // Parameters
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 12; // 4KB memory requires 12 bits for addressing
    localparam MEM_SIZE = 4096; // 4KB memory

    // Test signals
    reg clk;
    reg we;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] write_data;
    wire [DATA_WIDTH-1:0] read_data;

    // Instantiate DUT
    data_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEM_SIZE(MEM_SIZE)
    ) dut (
        .clk(clk),
        .WriteEnable(we),
        .Address(addr),
        .WriteData(write_data),
        .ReadData(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        we = 0;
        addr = 0;
        write_data = 0;

        // Write test
        #10;
        we = 1;
        addr = 10'd0;
        write_data = 32'hDEADBEEF;
        #10;

        addr = 10'd4;
        write_data = 32'hCAFECAFE;
        #10;

        // Read test
        we = 0;
        addr = 10'd0;
        #10;
        $display("Read from addr 0x0: %h (expected: DEADBEEF)", read_data);

        addr = 10'd4;
        #10;
        $display("Read from addr 0x4: %h (expected: CAFECAFE)", read_data);

        #10 $finish;
    end

endmodule