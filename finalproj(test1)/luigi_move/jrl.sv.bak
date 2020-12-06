module JR (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] jump [0:831];

    initial
    begin
        $readmemh("mario_jp.txt",jump);
    end


    always_ff @ (posedge Clk) begin

        data_out <= jump[read_addr];
    end

endmodule