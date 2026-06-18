module apb_protocol(input clk,
                    input rst_n,
						  input transfer,
						  input [31:0]addr,
						  input [31:0]w_data,
						  input write,
						  input pready,
						  output reg psel_x,
						  output reg penable,                                       //APB MASTER CODE
						  output reg [31:0]paddress,                               
						  output reg [31:0]pwdata,
						  output reg pwrite
						  
						  );
						  
     parameter idle=2'b00;
	  parameter setup=2'b01;
	  parameter access=2'b10;
	  
	  reg [1:0]current_state,next_state;
	  
	  always@(posedge clk or negedge rst_n)
	    begin
		      if(!rst_n)
				      current_state<=idle;
				else
				      current_state<=next_state;
		 end
	   
		
		
		always@(*)
		  begin
		       case(current_state)
	                  idle:begin 
			                     if(transfer)
						             next_state=setup;
							         else
						             next_state=idle;
									end
							setup:begin
							         next_state=access;
			                  end
					     access:begin
						            if(pready)
										    if(transfer)
											    next_state=setup;
											 else
											    next_state=idle;
				                  else
									    next_state=access;
									end  
	 	        default: next_state=idle;
				  endcase
		  end
		  
		  always@(posedge clk or negedge rst_n)
		    begin
			     if(!rst_n)
				     begin
					     psel_x<=0;
						  penable<=0;
						  paddress<=0;
						  pwdata<=0;
						  pwrite<=0;
					  end
				  else
				    begin
					     case(next_state)
						    idle:begin
							      psel_x<=1'b0;
									penable<=1'b0;
							      end
							 setup:begin
							       psel_x<=1'b1;
									 penable<=1'b0;
									 paddress<=addr;
									 pwdata<=w_data;
									 pwrite<=write;
							       end
							 access:begin
							        psel_x<=1'b1;
									  penable<=1'b1;
							        end
							endcase
					 end
			 end
endmodule