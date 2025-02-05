`include "src/flags.svh"
module axi4_tb;
    localparam int SZ = 32;
    localparam int DSZ = 8;
    localparam int ASZ = 2;

    reg _rst;
    reg clk;
    wire out_clk;
    reg [SZ-1:0] a;
    reg [SZ-1:0] b;
    wire [2*SZ-1:0] res;
    // AW
    wire [ASZ-1:0] awaddr;
    wire awvalid;
    wire awready;
    // W
    wire [DSZ-1:0] wdata;
    wire wvalid;
    wire wready;
    wire wlast;
    // B
    wire bresp;  // 1 => ok
    wire bvalid;
    wire bready;
    // AR
    wire [ASZ-1:0] araddr;
    wire arvalid;
    wire arready;
    // R
    wire [DSZ-1:0] rdata;
    wire rvalid;
    wire rready;
    wire rlast;
    wire rresp;


    axi4_master_wrapper #(
        .SZ (SZ),
        .DSZ(DSZ),
        .ASZ(ASZ)
    ) master (
        ._rst(_rst),
        .clk(clk),
        .out_clk(out_clk),
        .a(a),
        .b(b),
        .res(res),

        .awaddr (awaddr),
        .awvalid(awvalid),
        .awready(awready),

        .wdata (wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wlast (wlast),

        .bresp (bresp),
        .bvalid(bvalid),
        .bready(bready),

        .araddr (araddr),
        .arvalid(arvalid),
        .arready(arready),

        .rdata (rdata),
        .rvalid(rvalid),
        .rready(rready),
        .rlast (rlast),
        .rresp (rresp)
    );

    axi4_slave_wrapper #(
        .SZ (SZ),
        .DSZ(DSZ),
        .ASZ(ASZ)
    ) slave (
        ._rst(_rst),
        .clk (out_clk),

        .awaddr (awaddr),
        .awvalid(awvalid),
        .awready(awready),

        .wdata (wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wlast (wlast),

        .bresp (bresp),
        .bvalid(bvalid),
        .bready(bready),

        .araddr (araddr),
        .arvalid(arvalid),
        .arready(arready),

        .rdata (rdata),
        .rvalid(rvalid),
        .rready(rready),
        .rlast (rlast),
        .rresp (rresp)
    );

    initial begin
        test_cnt = 0;
        time_sum = 0;
        clk = 0;
        a = 0;
        b = 0;
        _rst = 0;
        forever #1 clk = !clk;
    end

    int  last_stage = 0;
    real time_sum;
    int  test_cnt;
    always @(clk) begin
        if (a * b == res & $time / 100 != last_stage) begin
            $display(a, "*", b, " = ", res);
            $display("calculation done in time ", $time % 100);
            last_stage = $time / 100;
            time_sum   = time_sum + ($time % 100);
            test_cnt   = test_cnt + 1;
        end
    end

    initial begin
`ifdef VERBOSE
        $monitor($time, " | tb | ", a, " * ", b, " => ", res);
`endif
        #100 _rst = 1;  // official start
        a = 10234;
        b = 566;

        #100;

        a = 123124;
        b = 12412;

        #100;

        a = 1234235;
        b = 13156;

        #100;

        a = 537321351;
        b = 24627837;


        #100;

        a = $urandom();
        b = $urandom();

        #100;

        a = $urandom();
        b = $urandom();

        #100;

        a = $urandom();
        b = $urandom();

        #100;

        a = $urandom();
        b = $urandom();


        #100;
        a = $urandom();
        b = $urandom();


        #100;
        a = $urandom();
        b = $urandom();


        #100;
        a = $urandom();
        b = $urandom();


        #100;
        a = $urandom();
        b = $urandom();


        #100;

        $display("avg time : ", time_sum / test_cnt);
        $finish();
    end

endmodule
