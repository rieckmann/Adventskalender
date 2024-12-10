clc
clear all
close all

file = fileread('A10.txt');

%% preprocessing
data = arrayfun(@(x) str2num(x),char(splitlines(file)));


%% actual code
adventdriver(@part1, data);

adventdriver(@part2, data);

function r = part1(data)
    idx0 = find(data == 0);

    r = 0;
    for i=1:numel(idx0)
        nodes = findstep(data, idx0(i));
        r = r + numel(unique(nodes));
    end

    function nodes = findstep(data, current)
        nodes = [];
        if data(current) == 9
            nodes = current;
        else
            [n,m] = size(data);
            [in, im] = ind2sub([n,m], current);
            neighbors = [];
            if in < n
                neighbors = [neighbors, current + 1];
            end
            if in > 1
                neighbors = [neighbors, current - 1];
            end
            if im < m
                neighbors = [neighbors, current + n];
            end
            if im > 1
                neighbors = [neighbors, current - n];
            end
            next = find(data(neighbors) == data(current) + 1);
            for i=1:numel(next)
                nodes = [ nodes, findstep(data, neighbors(next(i)))];
            end
        end
    end
end

function r = part2(data)
    idx0 = find(data == 0);

    r = 0;
    for i=1:numel(idx0)
        nodes = findstep(data, idx0(i));
        r = r + numel(nodes);
    end

    function nodes = findstep(data, current)
        nodes = [];
        if data(current) == 9
            nodes = current;
        else
            [n,m] = size(data);
            [in, im] = ind2sub([n,m], current);
            neighbors = [];
            if in < n
                neighbors = [neighbors, current + 1];
            end
            if in > 1
                neighbors = [neighbors, current - 1];
            end
            if im < m
                neighbors = [neighbors, current + n];
            end
            if im > 1
                neighbors = [neighbors, current - n];
            end
            next = find(data(neighbors) == data(current) + 1);
            for i=1:numel(next)
                nodes = [ nodes, findstep(data, neighbors(next(i)))];
            end
        end
    end
end