module apb_protocol_tb;
reg clk,rst_n;
wire psel_x;
wire penable;
wire [31:0]paddress;
wire [31:0]data;
wire pwrite;
reg pready;
reg transfer;
reg [31:0]addr;
reg [31:0]w_data;
reg write;

apb_protocol dut(.clk(clk),
                 .rst_n(rst_n),
					  .transfer(transfer),
					  .addr(addr),
					  .w_data(w_data),
					  .write(write),
					  .psel_x(psel_x),
					  .penable(penable),
					  .paddress(paddress),
					  .pwdata(pwdata),
					  .pwrite(pwrite),
					  .pready(pready)
					 );
					 
		initial begin
              clk      = 0;
              rst_n    = 0;
              transfer = 0;
              addr     = 0;
              w_data    = 0;
              write    = 0;
              pready   = 0;
              end
		   always #5 clk = ~clk;
			
		initial begin
		         rst_n=0;
					write=1;
					pready=0;
					#20;
					rst_n=1;
					@(posedge clk)
					transfer<=1;
					addr<=32'h abcd_1234;
					w_data<=32'h face_cafe;
					write=1;
					
					@(posedge clk);
					transfer=0;
					repeat(3)
					@(posedge clk);
					pready=1;
					@(posedge clk);
					pready=0;
					#50;
					$finish;
		end
		endmodule