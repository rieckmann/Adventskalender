clc
clear all

txt = readlines('A01.txt');

n = size(txt, 1);

%% part 1
sum = 0;
for i=1:n
    line = txt{i};
    digits = extract(line, digitsPattern);
    digits = [digits{:}];
    first = digits(1);
    last = digits(end);
    joined = str2num([first, last]);
    sum = sum + joined;
end
disp(['Part 1 solution:', num2str(sum)])

%% part 2
sum = 0;
patterns = ["one"; "two"; "three"; "four"; "five"; "six"; "seven"; "eight"; "nine"];
indices = [1, 2, 6; ...
            4, 5, 9; ...
            3, 7, 8];
for i=1:n
    line = txt{i};
    m = size(line,2);
    
    digits = [];
    for j=1:m
        if isstrprop(line(j),'digit')
            digits = [digits, line(j)];
        else
            for l=1:3
                if j<=m-(l+1);
                    candidate = convertCharsToStrings(line(j:j+(l+1)));
                    for k=1:3
                        if candidate == patterns(indices(l,k));
                            digits = [digits, num2str(indices(l,k))];
                        end
                    end  
                end
            end     
        end
    end
    first = digits(1);
    last = digits(end);
    joined = str2num([first, last]);
    sum = sum + joined;
end
disp(['Part 2 solution:', num2str(sum)])

