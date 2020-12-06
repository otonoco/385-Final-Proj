module BACKGROUND (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] background [0:2047];

    initial
    begin
        $readmemh("ground.txt", background);
    end


    always_ff @ (posedge Clk) begin

        data_out <= background[read_addr];
    end

endmodule