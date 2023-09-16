module asyn_inter_A  #(
//parameter
parameter DONE_BTA_D   = 4,
parameter NUM_SYNC_A   = 2,
parameter NUM_DELAY_A  = 2,
parameter SUM_A        = NUM_SYNC_A+NUM_DELAY_A
)(
//input
input   clk_A,
input   rst_n_A,
input   start_A,
input   done_BtA,  //fro, clock B, level
//output
output  reg start_AtB,
output  reg done_1_A
);
reg     [SUM_A-1:0]      done_sync_A   ;
wire                     done_BTA      ;
reg     [DONE_BTA_D-1:0] done_BTA_d    ;

//receive done_BtA ,become done_sync_A,get done_sync_A
always @(posedge clk_A  or negedge rst_n_A) begin
  if(~rst_n_A) begin//reset
    done_sync_A <= {SUM_A{1'b0}};
  end
  else begin  
    done_sync_A <= {done_sync_A[SUM_A-2:0],done_BtA};
  end
end

//A's start send to , pulse->level to ensure it's long enough and can be
//sampled by clock B
always @(posedge clk_A  or negedge rst_n_A) begin
  if(~rst_n_A) begin//reset
    start_AtB <= 1'b0;  
  end
  else if(start_A)begin  
    start_AtB <= 1'b1;
  end
  else if(done_BTA)begin
    start_AtB <= 1'b0;
  end
end

//after receive the signal of done_BtA,the preparation of pulling up start_A
always @(posedge clk_A  or negedge rst_n_A) begin
  if(~rst_n_A)begin
    done_BTA_d <= {DONE_BTA_D{1'b0}};
  end
  else begin
    done_BTA_d <= {done_BTA_d[DONE_BTA_D-2:0],done_BTA};
  end
end

assign done_BTA = (done_sync_A[NUM_DELAY_A-1])&(~done_sync_A[NUM_DELAY_A]);

always @(posedge clk_A  or negedge rst_n_A) begin
  if(~rst_n_A)begin
    done_1_A <= 1'b0;
  end
  else if(done_BTA_d[DONE_BTA_D-1])begin
    done_1_A <= 1'b1;
  end
  else begin
    done_1_A <= 1'b0;
  end
end
endmodule
