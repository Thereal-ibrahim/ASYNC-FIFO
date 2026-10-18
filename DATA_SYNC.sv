module DATA_SYNC
#(
parameter DATA_WIDTH = 8
 )   

 (

input logic CLK1, RST,
input logic [DATA_WIDTH-1:0] DATA_IN,   
output logic [DATA_WIDTH-1:0] DATA_OUT

 );



logic [DATA_WIDTH-1:0] reg1;
logic [DATA_WIDTH-1:0] reg2;




always @(posedge CLK1 or negedge RST) begin
    if (!RST) begin
        reg1 <= '0;
        reg2 <= '0;
    end
    else begin
        reg1 <= DATA_IN;
        reg2 <= reg1;
    end
end

assign DATA_OUT = reg2;



endmodule
