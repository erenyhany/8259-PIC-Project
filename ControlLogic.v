module ControlLogic(input A0, wire INTA,wire intreq,
  wire[4:1] ICWs, wire [3:1]OCWs,
 wire [7:0]datain ,output impulse1,impulse2,reg endOfImpulse2,reg INT ,
reg AEOI,reg [4:0]beginOfvectorAdress ,reg [7:0]maskreg,
reg[1:0]RR_RIS,reg [2:0]R_SL_EOI,reg OCW2isSent ,output reg endOfimp1,
 reg SNGL,output reg[7:0]ICW3word );


    localparam icw1 = 1 , icw2 = 2 ,icw3=3 , icw4=4 ,ocw1=1,ocw2=2,ocw3=3;
    reg[7:0] ICW1word,ICW2word,ICW4word;
    reg[7:0] OCW1word,OCW2word,OCW3word;
    always @(intreq)begin
        INT = intreq;
    end
    reg [2:1]counter ;
    always@(INT)begin 
        if(INT == 1)begin
         counter = 0;
        end
    end 
    always @ (INTA) begin
        if(~INTA)begin
        INT=0;
        if(counter ==0) begin counter=1; endOfImpulse2=0;end
        else begin
            counter = counter<<1;
        end
        end
     end 

    always@(posedge INTA )begin
        if(impulse1 == 1 )begin
        endOfimp1 = 1 ;
         end 
    end
     always @(posedge INTA)begin 
        if(counter ==2'b10)begin 
            endOfImpulse2=1;
            endOfimp1 =0;
        end
        
     end

    assign impulse1 = counter[1];
    assign impulse2 = counter[2];



    always @(ICWs) begin
        case(ICWs)
        4'b0001 :begin 
            ICW1word = datain;
            SNGL = ICW1word[1];
            if(ICW1word[0] ==0)begin
                AEOI = 0;
                end
            
            end
        4'b0010 : begin ICW2word = datain;
                         beginOfvectorAdress = ICW2word[7:3];
                         end
        4'b0100 : ICW3word = datain;
        4'b1000 : begin ICW4word = datain;
                        AEOI = ICW4word[1];
                        //skiping el buffered (cancelled)
        end

        default : ;
        endcase
     end
    always @(OCWs) begin
        OCW2isSent=0;
        case(OCWs)
        3'b001 : begin OCW1word = datain;
                    maskreg = OCW1word;
                    
                end 
        3'b010 : begin OCW2word = datain;
                        R_SL_EOI=0;
                        R_SL_EOI = OCW2word[7:5];
                        OCW2isSent=1;
                end
        3'b100 : begin OCW3word = datain;
                    RR_RIS = OCW3word[1:0];
                end
        default : ;
        endcase
     end





    
endmodule




//ne3mel mawdou3 enena nesafar el mask by default
