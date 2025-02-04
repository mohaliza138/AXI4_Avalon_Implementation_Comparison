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
    wire mulready;


    mult #(
        .SZ(SZ)
    ) main_module (
        .a({inregs[3], inregs[2], inregs[1], inregs[0]}),
        .b({inregs[7], inregs[6], inregs[5], inregs[4]}),
        .res({
            outregs[7],
            outregs[6],
            outregs[5],
            outregs[4],
            outregs[3],
            outregs[2],
            outregs[1],
            outregs[0]
        }),
        .start(start),
        .ready(mulready),
        ._rst(_rst),
        .clk(clk)
    );

    reg [ASZ-1:0] awaddr_reg;
    reg [ASZ-1:0] araddr_reg;
    reg [7:0] wpos;
    reg [7:0] rpos;

    int i;
    always @(posedge clk, negedge _rst) begin
        if (~_rst) begin
            // zero all regs
            wpos <= 0;
            rpos <= 0;
            awaddr_reg <= 0;
            araddr_reg <= 0;
            for (i = 0; i < (1 << ASZ) * (SZ / DSZ); i = i + 1) begin
                inregs[i] <= 0;
            end
            start   <= 1;

            wready  <= 0;
            bresp   <= 0;
            bvalid  <= 0;
            rdata   <= 0;
            rvalid  <= 0;
            rlast   <= 0;
            rresp   <= 0;


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
