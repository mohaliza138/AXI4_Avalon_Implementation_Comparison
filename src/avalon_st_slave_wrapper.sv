module avalon_st_slave_wrapper #(
    parameter int SZ = 32
) (
    input _rst,
    input clk
);

    reg [SZ-1:0] areg;
    reg [SZ-1:0] breg;
    reg start;

    wire [2*SZ-1:0] res;
    wire ready;


    mult #(
        .SZ(SZ)
    ) main_module (
        .a(areg),
        .b(breg),
        .res(res),
        .start(start),
        .ready(ready),
        ._rst(_rst),
        .clk(clk)
    );
endmodule
