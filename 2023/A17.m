clc
clear all

data = readlines('A17.txt');
data = cell2mat(arrayfun(@(x) double(convertStringsToChars(x)) - 48, data, 'UniformOutput', false));

way = zeros(size(data));
cost = zeros(size(data));
cost = data;

for i=1:size(data,1)
    for j=1:size(data,2)
        if i > 1 && j > 1            
            if cost(i,j-1) <= cost(i-1,j)
                cost(i,j) = cost(i,j) + cost(i,j-1);
                way(i,j) = -141;
            else
                cost(i,j) = cost(i,j) + cost(i-1,j);
                way(i,j) = -1;
            end
        elseif i == 1 && j > 1
            cost(i,j) = cost(i,j) + cost(i,j-1);
            way(i,j) = -141;
        elseif i > 1 && j == 1
            cost(i,j) = cost(i,j) + cost(i-1,j);
            way(i,j) = -1;
        else
            cost(i,j) = 0;
        end        
    end
end
cost(end)

k = numel(way);
path = zeros(size(way));
while k~=1
    path(k) = 1;
    k = k + way(k);
end
path(1) = 1;
spy(path);