%% Part 1.a-b-c
clearvars;
close all;
load("signaldata1.mat");

%Basis functions
psi_list = sqrt(2)*sin(2*pi*[10:10:300].*[0:1/1200:1]')';

fk_list = 10:10:300;
phi_list = [];
max_size = size(psi_list);
for i = 1:max_size(1)
    ak = sum(x.*psi_list(i,:))/1200;
    phi_list = horzcat(phi_list,ak);
end
indexes = (phi_list > 1e-8); 
fk__list = fk_list(fk_list.*indexes > 0);
phi_list = phi_list .* indexes;
ak_list = phi_list(phi_list > 0)*sqrt(2);

%% Part 1.d
x_1 = x + randn(1,length(x));
x_5 = x + 5*randn(1,length(x));
x_10 = x + 10*randn(1,length(x));

figure(1);
plot(0:1/1200:1,x_1,'-',Color = 'b');
hold on 
plot(0:1/1200:1,x,'-',Color = 'r');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\tilde{x}(t)$$','Interpreter','LaTeX');
title('Plot of $$\tilde{x}(t) = x(t) + N(0,1)$$','Interpreter','LaTeX');
legend({'$x(t) + N(0,1)$', '$x(t)$'}, 'Interpreter', 'latex');

figure(2);
plot(0:1/1200:1,x_5,'-',Color = 'b');
hold on 
plot(0:1/1200:1,x,'-',Color = 'r');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\tilde{x}(t)$$','Interpreter','LaTeX');
title('Plot of $$\tilde{x}(t) = x(t) + N(0,25)$$','Interpreter','LaTeX');
legend({'$x(t) + N(0,25)$', '$x(t)$'}, 'Interpreter', 'latex');

figure(3);
plot(0:1/1200:1,x_10,'-',Color = 'b');
hold on 
plot(0:1/1200:1,x,'-',Color = 'r');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\tilde{x}(t)$$','Interpreter','LaTeX');
title('Plot of $$\tilde{x}(t) = x(t) + N(0,100)$$','Interpreter','LaTeX');
legend({'$x(t) + N(0,100)$', '$x(t)$'}, 'Interpreter', 'latex');

%% Part 1.e

phi_list_1 = [];
max_size = size(psi_list);
for i = 1:max_size(1)
    ak = sum(x_1.*psi_list(i,:))/1200;
    phi_list_1 = horzcat(phi_list_1,ak);
end
index = [];
for i = 1:10
listt = abs([phi_list_1(3*(i-1)+1),phi_list_1(3*(i-1)+2),phi_list_1(3*(i-1)+3)]);
item = max(abs([phi_list_1(3*(i-1)+1),phi_list_1(3*(i-1)+2),phi_list_1(3*(i-1)+3)]));
index = horzcat(index,(listt == item));
end 
ak_list_1 = phi_list_1(logical(index))*sqrt(2);
fk_list_1 = fk_list(logical(index));


phi_list_5 = [];
max_size = size(psi_list);
for i = 1:max_size(1)
    ak = sum(x_5.*psi_list(i,:))/1200;
    phi_list_5 = horzcat(phi_list_5,ak);
end

index = [];
for i = 1:10
listt = abs([phi_list_5(3*(i-1)+1),phi_list_5(3*(i-1)+2),phi_list_5(3*(i-1)+3)]);
item = max(abs([phi_list_5(3*(i-1)+1),phi_list_5(3*(i-1)+2),phi_list_5(3*(i-1)+3)]));
index = horzcat(index,(listt == item));
end 
ak_list_5 = phi_list_5(logical(index))*sqrt(2);
fk_list_5 = fk_list(logical(index));


phi_list_10 = [];
max_size = size(psi_list);
for i = 1:max_size(1)
    ak = sum(x_10.*psi_list(i,:))/1200;
    phi_list_10 = horzcat(phi_list_10,ak);
end
index = [];
for i = 1:10
listt = abs([phi_list_10(3*(i-1)+1),phi_list_10(3*(i-1)+2),phi_list_10(3*(i-1)+3)]);
item = max(abs([phi_list_10(3*(i-1)+1),phi_list_10(3*(i-1)+2),phi_list_10(3*(i-1)+3)]));
index = horzcat(index,(listt == item));
end 
ak_list_10 = phi_list_10(logical(index))*sqrt(2);
fk_list_10 = fk_list(logical(index));
%% Part 2
clearvars;
close all;
rng(42,'twister');
V0(1:26) = (0:25)/1000;
V0(27:51) = 0.05-(26:50)/1000;
V0(52:76) = (51:75)/1000-0.05;
V0(77:100) = 0.1-(76:99)/1000;

figure(1);
plot(0:1e-3:0.1-1e-3,V0,'-',Color= 'k');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\Lambda_0(t)$$','Interpreter','LaTeX');
title('Plot of $$\Lambda_0(t)$$','Interpreter','LaTeX');

%% Part 2.a
bits = randi([0 1],1,5); 
signs = 2*bits-1;
X = repmat(V0,1,5) .* repelem(signs,1,length(V0));
figure(2);
plot(0:1e-3:0.5-1e-3,X,'-',Color = 'k');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$x(t)$$','Interpreter','LaTeX');
title('Plot of $$x(t)$$','Interpreter','LaTeX');

%% Part 2.b
E = V0*V0'*1e-3;
P0 = V0/E^0.5;

figure(3);
plot(0:1e-3:0.1-1e-3,P0,'-',Color = 'k');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\Psi_0(t)$$','Interpreter','LaTeX');
title('Plot of $$\Psi_0(t)$$','Interpreter','LaTeX');

x = [E^0.5,-E^0.5];
y = [0 0];

figure(4);
plot(x,y,'-o');
axis([-0.01 0.01 -1 1]);
line([0 x(1)], [0 0], 'Color', 'b', 'LineWidth', 1);
line([x(2) 0], [0 0], 'Color', 'b', 'LineWidth', 1); 
line([-0.01 0.01], [0 0], 'Color', 'k', 'LineWidth', 0.5);
dim = [.2 .2 .3 .3]; % Position and size of the text box [x y width height]
str = '$$\mathbf{-\Lambda_0} : [-0.0046\hspace{0.05in}0]^T$$'; % Text to be displayed in the box
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'BackgroundColor', 'white','Interpreter','Latex');
dim = [.73 .2 .3 .3]; % Position and size of the text box [x y width height]
str = '$$\mathbf{\Lambda_0} : [0.0046\hspace{0.05in}0]^T$$'; % Text to be displayed in the box
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'BackgroundColor', 'white','Interpreter','Latex');
title('Vector representation of $$\Lambda_0(t)$$ and $$-\Lambda_0(t)$$ in signal space','Interpreter','LaTeX');
grid on 

