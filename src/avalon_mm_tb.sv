module avalon_mm_tb;
    localparam int SZ = 32;
    localparam int DSZ = 8;
    localparam int ASZ = 2;

    reg _rst;
    reg clk;
    wire out_clk;
    wire [3:0]addr;
    reg [SZ-1:0] a;
    reg [SZ-1:0] b;
    wire [2*SZ-1:0] res;
    // avalon
    wire read_to_slave;
    wire write_to_slave;
    wire [15:0]write_data;
    wire [15:0]read_data;

    avalon_mm_master_wrapper master (
        ._rst(_rst),
        .clk(clk),
        .out_clk(out_clk),
        .A(a),
        .B(b),
        .res(res),

        .read_data(read_data),
        .addr(addr),
        .read(read_to_slave),
        .write(write_to_slave),
        .write_data(write_data)
    );

    avalon_mm_slave_wrapper slave (
        ._rst(_rst),
        .clk (out_clk),

        .addr(addr),
        .read(read_to_slave),
        .write(write_to_slave),
        .write_data(write_data),
        .read_data(read_data)
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
        a = 10234;
        b = 566;
        
        #100;
        
        a = 32;
        b = 12;
        
        #100;
        
        $stop();
    end

endmodule
