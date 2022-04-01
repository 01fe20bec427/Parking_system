module parkingsystem(input clk,reset,sensor_enterance,sensor_exit,input[1:0] pass_1,pass_2,output wire green_led,red_led,output reg[6:0]hex_1,hex2);
parameter idle=3'b000,wait_pass=3'b001,wrong_pass=3'b010,right_pass=3'b011,stop=3'b100;
reg[2:0] curent_state,next_state;
reg[31:0] counter_wait;
reg red_tmp,green_tmp;
always @(posedge clk or negedge reset)
begin
if(~reset)
current_state=idle;
else
current_state=next_state;
end

always @(posedge clk or negedge reset)
begin
if(~reset)
counter_wait<=0;
else if (current_state==wait_pass)
counter_wait<=counter_wait+1;
else
counter_wait<=0;
end

always @(*)
begin
case(current_state)
idle:begin
if(sensor_enterance==1)
next_state=wait_pass;
else
next_state=idle;
end

wait_pass:begin
if(counter_wait<=3)
next_state=wait_pass;
else
begin
if((pass_1==2'b01)&&(pass_2==2'b10))
next_state=right_pass;
else 
next_state=wrong_pass;
end
end

wrong_pass:begin
if((pass_1==2'b01)&&(pass_2==2'b10))
next_state=right_pass;
else 
next_state=wrong_pass;
end

right_pass:begin
if(sensor_enterance==1 && sensor_exit==1)
next_state=stop;
else if(sensor_exit==1)
next_state=idle;
else
next_state=right_pass;
end
stop:begin
if((pass_1==2'b01)&&(pass_2==2'b10))
next_state=right_pass;
else 
next_state=stop;
end
default:next_state=idle;
endcase
end

always @(posedge clk)begin
case(current_state)
idle:begin
green_tmp=1'b0;
red_tmp=1'b1;
hex_1=7'b1111111;
hex_2=7'b11111111;
end

wait_password:begin
green_tmp=1'b0;
red_tmp=1'b1;
hex_1=7'b000_0110;
hex_2=7'b010_1011;
end

wrong_pass:begin
green_tmp=1'b0;
red_tmp=~red_tmp;
hex_1=7'b000_0110;
hex_2=7'b000_0110;
end

right_pass:begin
green_tmp=~green_tmp;
red_tmp=1'b0;
hex_1=7'b000_0010;
hex_2=7'b100_0000;
end

stop:begin
green_tmp=1'b0;
red_tmp=~red_tmp;
hex_1=7'b001_0010;
hex_2=7'b000_1100;
end
endcase
end
assign red_led=red_tmp;
assign green_led=green_tmp;
endmodule


//testbench

module tbparkingsystem;
reg clk;
reg reset;
reg sensor_ent;
reg sensor_exit;
reg [1:0]password1;
reg [1:0]password2;
wire greenled;
wire redled;
wire [6:0]hex1;
wire [6:0]hex2;

tbparkingsystem uut(.clk(clk),.reset(reset),.sensor_ent(sensor_ent),.sensor_exit(sensor_exit),.password1(password1),.password2(password2),.greenled(greenled),.redled(redled),.hex1(hex1),.hex2(hex2)); 
initial begin
clk=0;
forever #10 clk=~clk;
end
initial begin
reset=0;
sensor_ent=0;
sensor_exit=0;
password1=0;
password2=0;
#100;
reset=1;
#20;
sensor_ent=1;
#100;
sensor_ent=0;
password1=1;
password2=2;
#2000;
sensor_exit=1;
end
endmodule
