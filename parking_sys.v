module parking_sys(
input clk,reset,
input sensor_ent,sensor_exit,
input[1:0] pass_1,pass_2,
output wire green_led,red_led,
output reg [6:0] hex_1,hex_2
);
parameter idle=3'b000,wait_pass=3'b001,wrong_pass=3'b010,right_pass=3'b011,stop=3'b100;
//moore fsm
reg[2:0] current_state,next_state;
reg[31:0] counter_wait;
reg red_tmp,green_tmp;

//next state
always@(posedge clk or negedge reset)
begin
if(~reset)
current_state=idle;
else
current_state=next_state;
end

//counter_wait
always@(posedge clk or negedge reset)
begin
if(~reset)
counter_wait<=0;
else if(current_state==wait_pass)
counter_wait<=counter_wait+1;
else
counter_wait<=0;
end

//change state
always@(*)
begin
case(current_state)
idle:begin
if(sensor_ent==1)
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
if(sensor_ent==1 && sensor_exit==1)
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

//LEDs and output
always@(posedge clk)
begin
case(current_state)
idle:begin
green_tmp=1'b0;
red_tmp=1'b0;
hex_1=7'b1111111;
hex_2=7'b1111111;
end

wait_pass:begin
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
