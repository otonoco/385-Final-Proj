module gomba_r (
        input [18:0] read_addr,
        input Clk,

        output logic [23:0] data_out
);

    logic [23:0] gr [0:1023];

    initial
    begin
        $readmemh("gomba_right.txt", gr);
    end


    always_ff @ (posedge Clk) 
    begin
        data_out <= gr[read_addr];
    end

endmodule