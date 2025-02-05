`include "src/flags.svh"
module avalon_st_tb;
    localparam int SZ = 32;
    localparam int DSZ = 8;
    localparam int ASZ = 2;

    reg _rst;
    reg clk;
    wire out_clk;
    reg [SZ-1:0] a;
    reg [SZ-1:0] b;
    wire [2*SZ-1:0] res;
    // avalon
    wire startofpacket_to_master;
    wire endofpacket_to_master;
    wire [7:0] data_to_master;
    wire ready_to_master;
    wire valid_to_master;

    wire startofpacket_to_slave;
    wire endofpacket_to_slave;
    wire [7:0] data_to_slave;
    wire ready_to_slave;
    wire valid_to_slave;
    wire result_is_ready;


    avalon_st_master_wrapper master (
        ._rst(_rst),
        .clk(clk),
        .out_clk(out_clk),
        .A(a),
        .B(b),
        .RES(res),
        .ready_res(Result_is_ready),

        .startofpacket_in(startofpacket_to_master),
        .startofpacket_out(startofpacket_to_slave),
        .endofpacket_in(endofpacket_to_master),
        .endofpacket_out(endofpacket_to_slave),
        .data_in(data_to_master),
        .data_out(data_to_slave),
        .ready_in(ready_to_master),
        .ready_out(ready_to_slave),
        .valid_in(valid_to_master),
        .valid_out(valid_to_slave)
    );

    avalon_st_slave_wrapper slave (
        ._rst(_rst),
        .clk (out_clk),

        .startofpacket_out(startofpacket_to_master),
        .startofpacket_in(startofpacket_to_slave),
        .endofpacket_out(endofpacket_to_master),
        .endofpacket_in(endofpacket_to_slave),
        .data_out(data_to_master),
        .data_in(data_to_slave),
        .ready_out(ready_to_master),
        .ready_in(ready_to_slave),
        .valid_out(valid_to_master),
        .valid_in(valid_to_slave)
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
