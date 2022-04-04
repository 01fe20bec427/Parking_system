module parking_sys_tb;
reg clk;
reg reset;
reg sensor_ent;
reg sensor_exit;
reg[1:0] pass_1;
reg[1:0] pass_2;
//outputs
wire green_led;
wire red_led;
wire[6:0] hex_1;
wire[6:0] hex_2;
parking_sys uut (
.clk(clk),
.reset(reset),
.sensor_ent(sensor_ent),
.sensor_exit(sensor_exit),
.pass_1(pass_1),
.pass_2(pass_2),
.green_led(green_led),
.red_led(red_led),
.hex_1(hex_1),
.hex_2(hex_2)
);
initial begin
clk=0;
forever #10 clk=~clk;
end

initial begin
reset=0;
sensor_ent=0;
sensor_exit=0;
pass_1=0;
pass_2=0;

#100;
reset=1;
#20;
sensor_ent=1;
#1000;
sensor_ent=0;
pass_1=1;
pass_2=2;
#2000;
sensor_exit=1;
end
endmodule
