clc
clear all

txt = readlines("A06.txt");
txt = regexprep(txt, '[^\d]+', ' ');
data = arrayfun(@str2num, split(strtrim(txt)));
count = (data(1,:)+1) - 2*[ceil(data(1,:)/2-sqrt((data(1,:)/2).^2-(data(2,:)+1)))]; % record + 1: we need o beat the record
disp(['Part 1 solution: ', num2str(prod(count))])

txt = regexprep(txt, '[^\d]+', '');
data = arrayfun(@str2num, split(strtrim(txt)));
count = (data(1,:)+1) - 2*[ceil(data(1,:)/2-sqrt((data(1,:)/2).^2-(data(2,:)+1)))]; % record + 1: we need o beat the record
disp(['Part 2 solution: ', num2str(prod(count))])