%% Part 2.c

P0_noise4 = X + (1e-4)^0.5*randn(1,length(X));

P0_noise2 = X + (1e-2)^0.5*randn(1,length(X));

P0_noise0 = X + randn(1,length(X));

figure(5);
plot(0:1e-3:0.5-1e-3,P0_noise4,'-',Color = 'b');
hold on 
plot(0:1e-3:0.5-1e-3,X,'-',Color = 'r');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\tilde{x}(t)$$','Interpreter','LaTeX');
title('Plot of $$\tilde{x}(t) = x(t) + N(0,10^{-4})$$','Interpreter','LaTeX');

figure(6);
plot(0:1e-3:0.5-1e-3,P0_noise2,'-',Color = 'b');
hold on 
plot(0:1e-3:0.5-1e-3,X,'-',Color = 'r');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\tilde{x}(t)$$','Interpreter','LaTeX');
title('Plot of $$\tilde{x}(t) = x(t) + N(0,10^{-2})$$','Interpreter','LaTeX');

figure(7);
plot(0:1e-3:0.5-1e-3,P0_noise0,'-',Color = 'b');
hold on 
plot(0:1e-3:0.5-1e-3,X,'-',Color = 'r');
xlabel("t(seconds)",'Interpreter','LaTeX')
ylabel('$$\tilde{x}(t)$$','Interpreter','LaTeX');
title('Plot of $$\tilde{x}(t) = x(t) + N(0,10^{0})$$','Interpreter','LaTeX');


%% 2.e
bits = randi([0 1], 1, 1e5);
signs = 2 * bits - 1;
X = repmat(V0, 1, 1e5) .* repelem(signs, length(V0));
noise_vars = 1.5*10.^(-6:0.5:0);
Exp_Prob = [];

for i = noise_vars
    X_n = X + sqrt(i*1e3)*randn(1,length(X));
    for j = 1 : 1e5
        outputs(j) = P0 * X_n(100 * (j - 1) + 1 : 100 * j)' / 1000;
    end
    estimation = double(outputs >= 0);
    error_cnt = sum(double(xor(estimation,bits)));
    prob = error_cnt/1e5;
    Exp_Prob = horzcat(Exp_Prob,prob);
