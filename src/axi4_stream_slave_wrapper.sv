module axi4_stream_slave_wrapper #(
    parameter int SZ  = 32,
    parameter int DSZ = 8
) (
    input _rst,
    input clk,
    // T to master
    output reg [DSZ-1:0] tdata_to_master,
    output reg tvalid_to_master,
    input tready_to_master,
    output reg tlast_to_master,
    // output reg tid_to_master,
    // T to slave
    input [DSZ-1:0] tdata_to_slave,
    input tvalid_to_slave,
    output reg tready_to_slave,
    input tlast_to_slave
    // input tid_to_slave
);

    reg [DSZ-1:0] inregs[2 * (SZ/DSZ)];
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

    reg [7:0] wpos;
    reg [7:0] rpos;

    int i;
    always @(posedge clk, negedge _rst) begin
        if (~_rst) begin
            // zero all regs
            wpos <= 0;
            rpos <= 0;
            for (i = 0; i < 2 * (SZ / DSZ); i = i + 1) begin
                inregs[i] <= 0;
            end
            start <= 1;

            tdata_to_master <= 0;
            tvalid_to_master <= 0;
            tlast_to_master <= 0;

            tready_to_slave <= 1;
            tvalid_to_master <= 1;  // just to start the transmit loop
        end
        else begin
            if (tready_to_slave & tvalid_to_slave) begin
                $display($time, " | slave | ", "rcv tdata : ", tdata_to_slave, " ind : %1d", wpos);
                inregs[wpos] <= tdata_to_slave;
                wpos <= tlast_to_slave ? 0 : wpos + 1;
            end

            if (tready_to_master & tvalid_to_master) begin
                $display($time, " | slave | ", "snd tdata : ", outregs[rpos], " ind : %1d", rpos);
                tdata_to_master <= outregs[rpos];
                rpos <= (rpos + 1) & 7;
                tlast_to_master <= rpos == 7;
            end
        end
    end


endmodule
