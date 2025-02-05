module axi4_tb;
    localparam int SZ = 32;
    localparam int DSZ = 8;

    reg _rst;
    reg clk;
    wire out_clk;
    reg [SZ-1:0] a;
    reg [SZ-1:0] b;
    wire [2*SZ-1:0] res;
    // T to master
    wire [DSZ-1:0] tdata_to_master;
    wire tvalid_to_master;
    wire tready_to_master;
    wire tlast_to_master;
    // wire tid_to_master;
    // T to slave
    wire [DSZ-1:0] tdata_to_slave;
    wire tvalid_to_slave;
    wire tready_to_slave;
    wire tlast_to_slave;
    // wire tid_to_slave;



    axi4_stream_master_wrapper #(
        .SZ (SZ),
        .DSZ(DSZ)
    ) master (
        ._rst(_rst),
        .clk(clk),
        .out_clk(out_clk),
        .a(a),
        .b(b),
        .res(res),

        .tdata_to_master (tdata_to_master),
        .tlast_to_master (tlast_to_master),
        .tvalid_to_master(tvalid_to_master),
        .tready_to_master(tready_to_master),
        .tdata_to_slave  (tdata_to_slave),
        .tlast_to_slave  (tlast_to_slave),
        .tvalid_to_slave (tvalid_to_slave),
        .tready_to_slave (tready_to_slave)
    );

    axi4_stream_slave_wrapper #(
        .SZ (SZ),
        .DSZ(DSZ)
    ) slave (
        ._rst(_rst),
        .clk (out_clk),

        .tdata_to_master (tdata_to_master),
        .tlast_to_master (tlast_to_master),
        .tvalid_to_master(tvalid_to_master),
        .tready_to_master(tready_to_master),
        .tdata_to_slave  (tdata_to_slave),
        .tlast_to_slave  (tlast_to_slave),
        .tvalid_to_slave (tvalid_to_slave),
        .tready_to_slave (tready_to_slave)
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
        #256 $finish();
    end

endmodule
