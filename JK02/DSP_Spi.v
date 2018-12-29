module DSP_Spi(input n_rst,input SPI2_CLK);

reg[4:0] SPICNT;						//MAX is 16 bit

always@(posedge SPI2_CLK or negedge n_rst)//来自内部PLL复位;SPI is MSB
begin
	if(!n_rst)
	begin
		SPICNT	<= 5'd0;
	end
	else
	begin
		if(SPICNT < 5'd15)
			SPICNT	<= SPICNT + 8'd1;
		else
			SPICNT	<= 8'd0;
	end
	
	
end


endmodule
