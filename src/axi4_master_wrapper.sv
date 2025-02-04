module axi4_master_wrapper #(
    parameter int SZ  = 32,
    parameter int ASZ = 2,
    parameter int DSZ = 8
) (
    input _rst,
    input clk,
    output out_clk,
    input [SZ-1:0] a,
    input [SZ-1:0] b,
    output [2*SZ-1:0] res,
    // AW
    output reg [ASZ-1:0] awaddr,
    output reg awvalid,
    input awready,
    // W
    output reg [DSZ-1:0] wdata,
    output reg wvalid,
    input wready,
    output reg wlast,
    // B
    input bresp,  // 1 => ok
    input bvalid,
    output reg bready,
    // AR
    output reg [ASZ-1:0] araddr,
    output reg arvalid,
    input arready,
    // R
    input [DSZ-1:0] rdata,
    input rvalid,
    output reg rready,
    input rlast,
    input rresp  // 1 => ok
);
    assign out_clk = clk;

    wire [DSZ-1:0] outregs[(2) * (SZ / DSZ)];
    assign outregs = {a[7:0], a[15:8], a[23:16], a[31:24], b[7:0], b[15:8], b[23:16], b[31:24]};


    reg [7:0] wpos;
    always @(posedge clk, negedge _rst) begin
        if (~_rst) begin
            // setup data write
            awaddr  <= 0;
            awvalid <= 1;
        end
        else begin

            if (awvalid & awready) begin
                awvalid <= 0;
                wdata   <= outregs[awaddr * 4];
                wpos    <= awaddr * 4 + 1;
                wvalid  <= 1;
                wlast   <= 0;
            end
            if (wvalid & wready) begin
                wdata <= outregs[wpos];
                wpos  <= wpos + 1;
                wlast <= ((wpos & 3) == 2);
            end
            if (wvalid & wready & wlast) begin
                wvalid <= 0;
                wlast  <= 0;
                wdata  <= 0;
                bready <= 1;
            end
            if (bready & bvalid) begin
                bready  <= 0;
                awvalid <= 1;
                awaddr  <= (awaddr + 1) & 1;
            end
        end
    end


endmodule
