module ControlLogic(input A0, wire INTA,wire intreq,
  wire[4:1] ICWs, wire [4:1]OCWs,
 wire [7:0]datain ,output INT ,impulse1,impulse2,endOfImpulse2,
reg AEOI,reg [4:0]beginOfvectorAdress ,reg [7:0]maskreg,
reg[2:0]RR_RIS,reg [2:0]R_SL_EOI);


    localparam icw1 = 1 , icw2 = 2 ,icw3=3 , icw4=4 ,ocw1=1,ocw2=2,ocw3=3;
    reg[7:0] ICW1word,ICW2word,ICW3word,ICW4word;
    reg[7:0] OCW1word,OCW2word,OCW3word;
    assign INT = intreq;


    reg counter [2:1];
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

     always @(posedge INTA)begin 
        if(counter ==2'b10)begin 
            endOfImpulse2=1;
        end
     end

    assign impulse1 = counter[1];
    assign impulse2 = counter[2];



    always @(ICWs) begin
        case(ICWs)
        4'b0001 :begin 
            ICW1word = datain;
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
        case(OCWs)
        3'b001 : begin OCW1word = datain;
                    maskreg = OCW1word;
                    
                end 
        3'b010 : begin OCW2word = datain;
                        R_SL_EOI=0;
                        R_SL_EOI = OCW2word[7:5];
                end
        3'b100 : begin OCW3word = datain;
                    RR_RIS = OCW3word[1:0];
                end
        default : ;
        endcase
     end





    
endmodule