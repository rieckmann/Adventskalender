clc
clear

file = fileread('A11.txt');

%% preprocessing
data = str2num(file);

%% actual code
adventdriver(@part1, data);

adventdriver(@part2, data);

function r = part1(data)

    % provide for all digits the base tree
    % table = cell(10,1);
    % for i=0:9
    %     table{i+1} = blinkTree(i, 0);
    % end

    blinks = 25;

    global stonecache;
    stonecache = zeros(0,3);
    result = zeros(numel(data),1);
    for i=1:numel(data)
        stone = data(i);
        result(i) = blink(stone, blinks);
    end
    r = sum(result);
end

function r = part2(data)
    blinks = 75;

    global stonecache;
    stonecache = zeros(0,3);
    result = zeros(numel(data),1);
    for i=1:numel(data)
        stone = data(i);
        result(i) = blink(stone, blinks);
    end
    r = sum(result);
end

global stonecache;

function r = blink(stone, blinks)
    global stonecache;
    
    key1 = stone;
    key2 = blinks;
    idx = find(stonecache(:,1) == key1 & stonecache(:,2) == key2);
    if ~isempty(idx)
        r = stonecache(idx,3);
        return;
    end

    if blinks == 0
        r = 1;
    elseif stone == 0
        r = blink(1, blinks-1);
    else
        digits = num2str(stone);
        n = numel(digits);
        if rem(n,2) == 0
            left = str2double(digits(1:n/2));
            right = str2double(digits(n/2+1:end));
            r = blink(left, blinks-1) + blink(right, blinks-1);
        else
            r = blink(stone*2024,blinks-1);
        end
    end

    stonecache = [stonecache; stone, blinks, r];
end

function tree = blinkTree(stone, level)
    digits = num2str(stone);
    n = numel(digits);

    if level > 0 && n ==1
        tree = {[stone, level],[]};
        return;
    end
    level = level + 1;

    if stone == 0
        stone = 1;
        tree = blinkTree(stone,level);
    elseif rem(n,2) == 0
        left = str2double(digits(1:n/2));
        right = str2double(digits(n/2+1:end));

        digitsl = num2str(left);
        nl = numel(digitsl);
        digitsr = num2str(right);
        nr = numel(digitsr);
        tree = cell(2,2);
        tree{1,1} = {[left, level]};
        tree{2,1} = {[right, level]};
        if nl > 1;
            tree{1,2} = blinkTree(left, 1);
        end
        if nr > 1;
            tree{2,2} = blinkTree(right, 1);
        end        
    else
        stone = stone*2024;
        tree = blinkTree(stone,level);
    end
end