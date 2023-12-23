module PIC(/*inout [7:0]Dpic ,***********/input [2:0]casInpic,output [2:0]casOutpic ,input [7:0]Dinpic , input RDpic,WRpic,A0pic,CSpic,Enpic,INTApic,[7:0]irrpic  ,output INTpic,[7:0]Doutpic );

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
                datafromPrToRW,casInpic,casOutpic,Enpic,SNGLpic,ICW3wordpic);
    
endmodule



module testbench();
// reg [7:0] Datain,irr;
// reg rd ,wr,A0,cs,En,INTA;
// wire INT;
// wire[7:0]DataOut;


   /*
   #################################################################################
   TEST 1 no icw3(no casc) , automatic ,fully  nested , skip ocw2 ,read mask ,read irr
   ###################################################################################
   */
    /*initial begin
        $monitor("INPUT:    DataIn:%b ,irr:%b ,rd:%b,wr:%b ,cs:%b, A0:%b \nOUTPUT:    DataOut:%b ,INT:%b\n",Datain,irr,rd, wr,cs, A0,DataOut , INT);
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
        
        wr=1 ;
        cs =1;
        Datain <= 'bxxxxxxxx;
        #100
        $display("\nsend icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        cs <=0;
        A0 <=1;
        Datain <= 'b01110101;

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

        #100  //ocw1 set mask  (bit 1,6,7 ignored)
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
         $display("\nsend impulses from i/o devices :");
         wr<=1 ;
         cs <=1;
         Datain <= 'bxxxxxxxx;
         irr <= 'b10010110;
        #100
        irr <= 0;

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
        $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
         INTA = 0;
         #100
         INTA = 1 ;


                 //impulse1
         #100
         $display("\nimpulse 1 came:");
         INTA = 0;
         #100
         INTA = 1 ;


         
        #100
        $display("\nsend read signal with A0 = 0 & RR_RIS = 10 .so it will send the IRR register after being updated to the cpu ");
         cs <=0;
         rd<=0;

         #100
         cs <=1;
         rd<=1;
       
        //impulse 2
         #100
        $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
         INTA = 0;
         #100
         INTA = 1 ;




        #100 
        $display("send read signal to show the mask ");
        A0<=1;
        cs <=0;
        rd<=0;
         
     end*/



    /*
   #################################################################################
   TEST 2 no icw1(no casc , no icw3 ,no icw4) , not auto  ,rotational ,read isr
   ###################################################################################
   */
//    initial begin 
//      $monitor("INPUT:    DataIn:%b ,irr:%b ,rd:%b,wr:%b ,cs:%b, A0:%b \nOUTPUT:    DataOut:%b ,INT:%b\n",Datain,irr,rd, wr,cs, A0,DataOut , INT);
//         INTA = 1 ; 
//         irr= 0;
//         wr<=1 ;
//         cs <=1;
//         rd <=1;
        
//         #100//send icw1 (no icw3 bas fih icw4 )
//         $display("\nsend icw1 with level sensing mode &single mode:");
//         Datain <= 'b0000011010;
//         wr<=0 ;
//         cs <=0;
//         A0 <=0;

//           //icw2 for the data vector and will concatenate 01010 with the number of 
        
//         #100   
        
//         wr=1 ;
//         cs =1;
//         Datain <= 'bxxxxxxxx;
//         #100
//         $display("\nsend icw2(for the data vector and will concatenate 01110 with the number of bit)");
//         wr<=0 ;
//         cs <=0;
//         A0 <=1;
//         Datain <= 'b01110101;

//         #100
//          wr<=1 ;
//         cs <=1;
//         Datain <= 'bxxxxxxxx;

//         #100  //ocw1 set mask  (no masks )
//         $display("\nSend ocw1 to set mask :(no masks)");
//         wr<=0 ;
//         cs <=0;
//         A0 <=1;
//         Datain <= 'b00000000;

//          #100
//          wr<=1 ;
//         cs <=1;
//         Datain <= 'bxxxxxxxx;

 
        
//         #100  //ocw3 
//         $display("\n OCW3 : to read isr when read signal comes:where RR_RIS =11 to read isr");
//         wr<=0 ;
//         cs <=0;
//         A0 <=0;
//         Datain <= 'b00001011;

//          #100
//          wr<=1 ;
//         cs <=1;
//         Datain <= 'bxxxxxxxx;

 
        
//         #100  //ocw2
//         $display("\n OCW2 : to allow the automatic rotating priority mode ");
//         wr<=0 ;
//         cs <=0;
//         A0 <=0;
//         Datain <= 'b10000000;
//          #100
//         wr<=1 ;
//         cs <=1;
//         irr<= 8'b00010010;
//         Datain <= 'bxxxxxxxx;

//         //impulse1
//          #100
//          $display("\nimpulse 1 came:");
//          irr=0;
//          INTA = 0;
//          #100
//          INTA = 1 ;

           
//         //impulse 2
//          #100
//         $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
//          INTA = 0;

//          #100
//          INTA = 1 ;
//          $display("\nsend read signal .so it will send the ISR to make sure that the isr and the IRR\nhaven't changed AND WAIT FOR OCW2");
//          cs <=0;
//          rd<=0;
//          #100
//          cs <=1;
//          rd<=1;

//          #100  //ocw2 3ashan ne2fel el interupt
//         $display("\n OCW2 :to end the interrupt ");
//         wr<=0 ;
//         cs <=0;
//         A0 <=0;
//         Datain <= 'b10100000;
//          #100
//         wr<=1 ;
//         cs <=1;
//         Datain <= 'bxxxxxxxx;

