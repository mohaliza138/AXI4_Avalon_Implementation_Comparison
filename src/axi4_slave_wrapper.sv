module axi4_slave_wrapper #(
    parameter int SZ  = 32,
    parameter int ASZ = 2,
    parameter int DSZ = 8
) (
    input _rst,
    input clk,
    // AW
    input [ASZ-1:0] awaddr,
    input awvalid,
    output reg awready,
    // W
    input [DSZ-1:0] wdata,
    input wvalid,
    output reg wready,
    input wlast,
    // B
    output reg bresp,  // 1 => ok
    output reg bvalid,
    input bready,
    // AR
    input [ASZ-1:0] araddr,
    input arvalid,
    output reg arready,
    // R
    output reg [DSZ-1:0] rdata,
    output reg rvalid,
    input rready,
    output reg rlast,
    output reg rresp  // 1 => ok
);

    reg [DSZ-1:0] inregs[(1<<ASZ) * (SZ/DSZ)];
    reg start;

    wire [DSZ-1:0] outregs[2*SZ/DSZ];
    wire ready;


    mult #(
        .SZ(SZ)
    ) main_module (
        .a({inregs[3], inregs[2], inregs[1], inregs[0]}),
        .b({inregs[7], inregs[6], inregs[5], inregs[4]}),
        .res(res),
        .start(start),
        .ready(ready),
        ._rst(_rst),
        .clk(clk)
    );

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
                awready <= 0;  // end addr reading
                wready <= 1;  // begin data reading
            end
            if (wready & wvalid) begin  // writing
                inregs[wpos] <= wdata;  // write to selected byte of input
                wpos <= wpos + 1;
            end
            if (wready & wvalid & wlast) begin
                wready <= 0;
                bresp  <= 1;
                bvalid <= 1;
            end
            if (bready & bvalid) begin
                bvalid  <= 0;
                awready <= 1;
            end


            if (arready & arvalid) araddr_reg <= araddr;

        end
    end


endmodule
