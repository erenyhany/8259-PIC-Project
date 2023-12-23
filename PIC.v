module PIC(/*inout [7:0]Dpic ,*/inout [2:0]caspic ,input [7:0]Dinpic , input RDpic,WRpic,A0pic,CSpic,Enpic,INTApic,[7:0]irrpic  ,output INTpic,[7:0]Doutpic );

    wire [7:0]datafromPrToRW ;
    wire Readd,endOfinitPic, intreqFromPrToControl;
    wire [7:0]datafromRWToControl;
    wire [4:1]ICWSpic;
    wire [3:1]OCWspic;
    wire imp1pic,imp2pic,endOfimp2pic,AEOIpic;
    wire[4:0]beginOfvectorAdresspic;
    wire[7:0]maskPic; 
    wire[1:0]RR_RISpic;
    wire [2:0]R_SL_EOIpic;
    wire OCW2isSentpic;
    wire endOfimp1pic;
    wire SNGLpic ; 
    wire [7:0]ICW3wordpic ; 

    
    RWModule RWinst (RDpic ,WRpic,A0pic,CSpic,
                datafromPrToRW,Dinpic,Doutpic,Readd,datafromRWToControl,
                ICWSpic,OCWspic,endOfinitPic);
    ControlLogic CLinst (A0pic,INTApic, intreqFromPrToControl,
                    ICWSpic,OCWspic,
                    datafromRWToControl, imp1pic,imp2pic,endOfimp2pic,INTpic,
                    AEOIpic,beginOfvectorAdresspic,maskPic,
                    RR_RISpic,R_SL_EOIpic,OCW2isSentpic,endOfimp1pic,
                    SNGLpic,ICW3wordpic);

    PR PRinst (endOfinitPic,A0pic,Readd,
                irrpic,maskPic,R_SL_EOIpic,
                RR_RISpic,imp1pic,imp2pic,endOfimp2pic,endOfimp1pic,
                OCW2isSentpic,AEOIpic,beginOfvectorAdresspic,intreqFromPrToControl,
                datafromPrToRW,caspic,Enpic,SNGLpic,ICW3wordpic);
    
endmodule



module testbench();
reg [7:0] Datain,irr;
reg rd ,wr,A0,cs,En,INTA;
wire INT;
wire[7:0]DataOut;


   /*TEST 1 no icw3(no casc) , automatic ,fully  nested , skip ocw2 ,read mask ,read irr*/
    initial begin
        $monitor("INPUT:    DataIn:%b ,irr:%b wr:%b ,cs:%b, A0:%b \nOUTPUT:     DataOut:%b ,INT:%b\n",Datain,irr, wr,cs, A0,DataOut , INT);
        INTA = 1 ; 
        irr= 0;
        wr<=1 ;
        cs <=1;
        rd <=1;
        // sendtopiccc = 'b10;
        
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\nsend icw1 with level sensing mode &single mode:");
        Datain <= 'b0000011011;
        wr<=0 ;
        cs <=0;
        A0 <=0;

        //icw2 for the data vector and will concatenate 01010 with the number of 
        
        #100   
        $display("\nsend icw2(for the data vector and will concatenate 01010 with the number of bit)");
        wr=1 ;
        cs =1;
        Datain <= 'bxxxxxxxx;
        #100
        wr<=0 ;
        cs <=0;
        A0 <=1;
        Datain <= 'b01010101;

        #100
         wr<=1 ;
        cs <=1;
        Datain <= 'bxxxxxxxx;

         #100 //icw4 (auto)
        $display("\nsend icw4 with automatic mode:");
        Datain <= 'b00000010;
        wr<=0 ;
        cs <=0;
        A0 <=1;
        
        #100   
        wr<=1 ;
        cs <=1;
        Datain <= 'bxxxxxxxx;

        #100  //ocw1 set mask  (bit 1 ignored)
        $display("\nSend ocw1 to set mask :(ignoring irr[1]&irr[6]&irr[7])");
        wr<=0 ;
        cs <=0;
        A0 <=1;
        Datain <= 'b11000010;

         #100
         wr<=1 ;
        cs <=1;
        Datain <= 'bxxxxxxxx;

 
        
        #100  //ocw3 
        $display("\n OCW3 : to read irr when read signal comes:");
        wr<=0 ;
        cs <=0;
        A0 <=0;
        Datain <= 'b00001010;
        

         #100
         $display("\nset irr :");
         wr<=1 ;
         cs <=1;
         Datain <= 'bxxxxxxxx;
         irr <= 'b10010110;

        #100
        $display("\nsend read signal with A0 = 0 & RR_RIS = 10 .so it will send the irr to the cpu");
         cs <=0;
         rd<=0;

         #100
         cs <=1;
         rd<=1;

        //impulse1
         #100
         $display("\nimpulse 1 came:");
         INTA = 0;
         #100
         INTA = 1 ;


         
        #100
        $display("\nsend read signal with A0 = 0 & RR_RIS = 10 .so it will send the irr to the cpu after sending impulse1 and updating inner irr reg : ");
         cs <=0;
         rd<=0;

         #100
         cs <=1;
         rd<=1;
       
        //impulse 2
         #100
        $display("\nimpulse 2 came: so the vector of service routiene should be sent ");
         INTA = 0;
         #100
         INTA = 1 ;



        #100 
        $display("send read signal to show the mask ");
        A0<=1;
        cs <=0;
         rd<=0;
         


     end
     PIC pic1(,Datain,rd ,wr,A0,cs,En,INTA,irr,INT,DataOut);
endmodule
