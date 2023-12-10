module RWModule (input rd ,wr,A0,CS ,inout [7:0]D ,output reg[7:0]datatologic,reg[4:1]ICWs);
  reg [2:0]icwCounter=0;
  parameter icw1 = 1 , icw2 = 2 ,icw3=3 , icw4=4;
  reg [4:1]icflag= 4'b1111; 
  always@(wr)begin
    if(~wr && ~cs)begin
    if(icflag != 0 )begin
      
      ICWs = 0;
      if(A0 == 0 && D[4]==1 && icflag[icw1]==1)begin
        datatologic = D;
        ICWs[icw1]=1;
        icflag[icw1] = 0;
        icflag[icw4] = D[0];
        icflag[icw3] = ~D[1];
      end
    else if (A0 == 1 )begin
        if(icflag[icw2:icw1]==2'b10)begin
          datatologic = D;
          ICWs[icw2] = 1;
          icflag[icw2] = 0;
        end 
        else if(icflag[icw3 :icw1]==3'b100)begin
          datatologic = D;
          ICWs[icw3] = 1;
          icflag[icw3] = 0;
        end
        else if(icflag[icw4 :icw1]==3'b100)begin
          datatologic = D;
          ICWs[icw4] = 1;
          icflag[icw4] = 0;
        end
        end 
      end
    end
    
    
  end
  
  endmodule

