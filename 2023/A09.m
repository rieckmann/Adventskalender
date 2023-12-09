clc
clear all

data = importdata('A09.txt',' ');
tic
disp(['Part 1 solution: ', num2str(sum(arrayfun(@(idx) sum(reduce1(data(idx,:))), (1:size(data,1))')))])
disp(['Part 2 solution: ', num2str(sum(arrayfun(@(idx) dot(reduce2(data(idx,:)),(-1).^(0:size(data,2)-1)), (1:size(data,1))')))])
toc

function x = reduce1(x)
    y = circshift(x,-1) - x;
    x(1:end-1) = y(1:end-1);
    if sum(x(1:end-1)) ~= 0
        x(1:end-1) = reduce1(x(1:end-1));
    end
end

function x = reduce2(x)
    y = circshift(x,-1) - x;
    x(2:end) = y(1:end-1);
    if sum(x(2:end)) ~= 0
        x(2:end) = reduce2(x(2:end));
    end
end


