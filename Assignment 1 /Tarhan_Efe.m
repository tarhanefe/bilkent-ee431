close all; 
clear all; 
rand('seed', sum(100*clock));
%% PART 1.1-1.5: 
X1 = 16 * rand(1, 1000001);
X2 = -8 + 8 * rand(1, 1000001);
Y = X1 + X2;
sum_squared_avg = sum(Y.^2)/1000000;
figure(1);
histogram(Y,250);
xlabel('Value');
ylabel('Count');
title('Histogram of 1000000 Samples of Source Y');
%%
Y_Q = zeros(1, 1000001);
for i = 1:1000001
    if Y(i) < -2
        Y_Q(i) = -5;
    elseif Y(i) < 4
        Y_Q(i) = 1;
    elseif Y(i) < 10
        Y_Q(i) = 7;
    else
        Y_Q(i) = 13;
    end
end
e = Y - Y_Q;
boundary = [-8,-2,4,10,16];
levels = (boundary(1:end-1)+boundary(2:end))/2;
figure(2);
syms x
f = piecewise(x >= -8 & x <= 0, (x + 8)/128, x > 0 & x <= 8, 1/16, x > 8, (16-x)/128);
for b = boundary
    plot([b, b], [0,1/8], 'k--'); 
    hold on;
end

for l = 1:length(levels)
    plot(levels(l), 0, 'r*');
    hold on;
end
plot([-8, 16], [0,0], 'k',LineWidth= 1);
hold on;
plot([0, 0], [0,1/8], 'k',LineWidth= 1);
hold on;
fplot(f, [-8, 16],'b');

% Labelling and displaying the plot
xlabel('Value');
ylabel('Level');
title('Uniform Quantization Boundaries and Levels for N = 4');
hold off;

figure(3);
histogram(e,200);
xlabel('Value');
ylabel('Count');
title('Histogram of e = Y - Y_{Q} with N = 4');
avg_power_error = mean(e.^2);
SQNR = mean(Y.^2) / avg_power_error;
SQNR_dB = 10 * log10(SQNR);
fprintf('Average power of quantization error where N = 4: %f\n', avg_power_error);
fprintf('SQNR in dB: %f dB\n', SQNR_dB);

%%
for i = 1:33
    boundary(i) = -8 + (i-1)*24/32;
end

Y_Q = zeros(1, 1000001);
for i = 1:1000001
    for j = 1:length(boundary)
        if (boundary(j) <= Y(i))&&(boundary(j+1) >=Y(i))
           Y_Q(i) = (boundary(j) + boundary(j+1))/2;
        end
    end
end

e = Y - Y_Q;
figure(4);
histogram(e,500);
xlabel('Value');
ylabel('Count');
title('Histogram of e = Y - Y_{Q} with N = 32');
avg_power_error = mean(e.^2);
SQNR = mean(Y.^2) / avg_power_error;
SQNR_dB = 10 * log10(SQNR);
fprintf('Average power of quantization error where N = 32: %f\n', avg_power_error);
fprintf('SQNR in dB: %f dB\n', SQNR_dB);

%% PART 1.6
clear boundary;
level = 4;
syms x
f = piecewise(x >= -8 & x <= 0, (x + 8)/128, x > 0 & x <= 8, 1/16, x > 8, (16-x)/128);
boundary(1:level + 1) = 0; 
for i = 1:level+1
    boundary(i) = -8 + (i-1)*24/level;
end
levels = (boundary(1:end-1)+boundary(2:end))/2;

for j = 1:100
    for i = 1:level
        levels(i) = int(f*x,x,boundary(i),boundary(i+1))/int(f,x,boundary(i),boundary(i+1));
    end

    boundary(2:end-1) = (levels(1:end-1) + levels(2:end))/2;
end
%%
Y_Q = zeros(1, 1000001);
for i = 1:1000001
    for j = 1:length(boundary)-1
        if (boundary(j) <= Y(i))&&(boundary(j+1) >=Y(i))
           Y_Q(i) = levels(j);
        end
    end
end

e = Y-Y_Q;
figure(5);
histogram(e,200);
xlabel('Value');
ylabel('Count');
title('Histogram of e = Y - Y_{Q} with N = 4');
avg_power_error = mean(e.^2);
SQNR = mean(Y.^2) / avg_power_error;
SQNR_dB = 10 * log10(SQNR);
fprintf('Average power of nonuniform quantization error where N = 4: %f\n', avg_power_error);
fprintf('SQNR in dB: %f dB\n', SQNR_dB);
%%
figure(6);
for b = boundary
    plot([b, b], [0,1/8], 'k--'); 
    hold on;
