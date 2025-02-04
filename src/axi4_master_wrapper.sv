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

    reg [DSZ-1:0] inregs[(1<<ASZ) * (SZ/DSZ)];
    reg start;

    wire [DSZ-1:0] outregs[2*SZ/DSZ];
    wire mulready;

    reg [ASZ-1:0] awaddr_reg;
    reg [ASZ-1:0] araddr_reg;
    reg [7:0] wpos;
    reg [7:0] rpos;
    always @(posedge clk, negedge _rst) begin
        if (~_rst) begin
            // zero all regs
            awready <= 1;  // accept write req
            arready <= 1;  // accept read req
        end
        else begin
            if (awready & awvalid) begin
                awaddr_reg <= awaddr;
                wpos <= awaddr * (SZ / DSZ);
                awready <= 0;  // end addr read
                wready <= 1;  // begin data write
            end
            if (wready & wvalid) begin  // writing
                inregs[wpos] <= wdata;  // write to selected byte of input
                wpos <= wpos + 1;
            end
            if (wready & wvalid & wlast) begin
                wready <= 0;  // end data write
                bresp  <= 1;  // begin write resp
                bvalid <= 1;
            end
            if (bready & bvalid) begin
                bvalid  <= 0;  // end write resp
                awready <= 1;  // begin addr read
            end


            if (arready & arvalid & mulready) begin
                araddr_reg <= araddr;
                arready <= 0;  // end addr read
                rdata <= outregs[0];  // begin data read
                rpos <= 0 + 1;
                rvalid <= 1;
                rresp <= 1;
                rlast <= 0;
            end
            if (rready & rvalid) begin
                rdata <= outregs[rpos];
                rpos  <= rpos + 1;
                rlast <= rpos == (2 * SZ / DSZ - 1);
            end
            if (rready & rvalid & rlast) begin
                rvalid  <= 0;  // end data read
                rdata   <= 0;
                rlast   <= 0;
                rresp   <= 0;
                arready <= 1;  // begin addr read
            end

        end
    end


endmodule