//          #100
//          $display("\nsend read signal .to read ISR after sending ocw2 to end the interupt");
//          cs <=0;
//          rd<=0;
//          #100
//          cs <=1;
//          rd<=1;
         
//          #100
//          $display("\nupdate irr by sending impulse at irr[0],to test the priority of the rotating mode(this bit will have a low priority)");
//          irr=1;
//          #100 
//          irr = 0;

//         //impulse1
//          #100
//          $display("\nimpulse 1 came:");
//          irr=0;
//          INTA = 0;
//          #100
//          INTA = 1 ;

           
//         //impulse 2
//          #100
//         $display("\nimpulse 2 came: so the vector of service routiene should be sent as an output  ");
//          INTA = 0;

//          #100
//          INTA = 1 ;
//          $display("\nsend read signal .so it will send the ISR to make sure that the isr and the IRR\nhaven't changed AND WAIT FOR OCW2");
//          cs <=0;
//          rd<=0;

//          #100
//         cs <=1;
//          rd<=1;
//         #100  //ocw2 3ashan ne2fel el interupt
//         $display("\n OCW2 :to end the interrupt ");
//         wr<=0 ;
//         cs <=0;
//         A0 <=0;
//         Datain <= 'b10100000;
//    end



    //  PIC pic1(,,Datain,rd ,wr,A0,cs,En,INTA,irr,INT,DataOut);

  /*########################################################################################################
  cascading testbench
  ########################################################################################*/
  reg [7:0] Datain,mirr,sirr;
  reg rd ,wr,A0,mcs,scs,mEn,sEn,INTA;
  wire mINT,sINT;
  wire[7:0]DataOut;
  reg [2:0] mcasin ,scasin;
  wire [2:0] mcasout ,scasout;


  initial begin
        // $monitor("INPUT:    DataIn:%b ,irr:%b ,rd:%b,wr:%b ,cs:%b, A0:%b \nOUTPUT:    DataOut:%b ,INT:%b\n",Datain,irr,rd, wr,cs, A0,DataOut , INT);
        INTA = 1 ; 
        sirr= 0;
        wr<=1 ;
        mcs <=1;
        rd <=1;
        mEn = 1;
        sEn =0 ;

        //initializing the master
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\nsend icw1 with level sensing mode &single mode:");
        Datain <= 'b00011001;
        wr<=0 ;
        mcs <=0;
        A0 <=0;

        //icw2 for the data vector and will concatenate 01010 with the number of 
        
        #100   
        
        wr=1 ;
        mcs =1;
        Datain <= 'bxxxxxxxx;
        #100
        $display("\nsend icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        Datain <= 'b01110101;

        #100
         wr<=1 ;
        mcs <=1;
        Datain <= 'bxxxxxxxx;

        #100
         $display("\nsend icw3(master)");
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        Datain <= 'b11111111;

         #100
         wr<=1 ;
        mcs <=1;
        Datain <= 'bxxxxxxxx;

         #100 //icw4 (auto)
        $display("\nsend icw4 with automatic mode:");
        Datain <= 'b00000010;
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        
        #100   
        wr<=1 ;
        mcs <=1;
        Datain <= 'bxxxxxxxx;

         #100  
        $display("\nSend ocw1 to set mask :no masking for master)");
        wr<=0 ;
        mcs <=0;
        A0 <=1;
        Datain <= 'b00000000;

         #100
         wr<=1 ;
        mcs <=1;
        Datain <= 'bxxxxxxxx;

        //initializing the slave
        #100//send icw1 (no icw3 bas fih icw4 )
        $display("\nsend icw1 with level sensing mode &single mode:");
        Datain <= 'b00011001;
        wr<=0 ;
        scs <=0;
        A0 <=0;


        
        #100   
        
        wr=1 ;
        scs =1;
        Datain <= 'bxxxxxxxx;
        #100
        $display("\nsend icw2(for the data vector and will concatenate 01110 with the number of bit)");
        wr<=0 ;
        scs <=0;
        A0 <=1;
        Datain <= 'b01100101;

        #100
         wr<=1 ;
        scs <=1;
        Datain <= 'bxxxxxxxx;

        #100
         $display("\nsend icw3(slave)");
        wr<=0 ;
        scs <=0;
        A0 <=1;
        Datain <= 'b00000000;

         #100
         wr<=1 ;
        scs <=1;
        Datain <= 'bxxxxxxxx;

         #100 //icw4 (auto)
        $display("\nsend icw4 with automatic mode:");
        Datain <= 'b00000010;
        wr<=0 ;
        scs <=0;
        A0 <=1;
        
        #100   
        wr<=1 ;
        scs <=1;
        Datain <= 'bxxxxxxxx;

         #100  
        $display("\nSend ocw1 to set mask :no masking for slave)");
        wr<=0 ;
        scs <=0;
        A0 <=1;
        Datain <= 'b00000000;

         #100
         wr<=1 ;
        scs <=1;
        Datain <= 'bxxxxxxxx;


   end

  always @(sINT)begin
    mirr[0] <= sINT;
   end

   always @(mcasout)begin 
    scasin <= mcasout;
   end


   PIC master(mcasin ,mcasout,Datain,rd ,wr,A0,mcs,mEn,INTA,mirr,mINT,DataOut);
   PIC slave(scasin ,scasout,Datain,rd ,wr,A0,scs,sEn,INTA,sirr,sINT,DataOut);

endmodule
