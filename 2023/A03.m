clc
clear all

in = regexprep(fileread('A03.txt'),{'\r','\n'},{'',''});

numberIds = regexp(in, '(\d+)', 'tokenExtents');
numbers = regexp(in, '(\d+)', 'tokens');
validnums = numbers(cellfun(@(Y) valid(Y,in), numberIds) == 1);
disp(['Part 1 solution: ', num2str(sum(cellfun(@(Y) str2num(convertCharsToStrings(Y)), validnums)))])

gearcandidates = cellfun(@(Y) findgearcandidate(Y,in), numberIds);
uniquegearcandidates = unique(gearcandidates);
gearIds = uniquegearcandidates(1<histc(gearcandidates,uniquegearcandidates));
gearIds = gearIds(2:end); % skip 0
gearratios = arrayfun(@(Y) gearratio(Y, gearcandidates, numbers), gearIds);
disp(['Part 2 solution: ', num2str(sum(gearratios))])

function x = valid(Y, in)    
    length = Y(2)-Y(1) + 1;
    maxindex = size(in, 2);
    cluster = min(max([linspace(Y(1)-141, Y(2)-139, length + 2), Y(1)-1, Y(2)+1, linspace(Y(1)+139, Y(2)+141, length + 2)], 1), maxindex);
    characters = in(cluster);
    x = ~isempty(regexp(characters,'[^\d.]'));
end

function x = findgearcandidate(Y, in)    
    length = Y(2)-Y(1) + 1;
    maxindex = size(in, 2);
    cluster = min(max([linspace(Y(1)-141, Y(2)-139, length + 2), Y(1)-1, Y(2)+1, linspace(Y(1)+139, Y(2)+141, length + 2)], 1), maxindex);
    characters = in(cluster);
    x = cluster(characters == '*');
    if isempty(x)
        x = 0;
    end
end

function x = gearratio(Y, gears, numbers)    
    N = numbers(gears == Y);
    x = str2num(convertCharsToStrings(N{1})) * str2num(convertCharsToStrings(N{2}));
end