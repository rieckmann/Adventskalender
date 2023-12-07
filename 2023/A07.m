clc
clear all

data = readlines("A07.txt");
data = split(data, ' ');
T = table(data(:,1), arrayfun(@str2double, data(:,2)),'VariableNames', {'Hand', 'Value'});
T = [T, rowfun(@gettype, T, "InputVariables",["Hand"], "OutputVariableNames", "Type")];
for i=1:5
    T = [T, rowfun(@(x) getvalue(x,i), T, "InputVariables",["Hand"], "OutputVariableNames", "ValueCard" + num2str(i))];
end

T = sortrows(T, [3 4 5 6 7 8]);

total = 0;
for i=1:height(T)
    total = total + i*T.Value(i);
end
disp(['Part 1 solution: ', num2str(total)])


for i=1:5
    t = table2array(T(:,3+i));
    t(t == 11) = 1;
    T(:,3+i) =array2table(t);
end
T = sortrows(T, [3 4 5 6 7 8]);

total2 = 0;
for i=1:height(T)
    total2 = total2 + i*T.Value(i);
end
disp(['Part 2 solution: ', num2str(total2)])


function type = gettype(hand)
    hand = double(convertStringsToChars(hand));
    cards = unique(hand);
    type = sum(arrayfun(@(x) 3^x,histcounts(hand, [cards, cards(end)+1])));
end

function value = getvalue(hand, i)
    mapping = [double('23456789TJQKA');2:1:14];
    hand = double(convertStringsToChars(hand));
    value = mapping(2,mapping(1,:) == hand(i));
end
