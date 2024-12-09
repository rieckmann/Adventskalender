clc
clear all
close all

file = fileread('A09.txt');

%% preprocessing
data = zeros(numel(file),1);
for i=1:numel(file)
    data(i) = str2num(file(i));
end

%% actual code
adventdriver(@part1, data); % 6421128769094

adventdriver(@part2, data);

function r = part1(data)
    N = numel(data);
    if rem(N,2) == 0
        files = data(1:2:N-1);
        spaces = data(2:2:N);
    else
        files = data(1:2:N);
        spaces = data(2:2:N-1);
    end
    
    r = 0;
    disk = zeros(sum(data), 1);
    idx = 1;
    id = 0;
    isfile = 1;
    for i=1:numel(data)
        for j=1:data(i)
            if isfile
                disk(idx) = id;
            else
                disk(idx) = -1;
            end
            idx = idx + 1;
        end
        if isfile
            id = id +1;
        end
        isfile = ~isfile;
    end

    loc = 1;
    invloc = numel(disk);
    while invloc >= loc 
        if disk(loc) == -1
            while disk(invloc) == -1
                invloc = invloc - 1;
            end
            disk(loc) = disk(invloc);
            disk(invloc) = -1;
            invloc = invloc - 1;
        end
        r = r + (loc-1) * disk(loc);
        loc = loc + 1;
    end
end

function r = part2(data)
    N = numel(data);
    start = zeros(N,1);
    idx = 1;
    for i=1:N
        start(i) = idx;
        idx = idx + data(i);
    end

    if rem(N,2) == 0
        files = data(1:2:N-1);
        spaces = data(2:2:N);  
        spaces_start = start(2:2:N); 
        files_start = start(1:2:N-1);
    else
        files = data(1:2:N);
        spaces = data(2:2:N-1);
        spaces_start = start(2:2:N-1);  
        files_start = start(1:2:N);  
    end
    
    
    
    % original disk
    r = 0;
    disk = zeros(sum(data), 1);
    idx = 1;
    id = 0;
    isfile = 1;
    for i=1:numel(data)
        for j=1:data(i)
            if isfile
                disk(idx) = id;
            else
                disk(idx) = -1;
            end
            idx = idx + 1;
        end
        if isfile
            id = id +1;
        end
        isfile = ~isfile;
    end

    % compacted disk
    for i=1:numel(files)
        ii = numel(files)-(i-1);        
        id = ii-1;
        size = files(ii);
        p = find(spaces >= size);
        if ~isempty(p) && spaces_start(p(1)) < files_start(ii)
            spaces(p(1)) = spaces(p(1))-size;
            disk(spaces_start(p(1)):spaces_start(p(1))+size-1) = id;
            disk(files_start(ii):files_start(ii)+size-1) = -1;
            spaces_start(p(1)) = spaces_start(p(1)) + size;
        end

    end
    
    % compute check sum
    for i=1:numel(disk)
        if disk(i) ~= -1
            r = r + (i-1) * disk(i);
        end
    end
end