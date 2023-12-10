clc
clear all

file = fopen('A10.txt');
data = fread(file,[142, 140])';
data = data(:,1:140);
symbols = ['|','-','L','J','7','F','.','S'];
values = double(symbols);
[steps, loop] = extractloop(data);
P = numel(steps);
disp(['Part 1 solution: ', num2str(length(steps)/2)])

pipes = nan(size(data));

pipes(steps) = 0;
dir = 0;
for i=1:length(steps)
    v = loop(i);
    if v == 124
        if dir == 2
            pipes = countrecursive(pipes, steps(i)+140,1);
            pipes = countrecursive(pipes, steps(i)-140,-1);
            dir = 2;
        elseif dir == 3
            pipes = countrecursive(pipes, steps(i)-140,1);
            pipes = countrecursive(pipes, steps(i)+140,-1);
            dir = 3;
        end
    elseif v == 45
        if dir == 0
            pipes = countrecursive(pipes, steps(i)-1,1);
            pipes = countrecursive(pipes, steps(i)+1,-1);
            dir = 0;
        elseif dir == 1
            pipes = countrecursive(pipes, steps(i)+1,1);
            pipes = countrecursive(pipes, steps(i)-1,-1);
            dir = 1;
        end
    elseif v == 76
        if dir == 2
            pipes = countrecursive(pipes, steps(i)+139,1);
            pipes = countrecursive(pipes, steps(i)-139,-1);
            pipes = countrecursive(pipes, steps(i)-140,-1);
            pipes = countrecursive(pipes, steps(i)+1,-1);
            dir = 0;
        elseif dir == 1
            pipes = countrecursive(pipes, steps(i)-139,1);
            pipes = countrecursive(pipes, steps(i)-140,1);
            pipes = countrecursive(pipes, steps(i)+1,1);
            pipes = countrecursive(pipes, steps(i)+139,-1);
            dir = 3;
        end
    elseif v == 74
        if dir == 0
            pipes = countrecursive(pipes, steps(i)-141,1);
            pipes = countrecursive(pipes, steps(i)+141,-1);
            pipes = countrecursive(pipes, steps(i)+140,-1);
            pipes = countrecursive(pipes, steps(i)+1,-1);
            dir = 3;
        elseif dir == 2
            pipes = countrecursive(pipes, steps(i)+141,1);
            pipes = countrecursive(pipes, steps(i)+140,1);
            pipes = countrecursive(pipes, steps(i)+1,1);
            pipes = countrecursive(pipes, steps(i)-141,-1);
            dir = 1;
        end
    elseif v == 55
        if dir == 0
            pipes = countrecursive(pipes, steps(i)+139,1);
            pipes = countrecursive(pipes, steps(i)-1,1);
            pipes = countrecursive(pipes, steps(i)+140,1);
            pipes = countrecursive(pipes, steps(i)-139,-1);
            dir = 2;
        elseif dir == 3
            pipes = countrecursive(pipes, steps(i)-139,1);
            pipes = countrecursive(pipes, steps(i)+139,-1);
            pipes = countrecursive(pipes, steps(i)+140,-1);
            pipes = countrecursive(pipes, steps(i)-1,-1);
            dir = 1;
        end
    elseif v == 70
        if dir == 1
            pipes = countrecursive(pipes, steps(i)+141,1);
            pipes = countrecursive(pipes, steps(i)-141,-1);
            pipes = countrecursive(pipes, steps(i)-1,-1);
            pipes = countrecursive(pipes, steps(i)-140,-1);
            dir = 2;
        elseif dir == 3
            pipes = countrecursive(pipes, steps(i)-141,1);
            pipes = countrecursive(pipes, steps(i)-140,1);
            pipes = countrecursive(pipes, steps(i)-1,1);
            pipes = countrecursive(pipes, steps(i)+141,-1);
            dir = 0;
        end
    end
end
L = sum(numel(find(pipes == 1)));
R = sum(numel(find(pipes == -1)));
L+P+R
disp(['Part 1 solution: ', num2str(R)]) % by visual the "right" part of the curve is "inside"


function [steps, loop] = extractloop(S);
    start = find(S == double('S')); % i manually checked, S is connected to the left and right.
    step = start + 140;
    steps = [start];
    loop = [S(step)];
    dir = 0; % 0:east, 1:west, 2:south, 3:north
    while step ~=start
        v = S(step);
        steps = [steps, step];        
        loop = [loop, v];     
        if v == 124
            if dir == 2
                step = step + 1;
                dir = 2;
            elseif dir == 3
                step = step - 1;
                dir = 3;
            end
        elseif v == 45
            if dir == 0
                step = step + 140;
                dir = 0;
            elseif dir == 1
                step = step - 140;
                dir = 1;
            end
        elseif v == 76
            if dir == 2
                step = step + 140;
                dir = 0;
            elseif dir == 1
                step = step - 1;
                dir = 3;
            end
        elseif v == 74
            if dir == 0
                step = step - 1;
                dir = 3;
            elseif dir == 2
                step = step - 140;
                dir = 1;
            end
        elseif v == 55
            if dir == 0
                step = step + 1;
                dir = 2;
            elseif dir == 3
                step = step - 140;
                dir = 1;
            end
        elseif v == 70
            if dir == 1
                step = step + 1;
                dir = 2;
            elseif dir == 3
                step = step + 140;
                dir = 0;
            end
        end
    end  
    
end

function X = countrecursive(X, idx,color)
    if idx >= 1 && idx <= numel(X) && isnan(X(idx))
        X(idx)=color;
        candidates = [(idx-1:idx+1)-140, (idx-1:idx+1), (idx-1:idx+1)+140];
        for i=1:length(candidates)
            X = countrecursive(X,candidates(i),color);
        end
    end
end