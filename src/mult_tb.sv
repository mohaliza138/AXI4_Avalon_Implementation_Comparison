module mult_tb;
    reg [31:0] a, b;
    reg _rst, clk, start;
    wire [63:0] res;
    wire ready;

    mult _mult (
        .a(a),
        .b(b),
        .res(res),
        .ready(ready),
        .start(start),
        ._rst(_rst),
        .clk(clk)
    );
    initial begin
        $monitor($time, " | ", a, " * ", b, " => ", ready, " , ", res);
        clk  = 0;
        _rst = 1;
        #1 clk = !clk;
        _rst = 0;
        a = 12;
        b = 7;
        start = 1;
        #1 clk = !clk;
        start = 0;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;
        #1 clk = !clk;

    end
endmodule
