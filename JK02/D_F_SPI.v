/*
##############################################
#        炬远智能科技（上海）有限公司
##############################################
20180530
1. DSP_SPI_EN 必须有效使能，后续改
*/

module D_F_SPI(input clk_100M,input n_rst,input DSP_SPI_EN,input DSP_SPI_CLK,input DSP_SPI_DFIN,input [15:0] ADC_VALUE,input [15:0] comVolt,output reg Ready,output reg[15:0] CMD_OUT,output reg[15:0] DAC_VALUE,output reg DSP_SPI_FDOUT);

reg[4:0] SPICNT;						//MAX is 32 bit
reg[4:0] ReadyValidCNT;
reg ReadyStatusLocked;
reg[31:0] frameGet;
reg[1:0] StateMSPI;
reg[15:0] UP_LOCKED;
reg posFlag;

always@(negedge DSP_SPI_CLK or negedge n_rst)//pos update ADC data
begin
	if(!n_rst)
		begin
			SPICNT	<= 5'd0;
		end
	else
		begin
			if(DSP_SPI_EN == 1'd0)
				begin
					if(SPICNT < 5'd31)
						begin
							if(SPICNT == 5'd15)
							begin
								case({frameGet[14:0],DSP_SPI_DFIN})
									16'd10:UP_LOCKED[15:0] <= comVolt[15:0];
									16'd1 :UP_LOCKED[15:0] <= ADC_VALUE[15:0];
									default:;
								endcase	
							end
							
							SPICNT	<= SPICNT + 5'd1;
							frameGet[31:0] <= {frameGet[30:0],DSP_SPI_DFIN};
						end
					else
						begin
							SPICNT	<= 5'd0;
							frameGet[31:0] <= {frameGet[30:0],DSP_SPI_DFIN};
						end
				end
			else
				begin
					SPICNT	<= 5'd0;
				end
		end
end

always@(posedge DSP_SPI_CLK or negedge n_rst)//pos update ADC data
begin
	if(!n_rst)
		begin
			DSP_SPI_FDOUT <= 1'd0;
		end
	else
		begin
			if(DSP_SPI_EN == 1'd0)
				if(SPICNT > 5'd15)
					begin
						DSP_SPI_FDOUT <= (UP_LOCKED>>(5'd31 - SPICNT));
					end
				else
					begin
						DSP_SPI_FDOUT <= 1'd0; 
					end
			else
				begin
					DSP_SPI_FDOUT <= 1'd0;
				end
		end
end

always@(posedge clk_100M or negedge n_rst)
begin
	if(!n_rst)
		begin
			Ready	<= 1'd0;
			CMD_OUT[15:0] <= 16'd0;
			DAC_VALUE[15:0] <= 16'd0;	
			ReadyValidCNT <= 5'd0;
			ReadyStatusLocked <= 1'd0;
		end
	else
		begin
			if(SPICNT == 5'd0)
				begin
				if((ReadyValidCNT > 5'd2)&&(ReadyValidCNT < 5'd20)&&(ReadyStatusLocked == 1'd0))
					begin
						ReadyValidCNT <= ReadyValidCNT + 5'd1;
						Ready	<= 1'd1;
						CMD_OUT[15:0] <= frameGet[31:16];
						DAC_VALUE[15:0] <= frameGet[15:0];
						
						if(ReadyValidCNT > 5'd18)
							begin
								ReadyStatusLocked <= 1'd1;
							end
						else
							begin
								ReadyStatusLocked <= 1'd0;
							end
					end
				else
					begin
						Ready <= 1'd0;
						ReadyValidCNT <= ReadyValidCNT + 5'd1;
					end
				end
			else
				begin
					Ready <= 1'd0;
					ReadyValidCNT <= 5'd0;
					ReadyStatusLocked <= 1'd0;
				end
		end
end

endmodule
