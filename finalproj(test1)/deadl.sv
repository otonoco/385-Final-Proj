module DEADL (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] dead [0:831];

    initial
    begin
        $readmemh("luigi_dd.txt", dead);
    end


    always_ff @ (posedge Clk) begin

        data_out <= dead[read_addr];
    end

endmodule