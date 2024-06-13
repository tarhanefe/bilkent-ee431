clear all;
close all;
%%
figure(1);
Ts = 0.1;
% -10 to 30 
X1 = zeros(1,40/Ts + 1);
X1(102:100 + 16/Ts ) = 1/16;
x = -10:0.1:30;
plot(x,X1);
xlabel('x');
ylabel('f_{X_1}(x)');
title("Probability density function of X_{1}")

%% 
figure(2);
Ts = 0.1;
% -30 to 10 
X2 = zeros(1,40/Ts + 1);
X2(22/Ts + 2:22/Ts + 8/Ts ) = 1/8;
x = -30:0.1:10;
plot(x,X2);
xlabel('x');
ylabel('f_{X_2}(x)');
title("Probability density function of X_{2}")
%% 
figure(3);
y = -10:40;
Y = zeros(1,51);
Y(3:10) = ((3:10)-3)/128;
Y(11:19) = 1/16;
Y(20:27) = (27-(20:27))/128;
plot(y,Y);
xlabel('y');
ylabel('f_{Y}(y)');
title("Probability density function of Y = X_{1} + X_{2}")

%% 
figure(4);
y = -10:40;
Y = zeros(1,51);
Y(3:10) = ((3:10)-3)/128;
Y(11:19) = 1/16;
Y(20:27) = (27-(20:27))/128;
plot(y,Y);
xlabel('y');
ylabel('f_{Y}(y)');
title("Probability density function of Y = X_{1} + X_{2}")