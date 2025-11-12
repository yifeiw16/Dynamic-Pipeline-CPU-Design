`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/24 21:04:58
// Design Name: 
// Module Name: my_ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module my_ALU(
    input [31:0] operator_a,        //操作数a
    input [31:0] operator_b,        //操作数b
    input [3:0] alu_controller,    //alu3210
    output reg [31:0] result,          //计算结果  
  
    output reg zero,             //结果为0
    output reg carry,           //进位
    output reg negative,       //sub的结果为负数
    output reg overflow       //溢出
 ); 
    reg [32:0] r_temp;
    wire signed [31:0] s_a;
    wire signed[31:0] s_b;
    assign s_a=operator_a;
    assign s_b=operator_b;
    
    always @ (*) begin
        case(alu_controller)
        4'b0000:
         //Addu lw,sw  无符号加法
            begin
                r_temp<=operator_a+operator_b;
                result=r_temp[31:0];
                /*四个标志位*/   
                carry=r_temp[32];
                zero=(r_temp==32'b0)?1:0;
                negative=0;
                overflow=0;
                // negative=r_temp[31]; //是否是负数看符号位  
                // overflow
            end
        4'b0001:
        //subu   无符号减法
            begin
                r_temp<=operator_a-operator_b;
                result=r_temp[31:0];
                /*四个标志位*/ 
                if(operator_a<operator_b)
                    carry=1;
                else
                    carry=0;  
               
                zero=(r_temp==32'b0)?1:0;
                negative=0;
                overflow=0;
            end
            
        4'b0010:
        //add 有符号数加法
            begin
                r_temp<=s_a+s_b;
                result=r_temp[31:0];
                /*四个标志位*/ 
                //if(operator_a<operator_b)
                     carry=1;
                //else
                     //carry<=0;  
                 carry=r_temp[32]; //
                 
                 zero=(r_temp==32'b0)?1:0; //
                 negative=r_temp[31];  //
                 
                 //if(r_temp[32] != r_temp[31] && operator_a[31] == operator_b[31])
                    //overflow = 1;
                 //else
                    //overflow = 0;   
                  overflow=r_temp[31];     //           
            end
            
        4'b0011:
        //sub 有符号数减法
            begin
                 r_temp<=s_a-s_b;
                 result=r_temp[31:0];
                 /*四个标志位*/ 
                 carry=r_temp[32]; //
                 zero=(r_temp==32'b0)?1:0; //
                 negative=r_temp[31];  //
                 overflow=r_temp[31];     //    
            end
            
        4'b0100:
        //and  按位且  用无符号数
            begin
                r_temp<=operator_a & operator_b;
                result=r_temp[31:0];
                /*四个标志位*/ 
                carry=r_temp[32]; //
                zero=(r_temp==32'b0)?1:0; //
                negative=r_temp[31];  //
                overflow=r_temp[31];     // 
            end
            
        4'b0101:
        //or  按位或
            begin
                 r_temp<=operator_a | operator_b;
                 result<=r_temp[31:0];
                 /*四个标志位*/ 
                  carry=r_temp[32]; //
                  zero=(r_temp==32'b0)?1:0; //
                  negative=r_temp[31];  //
                  overflow=r_temp[31];     // 
            end
            
        4'b0110:
         //xor 异或
            begin
                 r_temp<=operator_a ^ operator_b;
                 result<=r_temp[31:0];
                 /*四个标志位*/ 
                 carry=r_temp[32]; //
                 zero=(r_temp==32'b0)?1:0; //
                 negative=r_temp[31];  //
                 overflow=r_temp[31];     // 
            end
            
        4'b0111:
         //nor 或非
            begin
                r_temp<=~(operator_a | operator_b);
                result=r_temp[31:0];
                /*四个标志位*/ 
                carry=r_temp[32]; //
                zero=(r_temp==32'b0)?1:0; //
                negative=r_temp[31];  //
                overflow=r_temp[31];     // 
            end
            
        4'b1000:   //???为什么有两个lui
          //lui  腾空低 16 位
            begin
               r_temp<={operator_b[15:0], 16'b0}; 
               result=r_temp[31:0];
               /*四个标志位*/ 
               carry=r_temp[32]; //
               zero=(r_temp==32'b0)?1:0; //
               negative=r_temp[31];  //
               overflow=r_temp[31];     // 
            end
        4'b1001:   //???为什么有两个lui
                      //lui  腾空低 16 位
                        begin
                           r_temp<={operator_b[15:0], 16'b0}; 
                           result=r_temp[31:0];
                           /*四个标志位*/ 
                           carry=r_temp[32]; //
                           zero=(r_temp==32'b0)?1:0; //
                           negative=r_temp[31];  //
                           overflow=r_temp[31];     // 
                        end
        4'b1010:
          //sltu 无符号比大小
            begin
                r_temp<=operator_a < operator_b ? 1:0 ; 
                result=r_temp[31:0];
                /*四个标志位*/ 
                carry=r_temp[32]; //
                zero=(r_temp==32'b0)?1:0; //
                negative=r_temp[31];  //
                overflow=r_temp[31];     // 
            end
         4'b1011:
          //slt  比较大小
            begin
                r_temp <= s_a < s_b ? 1:0 ; 
                result = r_temp[31:0];
                /*四个标志位*/ 
                carry=r_temp[32]; //
                zero=(r_temp==32'b0)?1:0; //
                negative=r_temp[31];  //
                overflow=r_temp[31];     // 

            end
         4'b1100:
          //srav sra 算术右移
            begin
                r_temp  <= s_b >>> s_a;
                result = r_temp[31:0];
                /*四个标志位*/ 
                carry=r_temp[32]; //
                zero=(r_temp==32'b0)?1:0; //
                negative=r_temp[31];  //
                overflow=r_temp[31];     // 
            end
          
         4'b1101:
         //srl , srlv   逻辑右移
            begin
                r_temp  <= operator_b >> operator_a;
                result = r_temp[31:0];
                /*四个标志位*/ 
                carry=r_temp[32]; //
                zero=(r_temp==32'b0)?1:0; //
                negative=r_temp[31];  //
                overflow=r_temp[31];     // 
            end
         4'b1110:
          //sll sllv 逻辑左移
            begin
                r_temp <= operator_b << operator_a;
                result = r_temp[31:0];
                /*四个标志位*/ 
                carry =r_temp[32]; //
                zero =(r_temp==32'b0)?1:0; //
                negative =r_temp[31];  //
                overflow =r_temp[31];     // 
            end
        endcase
      end
       
endmodule
