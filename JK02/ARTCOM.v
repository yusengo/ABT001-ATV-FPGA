/*
##############################################
#        炬远智能科技（上海）有限公司
##############################################
#			版权所有	侵权必究
#			yusengo@163.com
20180707
*/
//AVT PC104
module ARTCOM(input clk_100M, input n_rst, input [9:0] artAddr, inout [7:0] artData, input artWR, input artRD,output artDIR,output reg [15:0] comVolt);

reg voltHLarrFlag;
reg[7:0] voltL;

wire enAutoVolt;

assign enAutoVolt = ((artAddr[9:0] == 10'h324)|(artAddr[9:0] == 10'h325));
assign artDIR  = (enAutoVolt && artWR && (!artRD)) ? 1'd0  : 1'd1;
assign artData = (enAutoVolt && artWR && (!artRD)) ? comVolt[7:0] : {8{1'bz}};

always@(negedge artWR or negedge n_rst)
begin
	if(!n_rst)
	begin
		voltHLarrFlag <= 1'd0;
	end
	else
	begin
		if(artRD == 1'd1)
		begin
			if((artAddr[9:0] == 10'h324))
			begin
				voltHLarrFlag <= voltHLarrFlag + 1'd1;
				voltL[7:0]	  <= artData[7:0];
			end
			else
			begin
				if((artAddr[9:0] == 10'h325) && (voltHLarrFlag == 1'd1))
				begin
					comVolt[15:0] <= {artData[7:0],voltL[7:0]};
					voltHLarrFlag <= 1'd0;
				end
			end
		end
	end
end

endmodule