end

for l = 1:length(levels)
    plot(levels(l), 0, 'r*');
    hold on;
end
plot([-8, 16], [0,0], 'k',LineWidth= 1);
hold on;
plot([0, 0], [0,1/8], 'k',LineWidth= 1);
hold on;
fplot(f, [-8, 16],'b');

% Labelling and displaying the plot
xlabel('Value');
ylabel('Level');
title('Nonuniform Quantization Boundaries and Levels for N = 4');
hold off;
%% 
clear boundary;
level = 32;
syms x
f = piecewise(x >= -8 & x <= 0, (x + 8)/128, x > 0 & x <= 8, 1/16, x > 8, (16-x)/128);
boundary(1:level + 1) = 0; 
for i = 1:level+1
    boundary(i) = -8 + (i-1)*24/level;
end
levels = (boundary(1:end-1)+boundary(2:end))/2;
err = 0;
for i = 1:level
    err = err + int(f*(x-levels(i))^2,x,boundary(i),boundary(i+1));
end

for j = 1:20
    for i = 1:level
        levels(i) = int(f*x,x,boundary(i),boundary(i+1))/int(f,x,boundary(i),boundary(i+1));
    end

    boundary(2:end-1) = (levels(1:end-1) + levels(2:end))/2;
    err = 0;
    for i = 1:level
        err = err + int(f*(x-levels(i))^2,x,boundary(i),boundary(i+1));
    end
end
%%
Y_Q = zeros(1, 1000001);
for i = 1:1000001
    for j = 1:length(boundary)-1
        if (boundary(j) <= Y(i))&&(boundary(j+1) >=Y(i))
           Y_Q(i) = levels(j);
        end
    end
end
figure(7);
e = Y-Y_Q;
histogram(e,300);
xlabel('Value');
ylabel('Count');
title('Histogram of e = Y - Y_{Q} with N = 32');
avg_power_error = mean(e.^2);
SQNR = mean(Y.^2) / avg_power_error;
SQNR_dB = 10 * log10(SQNR);
fprintf('Average power of nonuniform quantization error where N = 32: %f\n', avg_power_error);
fprintf('SQNR in dB: %f dB\n', SQNR_dB);
%%
figure(8);

for b = boundary
    plot([b, b], [0,1/8], 'k--'); 
    hold on;
end

for l = 1:length(levels)
    plot(levels(l), 0, 'r*');
    hold on;
end
plot([-8, 16], [0,0], 'k',LineWidth= 1);
hold on;
plot([0, 0], [0,1/8], 'k',LineWidth= 1);
hold on;
fplot(f, [-8, 16],'b');

% Labelling and displaying the plot
xlabel('Value');
ylabel('Level');
title('Nonuniform Quantization Boundaries and Levels for N = 32');
hold off;
%% PART 2.1:
%counts(1:1584) = 0;
dictionary = ["#","A", "B", "C", "D", "E" ...
              "F","G", "H", "I", "J", "K" ...
              "L","M","N", "O", "P", "Q" ...
              "R","S", "T", "U", "V", "W" ...
              "X","Y", "Z"," "];
