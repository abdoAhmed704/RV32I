module hazard_unit_tb();

    // ================= INPUTS =================
    logic [4:0] Rs1E, Rs2E, RdM, RdW;
    logic RegWriteM, RegWriteW;

    logic ResultSrcE_0;
    logic [4:0] RdE;
    logic [4:0] Rs1D, Rs2D;

    logic PCSrcE;

    // ================= OUTPUTS =================
    logic [1:0] ForwardAE, ForwardBE;
    logic FlushE, StallD, StallF, FlushD;

    // ================= DUT =================
    Hazard_Unit dut (
        .Rs1E(Rs1E), .Rs2E(Rs2E), .RdM(RdM), .RdW(RdW),
        .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),

        .ResultSrcE_0(ResultSrcE_0),
        .RdE(RdE),
        .Rs1D(Rs1D), .Rs2D(Rs2D),

        .FlushE(FlushE), .StallD(StallD), .StallF(StallF),
        .PCSrcE(PCSrcE),
        .FlushD(FlushD)
    );

    // ================= HEADER =================
    initial begin
        $display("\n================ HAZARD UNIT DEBUG =================");
        $display("Test | Rs1E Rs2E | RdM RdW | FwdA FwdB | Stall | FlushE | FlushD");
        $display("------------------------------------------------------------------");
    end

    int test_id = 0;

    task run_test;
        begin
            #1;
            $display("%2d   |  %0d    %0d  |  %0d   %0d |  %b    %b  |   %b   |   %b    |   %b",
                test_id,
                Rs1E, Rs2E,
                RdM, RdW,
                ForwardAE, ForwardBE,
                StallD,
                FlushE,
                FlushD
            );
        end
    endtask

    // ================= TESTS =================
    initial begin

        // default
        Rs1E=0; Rs2E=0; RdM=0; RdW=0;
        RegWriteM=0; RegWriteW=0;
        ResultSrcE_0=0;
        RdE=0; Rs1D=0; Rs2D=0;
        PCSrcE=0;

        #1;

        // ========= TEST 1: Forward A from MEM =========
        test_id++;
        Rs1E = 5; Rs2E = 0;
        RdM  = 5; RegWriteM = 1;
        RdW  = 0; RegWriteW = 0;
        run_test();

        // ========= TEST 2: Forward B from MEM =========
        test_id++;
        Rs1E = 0; Rs2E = 6;
        RdM  = 6; RegWriteM = 1;
        run_test();

        // ========= TEST 3: Forward A from WB =========
        test_id++;
        Rs1E = 7; Rs2E = 0;
        RdM  = 0; RegWriteM = 0;
        RdW  = 7; RegWriteW = 1;
        run_test();

        // ========= TEST 4: Forward B from WB =========
        test_id++;
        Rs1E = 0; Rs2E = 8;
        RdW  = 8; RegWriteW = 1;
        run_test();

        // ========= TEST 5: Forward A & B together =========
        test_id++;
        Rs1E = 3; Rs2E = 4;
        RdM  = 3; RegWriteM = 1;
        RdW  = 4; RegWriteW = 1;
        run_test();

        // ========= TEST 6: No forwarding =========
        test_id++;
        Rs1E = 1; Rs2E = 2;
        RdM  = 5; RdW = 6;
        RegWriteM = 1; RegWriteW = 1;
        run_test();

        // ========= TEST 7: Load-use hazard =========
        test_id++;
        ResultSrcE_0 = 1;
        RdE  = 9;
        Rs1D = 9; Rs2D = 0;
        run_test();

        // ========= TEST 8: Branch flush =========
        test_id++;
        ResultSrcE_0 = 0;
        PCSrcE = 1;
        run_test();

        // ========= TEST 9: Load + Branch =========
        test_id++;
        ResultSrcE_0 = 1;
        PCSrcE = 1;
        RdE  = 10;
        Rs1D = 10;
        run_test();

        $display("------------------------------------------------------------------");
        $display("DONE ✅");

        $stop;
    end

endmodule