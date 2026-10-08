module DATA_SYNC
#(
parameter DATA_WIDTH = 8,
 )   

 (

input logic CLK1,CLK2, RST,
input logic [DATA_WIDTH-1:0] DATA_IN,   
output logic [DATA_WIDTH-1:0] DATA_OUT

 );



logic [DATA_WIDTH-1:0] reg1;
logic [DATA_WIDTH-1:0] reg2;
logic [DATA_WIDTH-1:0] reg3;


always @(posedge CLK1 or negedge RST) begin 

   if (!RST) begin

        reg1 <= '0;
    end
    else begin
        reg1 <= DATA_IN;
    end
        
   end



always @(posedge CLK2 or negedge RST) begin 

   if (!RST) begin

        reg2 <= '0;
    end
    else begin
        reg2 <= reg1;
        reg3 <= reg2;
    end
        
   end


assign DATA_OUT = reg3;



endmodule






endmodule