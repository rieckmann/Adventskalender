clc
clear all
close all

file = fileread('A05.txt');

%% preprocessing
file = regexp(file,'\r?\n\r?\n', 'split');
file{1,1} = splitlines(file{1,1});
file{1,2} = splitlines(file{1,2});

rules = zeros(numel(file{1,1}),2);
for i=1:numel(file{1,1})
    split = regexp(file{1,1}(i),'\|', 'split');
    rules(i,1) = str2num(split{1});
    rules(i,2) = str2num(split{2});
end

instructions = cell(numel(file{1,2}),1);
for i=1:numel(file{1,2})
    split = regexp(file{1,2}(i),',', 'split');
    N = numel(split);
    instruction = zeros(1, N);
    for j=1:N
        instruction(1,j) = str2num(split{j});
    end
    instructions{i,1} = instruction;
end

data = {rules, instructions};

%% actual code
adventdriver(@part1, data);

adventdriver(@part2, data);

function r = part1(data)
    rules = data{1,1};
    instructions = data{1,2};
    
    r = 0;
    for i=1: numel(instructions)
        instruction = instructions{i};
        
        valid = true;
        for j=1:numel(instruction)
            num = instruction(j);
            first = instruction(1:j-1);
            last = instruction(j+1:end);
            
            % forward, check that there is no rule break
            candidates = rules(any(rules(:,2) == num,2),1);
            valid = ~any(any(candidates == last));            
            if ~valid
                break;
            end
            
            % backward, check that there is no rule break
            candidates = rules(any(rules(:,1) == num,2),2);
            valid = ~any(any(candidates == first));            
            if ~valid
                break;
            end
        end
        
        if valid
            r = r+instruction((numel(instruction)+1)/2);
        end
    end    
    
end

function r = part2(data)
    rules = data{1,1};
    instructions = data{1,2};
    
    r = 0;
    for i=1: numel(instructions)
        instruction = instructions{i};
        
        valid = true;
        corrected = false;
        j = 1;
        while j <= numel(instruction)
            num = instruction(j);
            first = instruction(1:j-1);
            last = instruction(j+1:end);
            
            % forward, check that there is no rule break
            candidates = rules(any(rules(:,2) == num,2),1);
            for k=1:size(candidates,1)
                valid = ~any(candidates(k)==last);
                if ~valid
                    instruction(instruction==candidates(k)) = num;
                    instruction(j) = candidates(k);
                    break; 
                end
            end
            if ~valid
                j = 1;
                valid = true;
                corrected = true;
                continue; 
            end
            
            % backward, check that there is no rule break
            candidates = rules(any(rules(:,1) == num,2),2);
            for k=1:size(candidates,1)
                valid = ~any(candidates(k)==first);
                if ~valid                    
                    instruction(instruction==candidates(k)) = num;
                    instruction(j) = candidates(k);
                    break; 
                end
            end
            if ~valid
                j = 1;
                valid = true;
                corrected = true;
                continue; 
            end
            j = j+1;
        end
        
        if corrected
            r = r+instruction((numel(instruction)+1)/2);
        end

    end    
    
end