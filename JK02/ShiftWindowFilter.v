module ShiftWindowFilter(input clk_100M, input n_rst, input [9:0] rawAddr, output reg [9:0] fineAddr);

always@(posedge clk_100M or negedge n_rst)
begin
	if(!n_rst)
	begin
		fineAddr[9:0] = 10'd1;
	end
	else
	begin
		if(rawAddr[9:8] == 2'd0)
		begin
			fineAddr[9:0] = fineAddr[9:0];
		end
		else
		begin
			fineAddr[9:0] = rawAddr[9:0];
		end
	end
end

endmodule
