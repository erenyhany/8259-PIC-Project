
module PR(
    input endOfinit,A0,read,
    input wire [7:0] irr, 
    input wire [7:0] IMR, // Interrupt Mask Register (OCW1)
    input wire [7:5] OCW2, // Operation Command Word 2 (7 auto)(5 manual) 
    input wire [1:0] RR_RIS,
    input imp1,
    input imp2,
    input endOfimp2,
    input endOfimp1,
    input OCW2Sent,
    input ICW4, //ICW4[1] 
    input wire [7:3] vector,
    output wire INT,
    output reg [7:0]isrOrirrOrimrToRWModuleOrdatavector ,
    input [2:0] CASin,output [2:0] CASout ,//cascading lines
    input en, //single enable, master=1,slave=0
    input SNGL, //ICW1[1]
    input [7:0]ICW3 //cascading lines
    
   
);
    reg [7:0] datavector;
    reg [7:0] ISR; 
    reg [7:0] IRR=0;
    reg myflag  ; 

    // Priority modes based on rotate bit (R) and select-level bit (SL) in OCW2
    localparam AUTOMATIC_ROTATING_MODE = 1;
    //EOI
    localparam AUTO_EOI = 1;
  
    

    // register to store the highest priority interrupt in case of rotating priority mode
    reg[7:0] priority_counter = 8'b00000001; 
    reg [3:0] iterator ; 
    // reg[2:0] priority_counter ='b000;
    reg [2:0]index=0;

    assign INT = (IRR != 0)?1:0;
    // set the interrupt line to 1 if there is an interrupt request that is not masked
    always @(irr or IMR or endOfinit ) begin
      if(endOfinit ==1)begin
        IRR = (irr & ~IMR) |IRR ;
        // if (IRR != 0)  INT = 1;
        // else INT = 0;
      end
    end
    
    always @(posedge endOfimp1)
    begin
      if((SNGL==0 && en==0 && (CASin==ICW3[2:0])))
        begin
           if(endOfinit == 1)begin
         
          
        if(OCW2[7] == AUTOMATIC_ROTATING_MODE) begin 
          myflag = 0;
            

          for (iterator= 0 ;iterator<8 ; iterator = iterator +1)begin
            if(priority_counter ==0 )priority_counter =1 ;

            if(myflag == 0)begin
              if((IRR & priority_counter) != 0 )begin 
                ISR = IRR & priority_counter;
                IRR = IRR & ~ISR;
                priority_counter = priority_counter<<1;
                myflag = 1 ;
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
            
              end
            end
           end

            
        end



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
      
    end
    

    // set the In-Service Register and reset Interrupt Request Register when the interrupt is acknowledged 
    
    always @(posedge imp1) begin
      
      if((SNGL==1) || (SNGL==0 && en==1))
        begin
        // choose the highest priority based on the priority mode
        if(endOfinit == 1)begin
         
          
        if(OCW2[7] == AUTOMATIC_ROTATING_MODE) begin 
          myflag = 0;
            

          for (iterator= 0 ;iterator<8 ; iterator = iterator +1)begin
            if(priority_counter ==0 )priority_counter =1 ;

            if(myflag == 0)begin
              if((IRR & priority_counter) != 0 )begin 
                ISR = IRR & priority_counter;
                IRR = IRR & ~ISR;
                priority_counter = priority_counter<<1;
                myflag = 1 ;
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
            
              end
            end
           end

            
        end



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
  
        
    end
    
    always @(posedge imp2)
    begin
        if((SNGL==1) || (SNGL==0 && en==0 && (CASin==ICW3[2:0])))
      datavector={vector,index};
    end
     
    always@(posedge endOfimp2) 
    begin
       if((SNGL==1) || (SNGL==0 && en==1) || (SNGL==0 && en==0 && (CASin==ICW3[2:0])))
         begin
      if(ICW4==AUTO_EOI)
      begin
        ISR[index]=0;
      end 
    end
    end

     reg counter=0;
    always@(OCW2Sent)
    begin                 
      if(ICW4!=AUTO_EOI && OCW2Sent==1 && OCW2[5]==1) 
        begin
             if(SNGL==1)
        //lw single 
        ISR[index]=0;
         else if((SNGL==0 && en==1))
              //lw ana msh single w master: ISR[index]=0; 
           ISR[index]=0;
         else if((SNGL==0 && en==0 && (CASin==ICW3[2:0])))
            //lw ana msh signle w slave, hshof el counter, lw equal 0 h3ml +1, lw equal 1: ISR[index]=0; w counter =0
           begin
             if(counter==0)
               counter=counter+1;
             else
               begin
                  ISR[index]=0;
                  counter=0;
               end
           end
      end
    end
    
    always @(read)begin
      if(read == 1)begin
        if(A0==1)begin
          isrOrirrOrimrToRWModuleOrdatavector = IMR;
        end
        else begin
          case(RR_RIS)
            2'b10:  isrOrirrOrimrToRWModuleOrdatavector = IRR; 
            2'b11:  isrOrirrOrimrToRWModuleOrdatavector = ISR; 
            default:;
          endcase
         end
      end
     end

    assign CASout =(en ==1)?index:'bzzz;

    always @(datavector)begin
      isrOrirrOrimrToRWModuleOrdatavector = datavector;
     end
       
endmodule



//level w edge trigg mode
