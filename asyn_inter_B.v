//                            ALL RIGHTS RESERVED
//
//  This software and the associated documentation are confidential and
//  proprietary to XXXXX.  Your use or disclosure of this
//  software is subject to the terms and conditions of a written
//  license agreement between you, or your company, and XXXXX.
//
// The entire notice above must be reproduced on all authorized copies.
//
// Component Name   : asyn_inter_B.v
// Component Version:
// Release Type     :
//--------------------------------------------------------------------------
//  Function:Complete the handshake across clock domains(clk B)
//  
//  application:
//  interaction between different clock domains
//  cycle delay: 
//--------------------------------------------------------------------------
//      Revision and Modification History:
//
//  Revision- Date       - Author     - Description
//  V0.0    - 2023-07-31 - xxxxxxxx   - First relase
//
//--------------------------------------------------------------------------
module asyn_inter_B  #(
parameter NUM_SYNC_B   = 2                     ,
parameter NUM_DELAY_B  = 2                     ,
parameter SUM_B        = NUM_SYNC_B+NUM_DELAY_B,
parameter START_B_D    = 10
)(
input  clk_B       ,
input  rst_n_B     ,
input  start_AtB   ,//from,clk A,level
output reg done_BtA,
output reg done_B
);
reg    [SUM_B-1:0]    sync_start_B;
wire                  start_B     ;
reg    [START_B_D-1:0]start_B_d   ;

//receive start_AtB,become sync_start_B,get sync_start_B
always @(posedge clk_B  or negedge rst_n_B) begin
  if(~rst_n_B) begin//reset
    sync_start_B <= {SUM_B{1'b0}};
  end
  else begin  
    sync_start_B <= {sync_start_B[SUM_B-2:0],start_AtB};
  end
end
assign start_B = (sync_start_B[NUM_DELAY_B-1])&(~sync_start_B[NUM_DELAY_B]);

//the cycles of the B module calculation
always @(posedge clk_B  or negedge rst_n_B) begin
  if(~rst_n_B) begin//reset
    start_B_d <= {START_B_D{1'b0}};
  end
  else begin  
    start_B_d <= {start_B_d[START_B_D-2:0],start_B};
  end
end

//the calculation process of module B
always @(posedge clk_B  or negedge rst_n_B) begin
  if(~rst_n_B) begin//reset
    done_B <= 1'b0;
  end
  else if(start_B_d[START_B_D-1]) begin   
    done_B <= 1'b1;
  end
  else begin
    done_B <=1'b0;
  end
end

////B's done signal send to A , pulse->level to ensure it's long enough and can be
//sampled by clock A
always @(posedge clk_B  or negedge rst_n_B) begin
  if(~rst_n_B) begin//reset 
    done_BtA <= 1'b0;
  end
  else if(done_B) begin   
    done_BtA <= 1'b1;
  end
  else if(start_B)begin
    done_BtA <= 1'b0;
  end
end
endmodule
