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
        clk = 0;
        a = 0;
        b = 0;
        _rst = 0;
        forever #1 clk = !clk;
    end

    initial begin
        $monitor($time, " | tb | ", a, " * ", b, " => ", res);
        #8 _rst = 1;  // official start
        a = 12551;
        b = 41245;
        #64 $finish();
    end

endmodule