init_dic_size = length(dictionary);
to_be_removed = ['0','1','2','3','4','5','6','7','8','9','[',']','.',',','!','?','-', '(',')'];
%raw_text = 'was never first at the time of yefim petrovitch s death alyosha had two more years to complete at the provincial gymnasium the inconsolable widow went almost immediately after his death for a long visit to italy with her whole family which consisted only of women and girls alyosha went to live in the house of two distant relations of yefim petrovitch ladies whom he had never seen before on what terms he lived with them he did not know himself it was very characteristic of him indeed that he never cared at whose expense he was living in that respect he was a striking contrast to his elder brother ivan who struggled with poverty for his first two years in the university maintained himself by his own efforts and had from childhood been bitterly conscious of living at the expense of his benefactor but this strange trait in alyosha s character must not i think be criticized too severely for at the slightest acquaintance with him any one would have perceived that alyosha was one of those youths almost of the type of religious enthusiast who if they were suddenly to come into possession of a large fortune would not hesitate to give it away for the asking either for good works or perhaps to a clever rogue in general he seemed scarcely to know the value of money not of course in a literal sense when he was given pocket‐money which he never asked for he was either terribly careless of it so that it was gone in a moment or he kept it for weeks together not knowing what to do with it in later years pyotr alexandrovitch miüsov a man very sensitive on the score of money and bourgeois honesty pronounced the following judgment after getting to know alyosha here is perhaps the one man in the world whom you might leave alone without a penny in the center of an unknown town of a million inhabitants and he would not come to harm he would not die of cold and hunger for he would be fed and sheltered at once and if he were not he would find a shelter for himself and it would cost him no effort or humiliation and to shelter him would be no burden but on the contrary would probably be looked on as a pleasure he did not finish his studies at the gymnasium a year before the end of the course he suddenly announced to the ladies that he was going to see his father about a plan which had occurred to him they were sorry and unwilling to let him go the journey was not an expensive one and the ladies would not let him pawn his watch a parting present from his benefactor s family they provided him liberally with money and even fitted him out with new clothes and linen but he returned half the money they gave him saying that he intended to go third class on his arrival in the town he made no answer to his father s first inquiry why he had come before completing his studies and seemed so they say unusually thoughtful it soon became apparent that he was looking for his mother s tomb he practically acknowledged at the time that that was the only object of his visit but it can hardly have been the whole reason of it it is more probable that he himself did not understand and could not explain what had suddenly arisen in his soul and drawn him irresistibly into a new unknown but inevitable path fyodor pavlovitch could not show him where his second wife was buried for he had never visited her grave since he had thrown earth upon her coffin and in the course of years had entirely forgotten where she was buried fyodor pavlovitch by the way had for some time previously not been living in our town three or four years after his wife s death he had gone to the south of russia and finally turned up in odessa where he spent several years he made the acquaintance at first in his own words of a lot of low jews jewesses and jewkins and ended by being received by jews high and low alike it may be presumed that at this period he developed a peculiar faculty for making and hoarding money he finally returned to our town only three years before alyosha s arrival his former acquaintances found him looking terribly aged although he was by no means an old man he behaved not exactly with more dignity but with more effrontery the former buffoon showed an insolent propensity for making buffoons of others his depravity with women was not simply what it used to be but even more revolting in a short time he opened a great number of new taverns in the district it was evident that he had perhaps a hundred thousand roubles or not much less many of the inhabitants of the town and district were soon in his debt and of course had given good security of late too he looked somehow bloated and seemed more irresponsible more uneven had sunk into a sort of incoherence used to begin one thing and go on with another as though he were letting himself go altogether he was more and more frequently drunk and if it had not been for the same servant grigory who by that time had aged considerably too and used to look after him sometimes almost like a tutor fyodor pavlovitch might have got into terrible scrapes alyosha s arrival seemed to affect even his moral side as though something had awakened in this prematurely old man which had long been dead in his soul do you know he used often to say looking at alyosha that you are like her ;the crazy woman that was what he used to call his dead wife alyosha s mother grigory it was who pointed out the crazy woman s grave to alyosha he took him to our town cemetery and showed him in a remote corner a cast‐iron tombstone cheap but decently kept on which were inscribed the name and age of the deceased and the date of her death and below a four‐lined verse such as are commonly used on old‐fashioned middle‐class tombs to alyosha#';
raw_text = 'the republic of plato is the longest of his works with the exception of the laws and is certainly the greatest of them there are nearer approaches to modern metaphysics in the philebus and in the sophist the politicus or statesman is more ideal the form and institutions of the state are more clearly drawn out in the laws as works of art the symposium and the protagoras are of higher excellence but no other dialogue of plato has the same largeness of view and the same perfection of style no other shows an equal knowledge of the world or contains more of those thoughts which are new as well as old and not of one age only but of all nowhere in plato is there a deeper irony or a greater wealth of humour or imagery or more dramatic power nor in any other of his writings is the attempt made to interweave life and speculation or to connect politics with philosophy the republic is the centre around which the other dialogues may be grouped here philosophy reaches the highest point especially in books which ancient thinkers ever attained plato among the greeks like bacon among the moderns was the first who conceived a method of knowledge although neither of them always distinguished the bare outline or form from the substance of truth and both of them had to be content with an abstraction of science which was not yet realized he was the greatest metaphysical genius whom the world has seen and in him more than in any other ancient thinker the germs of future knowledge are contained the sciences of logic and psychology which have supplied so many instruments of thought to afterages are based upon the analyses of socrates and plato the principles of definition the law of contradiction the fallacy of arguing in a circle the distinction between the essence and accidents of a thing or notion between means and ends between causes and conditions also the division of the mind into the rational concupiscent and irascible elements or of pleasures and desires into necessary and unnecessary these and other great forms of thought are all of them to be found in the republic and were probably first invented by plato the greatest of all logical truths and the one of which writers on philosophy are most apt to lose sight the difference between words and things has been most strenuously insisted on by although he has not always avoided the confusion of them in his own writings rep but he does not bind up truth in logical formulae logic is still veiled in metaphysics and the science which he imagines to contemplate all truth and all existence is very unlike the doctrine of the syllogism which aristotle claims to have discovered neither must we forget that the republic is but the third part of a still larger design which was to have included an ideal history of athens as well as a political and physical philosophy the fragment of the critias has give#';
for i = to_be_removed
    raw_text = strrep(raw_text,i,'');
