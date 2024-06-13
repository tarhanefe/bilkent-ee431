%% PART 2.1:
counts(1:1584) = 0;
dictionary = ["#","A", "B", "C", "D", "E" ...
              "F","G", "H", "I", "J", "K" ...
              "L","M","N", "O", "P", "Q" ...
              "R","S", "T", "U", "V", "W" ...
              "X","Y", "Z"," "];
to_be_removed = ['0','1','2','3','4','5','6','7','8','9','[',']','.',',','!','?','-', '(',')'];
raw_text = 'abbbbb#';
%raw_text = 'The economic situation in Russia before the revolution presented a grim picture. The government had experimented with laissez-faire capitalist policies, but this strategy largely failed to gain traction within the Russian economy until the 1890s. Meanwhile, agricultural productivity stagnated, while international prices for grain dropped, and Russias foreign debt and need for imports grew. War and military preparations continued to consume government revenues. At the same time, the peasant taxpayers ability to pay was strained to the utmost, leading to widespread famine in 1891.In the 1890s, under Finance Minister Sergei Witte, a crash governmental program was proposed to promote industrialization. His policies included heavy government expenditures for railroad building and operations, subsidies and supporting services for private industrialists, high protective tariffs for Russian industries (especially heavy industry), an increase in exports, currency stabilization, and encouragement of foreign investments.[19] His plan was successful and during the 1890s Russian industrial growth averaged 8 percent per year. Railroad mileage grew from a very substantial base by 40 percent between 1892 and 1902.[19] Ironically, Wittes success in implementing this program helped spur the 1905 revolution and eventually the 1917 revolution because it exacerbated social tensions. Besides dangerously concentrating a proletariat, a professional and a rebellious student body in centers of political power, industrialization infuriated both these new forces and the traditional rural classes.[20] The government policy of financing industrialization through taxing peasants forced millions of peasants to work in towns. The peasant worker saw his labor in the factory as the means to consolidate his familys economic position in the village and played a role in determining the social consciousness of the urban proletariat. The new concentrations and flows of peasants spread urban ideas to the countryside, breaking down isolation of peasants on communes.[21].Industrial workers began to feel dissatisfaction with the Tsarist government despite the protective labour laws the government decreed. Some of those laws included the prohibition of children under 12 from working, with the exception of night work in glass factories. Employment of children aged 12 to 15 was prohibited on Sundays and holidays. Workers had to be paid in cash at least once a month, and limits were placed on the size and bases of fines for workers who were tardy. Employers were prohibited from charging workers for the cost of lighting of the shops and plants.[13] Despite these labour protections, the workers believed that the laws were not enough to free them from unfair and inhumane practices. At the start of the 20th century, Russian industrial workers worked on average 11-hours per day (10 hours on Saturday), factory conditions were perceived as grueling and often unsafe, and attempts at independent unions were often not accepted.[22] Many workers were forced to work beyond the maximum of 11 and a half hours per day. Others were still subject to arbitrary and excessive fines for tardiness, mistakes in their work, or absence.[23] Russian industrial workers were also the lowest-wage workers in Europe. Although the cost of living in Russia was low, the average workers 16 rubles per month could not buy the equal of what the French workers 110 francs would buy for him.[23] Furthermore, the same labour laws prohibited the organisation of trade unions and strikes. Dissatisfaction turned into despair for many impoverished workers, which made them more sympathetic to radical ideas.[23] These discontented, radicalized workers became key to the revolution by participating in illegal strikes and revolutionary protests.The government responded by arresting labour agitators and enacting more paternalistic legislation.#';
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

    sample_count = sample_count + 1;
    bit_count = bit_count + length(BIN_CODE(index-1,length(dictionary)));
    encoded_message = encoded_message + string(BIN_CODE(index-1,length(dictionary)));
    counts(index) = counts(index) + 1;
end
encoded_message = char(encoded_message);


%% PART 2.2:
bit_length = ceil(log2(28));
fprintf('Average codeword length with no coding is: %f bits/sample!\n', bit_length);

LZW_ACL = bit_count/sample_count;
fprintf('Average codeword lenght after Lempel-Ziv Algorithm is: %f bits/sample!\n', LZW_ACL);

%% PART 2.3:

dictionary = ["#","A", "B", "C", "D", "E" ...
              "F","G", "H", "I", "J", "K" ...
              "L","M","N", "O", "P", "Q" ...
              "R","S", "T", "U", "V", "W" ...
              "X","Y", "Z"," "];
decode = "";
init_dic_size = length(dictionary);
i = 1;
ct = 1;
while i<= length(encoded_message)
    bit_len = ceil(log2(length(dictionary)+3));
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
%%
function bin_code = BIN_CODE(num, max_value)
    % Determine the number of bits required
    if mod(log2(max_value), 1) ~= 0
        num_bits = ceil(log2(max_value));
    else 
        num_bits = ceil(log2(max_value +1 ));
    end
    % Convert the number to binary
    bin_str = dec2bin(num);
    
    % Pad the binary string
    padded_bin_str = pad(bin_str, num_bits, 'left', '0');
    
    bin_code = padded_bin_str;
end