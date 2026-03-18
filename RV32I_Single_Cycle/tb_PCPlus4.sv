module tb_PCPlus4();

    logic [31:0] PC;
    logic [31:0] PC_Plus_4;

    // Instantiate the PCPlus4 module
    PCPlus4 dut (
        .PC(PC),
        .PC_Plus_4(PC_Plus_4)
    );

    // Test cases
    initial begin
        // Test case 1: PC = 0
        PC = 32'h00000000;
        #10; // Wait for the output to stabilize
        $display("Test Case 1: PC = %h, PC_Plus_4 = %h", PC, PC_Plus_4);

        // Test case 2: PC = 0x00000004
        PC = 32'h00000004;
        #10; // Wait for the output to stabilize
        $display("Test Case 2: PC = %h, PC_Plus_4 = %h", PC, PC_Plus_4);

        // Test case 3: PC = 0xFFFFFFFF
        PC = 32'hFFFFFFFF;
        #10; // Wait for the output to stabilize
        $display("Test Case 3: PC = %h, PC_Plus_4 = %h", PC, PC_Plus_4);

        $stop; // End simulation
    end
endmodule