end
final_message = upper(raw_text);
encoded_message = "";
bit_count = 0;
sample_count = 0;
i = 1;
while i <= length(final_message)
    char_list = final_message(i);
    while (i < length(final_message)) && ismember(string(char_list), dictionary)
        i = i + 1;
        char_list = horzcat(char_list, final_message(i));
    end
    
    if i == length(final_message) && ismember(string(char_list), dictionary)
        current = string(char_list);
        i = i+1;
    else
        current = string(char_list(1:end-1));
    end
    
    index = find(dictionary == current);
    if i < length(final_message)
        dictionary = horzcat(dictionary, string(char_list));
    end

    bit_count = bit_count + length(BIN_CODE(index-1,length(dictionary)));
    encoded_message = encoded_message + string(BIN_CODE(index-1,length(dictionary)));
end
encoded_message = char(encoded_message);


%% PART 2.2:
bit_length = ceil(log2(28));
fprintf('Average codeword length with no coding is: %f bits/sample!\n', bit_length);

LZW_ACL = length(encoded_message)/length(raw_text);
fprintf('Average codeword lenght after Lempel-Ziv Algorithm is: %f bits/sample!\n', LZW_ACL);

%% PART 2.3:

dictionary = ["#","A", "B", "C", "D", "E" ...
              "F","G", "H", "I", "J", "K" ...
              "L","M","N", "O", "P", "Q" ...
              "R","S", "T", "U", "V", "W" ...
              "X","Y", "Z"," "];
decode = "";
i = 1;
ct = 1;
while i<= length(encoded_message)
    bit_len = ceil(log2(length(dictionary)+2));
    char_list = encoded_message(i:i+bit_len - 1);
    indx = bin2dec(char_list);
    if ((indx - ct+2) == init_dic_size) && (i ~= 1)
        new_str = prev_str+prev_str;
    else
        new_str = dictionary(indx + 1);
    end
    decode = decode + new_str; 
    dumn_str = char(new_str);
    if (i ~=1)
        cnt = 1;
        dum_str = dumn_str(1:cnt);
        cnt = cnt + 1;
        while ismember(prev_str + dum_str,dictionary)
            dum_str = dum_str(1:cnt);
            cnt = cnt + 1;
        end
        dictionary = horzcat(dictionary,prev_str + dum_str);

    end
    prev_str = new_str;
    i = i+ bit_len;
    ct = ct + 1;
end

decode = char(decode);
equality = (string(decode) == string(final_message(1:end)));
status = "NOT-EQUAL";
if equality == 1
    status = "EQUAL";
end

fprintf("Success status of the transmitted messages is the following: %s\n",status)

%% PART 2.4
counts(1:init_dic_size) = 0;
for i = 1:init_dic_size
    counts(i) = sum(final_message == char(dictionary(i)));
end

count_sum = sum(counts);
pmf = counts/count_sum;
figure(9);
bar(pmf);
xlabel('Index of the dictionary element');
ylabel('Probability');
title('Probability-Index plot of dictionary elements');
entropy = 0;
for i = pmf
    if i ~= 0
    entropy = entropy + -i*log2(i);
    end
end
 

fprintf('Entropy of the transmitted text is: %f bits/sample!\n', entropy);

function bin_code = BIN_CODE(num, max_value)
    % Determine the number of bits required
    num_bits = ceil(log2(max_value));
    % Convert the number to binary
    bin_str = dec2bin(num);
    
    % Pad the binary string
    padded_bin_str = pad(bin_str, num_bits, 'left', '0');
    
    bin_code = padded_bin_str;
end

