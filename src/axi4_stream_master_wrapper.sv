module axi4_stream_master_wrapper #(
    parameter int SZ  = 32,
    parameter int DSZ = 8
) (
    input _rst,
    input clk,
    output out_clk,
    input [SZ-1:0] a,
    input [SZ-1:0] b,
    output [2*SZ-1:0] res,
    // T to master
    input [DSZ-1:0] tdata_to_master,
    input tvalid_to_master,
    output reg tready_to_master,
    input tlast_to_master,
    // input tid_to_master,
    // T to slave
    output reg [DSZ-1:0] tdata_to_slave,
    output reg tvalid_to_slave,
    input tready_to_slave,
    output reg tlast_to_slave
    // output reg tid_to_slave
);
    assign out_clk = clk;

    wire [DSZ-1:0] outregs[(2) * (SZ / DSZ)];
    assign outregs[0] = a[7:0];
    assign outregs[1] = a[15:8];
    assign outregs[2] = a[23:16];
    assign outregs[3] = a[31:24];
    assign outregs[4] = b[7:0];
    assign outregs[5] = b[15:8];
    assign outregs[6] = b[23:16];
    assign outregs[7] = b[31:24];

    reg [DSZ-1:0] inregs[2 * SZ / DSZ];
    assign res = {
        inregs[7], inregs[6], inregs[5], inregs[4], inregs[3], inregs[2], inregs[1], inregs[0]
    };


    reg [7:0] wpos;
    reg [7:0] rpos;
    int i;
    always @(posedge clk, negedge _rst) begin
        if (~_rst) begin
            for (i = 0; i < 2 * SZ / DSZ; i = i + 1) begin
                inregs[i] <= 0;
            end
            wpos <= 0;
            rpos <= 0;

            tdata_to_slave <= 0;
            tvalid_to_slave <= 0;
            tlast_to_slave <= 0;

            tready_to_master <= 1;
            tvalid_to_slave <= 1;  // just to start the transmit loop
        end
        else begin
            if (tready_to_master & tvalid_to_master) begin
                $display($time, " | master | ", "rcv tdata : ", tdata_to_master, " ind : %1d",
                         wpos);
                inregs[wpos] <= tdata_to_master;
                wpos <= tlast_to_master ? 0 : wpos + 1;
                if (wpos == 0) $display($time, " | master | ", "res : ", res);
            end

            if (tready_to_slave & tvalid_to_slave) begin
                $display($time, " | master | ", "snd tdata : ", outregs[rpos], " ind : %1d", rpos);
                tdata_to_slave <= outregs[rpos];
                rpos <= (rpos + 1) & 7;
                tlast_to_slave <= rpos == 7;
            end

        end
    end


endmodule
