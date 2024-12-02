clc
clear all

data = importdata('A01.txt',' ');

%% part 1
adventdriver(@part1, data);

%% part 2
adventdriver(@part2, data);


function [r] = part1(data)
    data=sort(data);
    r = sum(abs(data(:,1)-data(:,2)));
end

function [r] = part2(data)
    r = 0;
    for i=1:size(data,1)
        num = data(i,1);
        count = sum(data(:,2) == num);
        r = r + count * num;
    end
end