clc
clear all

data = readlines("A07.txt");
data = split(data, ' ');
T = table(data(:,1), arrayfun(@str2double, data(:,2)),'VariableNames', {'Hand', 'Value'});
T = [T, rowfun(@(x) gettype(x,1), T, "InputVariables",["Hand"], "OutputVariableNames", "Type")];
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
T(:,3) = rowfun(@(x) gettype(x,2), T, "InputVariables", ["Hand"], "OutputVariableNames", "Type");
T = sortrows(T, [3 4 5 6 7 8]);

total2 = 0;
for i=1:height(T)
    total2 = total2 + i*T.Value(i);
end
disp(['Part 2 solution: ', num2str(total2)])


function type = gettype(hand,part)
    hand = double(convertStringsToChars(hand));
    cards = unique(hand);
    counts = [cards; histcounts(hand, [cards, cards(end)+1])];
    if part == 1    
        type = sum(arrayfun(@(x) 3^x, counts(2,:)));
        return;
    end
    joker = counts(2,counts(1,:)==74);
    if ~isempty(joker) && joker < 5
        jokerCol = find(counts(1,:) == 74);
        counts(:,jokerCol) = [];
        counts = sortrows(counts',2, 'descend');
        counts(1,2) = counts(1,2) + joker;
        counts = counts';
    end
    type = sum(arrayfun(@(x) 3^x, counts(2,:)));
end

function value = getvalue(hand, i)
    mapping = [double('23456789TJQKA');2:1:14];
    hand = double(convertStringsToChars(hand));
    value = mapping(2,mapping(1,:) == hand(i));
end
