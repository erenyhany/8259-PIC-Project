
module PR(
    input endOfinit,
    input wire [7:0] irr, //CPU haysafar fiha lw el interupt et3amal ????11!!!!!!!!!!!!!!!!!!
    input wire [7:0] IMR, // Interrupt Mask Register (OCW1)
    input wire [7:5] OCW2, // Operation Command Word 2 (7 auto)(5 manual) 
    input imp1,
    input imp2,
    input endOfimp2,
    input OCW2Sent,
    input ICW4, //ICW4[1] 
    input wire [7:3] vector,
    output reg [7:0] datavector, 
    output reg INT
   
    //level,cascade modes
);
    reg [7:0] ISR; 
    reg [7:0] IRR;
    reg myflag =0 ; 

    // Priority modes based on rotate bit (R) and select-level bit (SL) in OCW2
    localparam AUTOMATIC_ROTATING_MODE = 1;
    //EOI
    localparam AUTO_EOI = 1;
  
    

    // register to store the highest priority interrupt in case of rotating priority mode
    reg[7:0] priority_counter = 8'b00000001; 
    // reg[2:0] priority_counter ='b000;
    reg [2:0]index=0;

    // set the interrupt line to 1 if there is an interrupt request that is not masked
    always @(irr or IMR or endOfinit) begin
        IRR = irr & ~IMR ;
        if (IRR != 0 && endOfinit==1 )  INT = 1;
        else INT = 0;
    end

    // set the In-Service Register and reset Interrupt Request Register when the interrupt is acknowledged 
    
    always @(posedge imp1 or posedge myflag  or negedge myflag) begin
        // choose the highest priority based on the priority mode
        if(endOfinit == 1)begin
        if(priority_counter ==0 )priority_counter =1 ; 
          
        if(OCW2[7] == AUTOMATIC_ROTATING_MODE) begin 
            
            if((IRR & priority_counter) != 0 )begin 
              ISR = IRR & priority_counter;
              IRR = IRR & ~ISR;
              priority_counter = priority_counter<<1;
              case(ISR)
                8'b00000001 : index = 0;
                8'b00000010 : index = 1;
                8'b00000100 : index = 2;
                8'b00001000 : index = 3;
                8'b00010000 : index = 4;
                8'b00100000 : index = 5;
                8'b01000000 : index = 6;
                8'b10000000 : index = 7;
                default : ;
              endcase
            end
          else begin 
            priority_counter = priority_counter<<1;
            myflag = myflag + 1;
          end
            
        end


         // choose the highest priority based on the priority mode
        // if(OCW2[7] == AUTOMATIC_ROTATING_MODE) begin 
        // if( IRR[priority_counter] = 1)
        // begin
        //     ISR[priority_counter] = 1;
        //     IRR[priority_counter] = 0;
        //     index = priority_counter;
        //     priority_counter = priority_counter + 1;
        // end
        // else if(IRR[priority_counter+1] = 1)
        // begin
        //     ISR[priority_counter+1] = 1;
        //     IRR[priority_counter+1] = 0;
        //     index = priority_counter+1;
        // end
        //  else if(IRR[priority_counter+2] = 1)
        // begin
        //     ISR[priority_counter+2] = 1;
        //     IRR[priority_counter+2] = 0;
        //     index = priority_counter+1;
        // end
        //  else if(IRR[priority_counter+3] = 1)
        // begin
        //     ISR[priority_counter+3] = 1;
        //     IRR[priority_counter+3] = 0;
        //     index = priority_counter+1;
        // end
        //  else if(IRR[priority_counter+4] = 1)
        // begin
        //     ISR[priority_counter+4] = 1;
        //     IRR[priority_counter+4] = 0;
        //     index = priority_counter+1;
        // end
        //  else if(IRR[priority_counter+1] = 1)
        // begin
        //     ISR[priority_counter+5] = 1;
        //     IRR[priority_counter+5] = 0;
        //     index = priority_counter+1;
        // end
        //  else if(IRR[priority_counter+1] = 1)
        // begin
        //     ISR[priority_counter+1] = 1;
        //     IRR[priority_counter+1] = 0;
        //     index = priority_counter+1;
        // end
        //  else 
        // begin
        //     ISR[priority_counter+1] = 1;
        //     IRR[priority_counter+1] = 0;
        //     index = priority_counter+1;
        // end



        // end

        else begin // fixed priority mode
            ISR =0;
            if(IRR[0] == 1 ) begin
                ISR[0] = 1;
                IRR[0] = 0;
                index=0;
            end
            else if(IRR[1] == 1)  begin
                ISR[1] = 1;
                IRR[1] = 0;
                index=1;
            end
            else if(IRR[2] == 1)  begin
                ISR[2] = 1;
                IRR[2] = 0;
                index=2;
            end
            else if(IRR[3] == 1 )  begin
                ISR[3] = 1;
                IRR[3] = 0;
                index=3;
            end
            else if(IRR[4] == 1 )  begin
                ISR[4] = 1;
                IRR[4] = 0;
                index=4;
            end
            else if(IRR[5] == 1)  begin
                ISR[5] = 1;
                IRR[5] = 0;
                index=5;
            end
            else if(IRR[6] == 1)  begin
                ISR[6] = 1;
                IRR[6] = 0;
                index=6;
            end
            else if(IRR[7] == 1)  begin
                ISR[7] = 1;
                IRR[7] = 0;
                index=7;
            end
        end
    end
        
    end
    always @(posedge imp2)
    begin
      datavector={vector,index};
    end
     
    always@(posedge endOfimp2) 
    begin
      if(ICW4==AUTO_EOI)
      begin
        ISR[index]=0;
      end 
    end
     
    always@(OCW2Sent)begin                       //hane3teber en el cpu haissafar w ye3melha tani le8aiet ma nes2al
      if(ICW4!=AUTO_EOI && OCW2Sent==1 && OCW2[5]==1) 
        ISR[index]=0;

    end
    
   // assign irr=IRR;
  
endmodule










//level w edge trigg mode