end

SNR = E ./ (2 * noise_vars);
Theo_Prob = qfunc(sqrt(2 * SNR));

figure(9)
semilogy(10 * log10(SNR), Theo_Prob, '-r')
hold on 
semilogy(10 * log10(SNR), Exp_Prob, '--b')
grid on
xlabel('$SNR_{dB}$','Interpreter','LaTeX');
ylabel('$P_e$','Interpreter','LaTeX');
legend('Experimental Error','Theoretical Error','Interpreter','LaTeX');
title('Experimental vs Theoretical Probabilities of Error','Interpreter','LaTeX');
%% Part 2.g
bits_2 = randi([0 9], 1, 1e5);
bits_2(bits_2<9) = 0;
bits_2(bits_2 == 9) = 1;
signs_2 = 2 * bits_2 - 1;
X_2 = repmat(V0, 1, 1e5) .* repelem(signs_2, length(V0));
noise_vars = 1.5*10.^(-6:0.5:0);
Exp_Prob_Old = [];
Exp_Prob_New = [];

for i = noise_vars
    X_n = X_2 + sqrt(i*1e3)*randn(1,length(X_2));
    for j = 1 : 1e5
        outputs(j) = P0 * X_n(100 * (j - 1) + 1 : 100 * j)' / 1000;
    end
    estimation_old = double(outputs >= 0);
    error_cnt_old = sum(double(xor(estimation_old,bits_2)));    
    prob_old = error_cnt_old/1e5;
    Exp_Prob_Old = horzcat(Exp_Prob_Old,prob_old);

    threshold = (i * log(9)/ (4 * P0 * V0'))*1e3;
    estimation_new = double(outputs >= threshold);
    error_cnt_new = sum(double(xor(estimation_new,bits_2)));
    prob_new = error_cnt_new/1e5;
    Exp_Prob_New = horzcat(Exp_Prob_New,prob_new);

end

SNR = E ./ (2 * noise_vars);
figure(10)
semilogy(10 * log10(SNR), Exp_Prob_Old, '-r')
hold on 
semilogy(10 * log10(SNR), Exp_Prob_New, '--b')
grid on
xlabel('$SNR_{dB}$','Interpreter','LaTeX');
ylabel('$P_e$','Interpreter','LaTeX');
legend('ML Based Receiver Error','MAP Based Receiver Error','Interpreter','LaTeX');
title('Probabilities of Error for ML and MAP Based Receivers','Interpreter','LaTeX');

%% Part 2.h

alpha = 0.001:0.005:0.5;
var = 1e-2;
Exp_Prob_Old = [];
Exp_Prob_New = [];

for m = alpha
    bits_n = rand(1, 1e5);
    bits_n = double(bits_n < m);
    signs_n = 2 * bits_n - 1;
    X_n = repmat(V0, 1, 1e5) .* repelem(signs_n, length(V0)) + sqrt(var*1e3)*randn(1,length(X_n));
    for j = 1:1e5
        outputs(j) = P0 * X_n(100 * (j - 1) + 1 : 100 * j)' / 1000;
    end

    estimation_old = double(outputs >= 0);
    error_cnt_old = sum(double(xor(estimation_old,bits_n)));    
    prob_old = error_cnt_old/1e5;
    Exp_Prob_Old = horzcat(Exp_Prob_Old,prob_old);

    threshold = (var*log((1-m)/m)/ (4 * P0 * V0'))*1e3;
    estimation_new = double(outputs >= threshold);
    error_cnt_new = sum(double(xor(estimation_new,bits_n)));
    prob_new = error_cnt_new/1e5;
    Exp_Prob_New = horzcat(Exp_Prob_New,prob_new);
end


figure(12);
semilogy(alpha,Exp_Prob_Old, '-r');
hold on 
semilogy(alpha,Exp_Prob_New,'-b');
grid on
xlabel('$\alpha$','Interpreter','LaTeX');
ylabel('$P_e$','Interpreter','LaTeX');
legend('ML Based Receiver Error','MAP Based Receiver Error','Interpreter','LaTeX');
title('Probabilities of Error for ML and MAP Based Receivers for Values of $\alpha$','Interpreter','LaTeX');





