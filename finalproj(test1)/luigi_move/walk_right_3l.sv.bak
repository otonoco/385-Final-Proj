module WR_3 (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] wr3 [0:831];

    initial
    begin
        $readmemh("mario_wk_3.txt", wr3);
    end


    always_ff @ (posedge Clk) begin

        data_out <= wr3[read_addr];
    end

endmodule